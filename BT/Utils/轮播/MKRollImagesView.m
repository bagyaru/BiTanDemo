//
//  MKRollImagesView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKRollImagesView.h"
#import <PunchScrollView.h>
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "UIColor+MKExtension.h"
#import "THFPageControl.h"
#import "THFZXPageC.h"
#define DurationOfScroll 4.0f


@interface MKRollImagesView () <PunchScrollViewDataSource, PunchScrollViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PunchScrollView *scrollView;

@property (nonatomic, strong) THFPageControl *pageC;
@property (nonatomic, strong) THFZXPageC     *pageControl1;
@property (nonatomic, strong) UILabel       *titleLabel;//标题
@property (nonatomic, strong) UILabel       *typeLabel;//类型
@property (nonatomic, strong) UILabel       *keywordsLabel;//关键词

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) BOOL isAutoScroll;

@end


@implementation MKRollImagesView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bannerUrls"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    return self;
}

//这里开始写代码
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initViews];
}

- (void)initViews
{
    
    NSLog(@"%@",[BTThreeManager sharedInstance].typeStr);
    if ([[BTThreeManager sharedInstance].typeStr isEqualToString:@"首页"]) {
        self.scrollView = [[PunchScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.dataSource = self;
        self.scrollView.infiniteScrolling = YES;
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.pageC = [[THFPageControl alloc] init];
        [self addSubview:self.pageC];
        self.pageC.enabled = NO;
        self.pageC.frame = CGRectMake(0, 170, ScreenWidth, 2);
        [self addObserver:self forKeyPath:@"bannerUrls" options:NSKeyValueObservingOptionNew context:NULL];
        
        if ([self.pageC respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
        {
            self.pageC.currentPageIndicatorTintColor = kHEXCOLOR(0xffffff);
        }
        if ([self.pageC respondsToSelector:@selector(setPageIndicatorTintColor:)])
        {
            
            self.pageC.pageIndicatorTintColor = kHEXCOLOR(0xdddddd);
        }

    }
    if ([[BTThreeManager sharedInstance].typeStr isEqualToString:@"发现"]) {
        
        self.scrollView = [[PunchScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.dataSource = self;
        self.scrollView.infiniteScrolling = YES;
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
        self.pageC = [[THFPageControl alloc] init];
        [self addSubview:self.pageC];
        self.pageC.enabled = NO;
        
        self.pageC.frame = CGRectMake(0, 85, ScreenWidth, 2);
        
        [self addObserver:self forKeyPath:@"bannerUrls" options:NSKeyValueObservingOptionNew context:NULL];
        
        if ([self.pageC respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
        {
            self.pageC.currentPageIndicatorTintColor = kHEXCOLOR(0xffffff);
        }
        if ([self.pageC respondsToSelector:@selector(setPageIndicatorTintColor:)])
        {
            
            self.pageC.pageIndicatorTintColor = kHEXCOLOR(0xdddddd);
        }
    }
    if ([[BTThreeManager sharedInstance].typeStr isEqualToString:@"社区"]) {
        
        self.scrollView = [[PunchScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.dataSource = self;
        self.scrollView.infiniteScrolling = YES;
        [self addSubview:self.scrollView];
        [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self addObserver:self forKeyPath:@"bannerUrls" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"titles" options:NSKeyValueObservingOptionNew context:NULL];
        UIView *backV = [[UIView alloc] init];
        backV.frame = CGRectMake(0, 125, ScreenWidth, 55);
        backV.backgroundColor = KClearColor;
        [self addSubview:backV];
        UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        imageIV.image = IMAGE_NAMED(@"sheQuBanner_black");
        [backV addSubview:imageIV];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(15, 0, ScreenWidth-95, 55);
        self.titleLabel.textColor = KWhiteColor;
        self.titleLabel.font = FONT(PF_MEDIUM, 16);
        //self.titleLabel.backgroundColor = KRedColor;
        [backV addSubview:self.titleLabel];
        
        self.pageC = [[THFPageControl alloc] init];
        [backV addSubview:self.pageC];
        
        self.pageC.frame = CGRectMake(ScreenWidth-65, (55-2)/2+5, 50, 2);
        
        if ([self.pageC respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
        {
            self.pageC.currentPageIndicatorTintColor = kHEXCOLOR(0xffffff);
        }
        if ([self.pageC respondsToSelector:@selector(setPageIndicatorTintColor:)])
        {
            
            self.pageC.pageIndicatorTintColor = kHEXCOLOR(0xdddddd);
        }
    }
}

- (void)autoRollEnable:(BOOL)enable
{
    self.isAutoScroll = enable;
    [self autoRoll:enable];
}

- (void)autoRoll:(BOOL)enable
{
    if (!enable)
    {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
    else if (self.scrollTimer == nil)
    {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:DurationOfScroll target:self
                                                          selector:@selector(swipeViewCircleAction:) userInfo:nil repeats:YES];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bannerUrls"] || [keyPath isEqualToString:@"titles"])
    {
        [self.scrollView reloadData];
        self.pageC.numberOfPages = self.bannerUrls.count;
        self.pageC.currentPage = 0;
    }
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDataSource ---------------------

- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
    return self.bannerUrls.count > 0 ? self.bannerUrls.count : self.images.count;
}

- (UIView*)punchScrollView:(PunchScrollView*)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[BTThreeManager sharedInstance].typeStr isEqualToString:@"发现"]) {
        UIView *pageView = (UIView *)[scrollView dequeueRecycledPage];
        UIImageView *imageView;
        if (pageView == nil){
            pageView = [[UIView alloc] initWithFrame:scrollView.bounds];
            pageView.backgroundColor = [UIColor whiteColor];
            pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, scrollView.bounds.size.width - 30, scrollView.bounds.size.height - 20)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = VIEW_H(imageView)/2;
            imageView.layer.masksToBounds = YES;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [pageView addSubview:imageView];
           
        }
        if (self.bannerUrls.count > indexPath.row){
            [self.bannerUrls[indexPath.row] hasPrefix:@"http"]?([imageView sd_setImageWithURL:[NSURL URLWithString:self.bannerUrls[indexPath.row]] placeholderImage:self.placeHolderImage]):([imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.bannerUrls[indexPath.row]]] placeholderImage:self.placeHolderImage]);
            if (self.titles.count == 1) {
                self.titleLabel.text = self.titles[0];
            }
        }else if (self.images.count > indexPath.row){
            imageView.image = self.images[indexPath.row];
        }
        return pageView;
    }
    
    UIImageView *page = (UIImageView *)[scrollView dequeueRecycledPage];
    if (page == nil)
    {
        page = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        //page.contentMode = UIViewContentModeScaleToFill;
       
        page.contentMode = UIViewContentModeScaleAspectFill;
        page.clipsToBounds = YES;
        page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if (self.bannerUrls.count > indexPath.row)
    {
        if([page isKindOfClass:[UIImageView class]]){
            [self.bannerUrls[indexPath.row] hasPrefix:@"http"]?([page sd_setImageWithURL:[NSURL URLWithString:self.bannerUrls[indexPath.row]] placeholderImage:self.placeHolderImage]):([page sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.bannerUrls[indexPath.row]]] placeholderImage:self.placeHolderImage]);
        }
        if (self.titles.count == 1) {
            
            self.titleLabel.text = self.titles[0];
        }
    }
    else if (self.images.count > indexPath.row)
    {
        if([page isKindOfClass:[UIImageView class]]){
            page.image = self.images[indexPath.row];
        }
        
    }
    return page;
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDelegate ---------------------
- (void)punchScrollView:(PunchScrollView *)scrollView pageChanged:(NSIndexPath*)indexPath
{
    
    
    if ([[BTThreeManager sharedInstance].typeStr isEqualToString:@"社区"]) {
        
        if (indexPath.row < self.bannerUrls.count||indexPath.row < self.titles.count) {
            if (self.bannerUrls.count == self.titles.count) {
                self.titleLabel.text = self.titles[indexPath.row];
                self.pageC.currentPage = indexPath.row;
            }
        }
    }else {
        self.pageC.currentPage = indexPath.row;
    }
}

- (void)punchScrollView:(PunchScrollView *)scrollView didTapOnPage:(UIView*)view
            atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(rollImagesView:didClickIndex:)])
    {
        [self.delegate rollImagesView:self didClickIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark -------------------- UIScrollViewDelegate --------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self autoRoll:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self autoRoll:self.isAutoScroll];
}

- (void)swipeViewCircleAction:(NSTimer *)timer
{
    if (self.bannerUrls.count <= 1)
    {
        return;
    }
    
    [self.scrollView scrollToNextPage:YES];
}

@end
