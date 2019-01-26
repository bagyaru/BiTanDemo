//
//  MKRollImagesView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "DiscoveryRollImagesView.h"
#import <PunchScrollView.h>
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "UIColor+MKExtension.h"
#import "THFPageControl.h"
#import "THFZXPageC.h"
#define DurationOfScroll 4.0f


@interface DiscoveryRollImagesView () <PunchScrollViewDataSource, PunchScrollViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PunchScrollView *scrollView;

@property (nonatomic, strong) THFPageControl *pageC;
@property (nonatomic, strong) THFZXPageC     *pageControl1;
@property (nonatomic, strong) UILabel       *titleLabel;//标题
@property (nonatomic, strong) UILabel       *typeLabel;//类型
@property (nonatomic, strong) UILabel       *keywordsLabel;//关键词

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) BOOL isAutoScroll;

@end


@implementation DiscoveryRollImagesView

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
        self.pageC.pageIndicatorTintColor = SeparateColor;
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
    if ([keyPath isEqualToString:@"bannerUrls"])
    {
        [self autoRollEnable:NO];
        [self.scrollView reloadData];
        [self autoRollEnable:YES];
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
        imageView.tag = 1000;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [pageView addSubview:imageView];
        pageView.backgroundColor = isNightMode ?ViewContentBgColor:CWhiteColor;
    }
    if(imageView ==nil){
        imageView = [pageView viewWithTag:1000];
    }
    if (self.bannerUrls.count > indexPath.row){
        [self.bannerUrls[indexPath.row] hasPrefix:@"http"]?([imageView sd_setImageWithURL:[NSURL URLWithString:self.bannerUrls[indexPath.row]] placeholderImage:self.placeHolderImage]):([imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.bannerUrls[indexPath.row]]] placeholderImage:self.placeHolderImage]);
    }else if (self.images.count > indexPath.row){
        imageView.image = self.images[indexPath.row];
    }
    return pageView;
    
}

#pragma mark -
#pragma mark -------------------- PunchScrollViewDelegate ---------------------
- (void)punchScrollView:(PunchScrollView *)scrollView pageChanged:(NSIndexPath*)indexPath
{
    self.pageC.currentPage = indexPath.row;
    
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
