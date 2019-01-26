//
//  pictureCell.m
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "pictureCell.h"

@interface pictureCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation pictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self scrollView];
    [self imageView];
    self.autoresizesSubviews = YES;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageForDismiss)]];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [self.imageView addGestureRecognizer:longPress];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    _progressLayer.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
}
//点击退出
- (void)clickImageForDismiss
{
    self.clickCellImage();
}
//长按保存
- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    
    if (recognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    NSLog(@"长按成功");
    NSMutableArray *data =@[].mutableCopy;
    BTGroupListModel *deletModel = [[BTGroupListModel alloc] init];
    deletModel.groupName = [APPLanguageService wyhSearchContentWith:@"baocunzhaopian"];//@"全部";
    [data addObject:deletModel];
    [CommentsAlertView showWithArr:data type:2 completion:^(NSString *groupName) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(_picImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"baocunshibai"] wait:YES];
    } else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"chenggongbaocundaoxiangce"] wait:YES];
    }
}
//- (void)setPicImg:(UIImage *)picImg
//{
//    _picImg = picImg;
//    self.picView.image = picImg;
//    self.picView.contentMode = UIViewContentModeScaleAspectFit;
//}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    if(imageUrl){
//        [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil];
        @weakify(self);
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            @strongify(self);
            if (!self) return;
            CGFloat progress = receivedSize / (float)expectedSize;
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
            if (isnan(progress)) progress = 0;
            self.progressLayer.hidden = NO;
            self.progressLayer.strokeEnd = progress;
        } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            @strongify(self);
            if (!self) return;
            self.progressLayer.hidden = YES;
            if (stage == YYWebImageStageFinished) {
                if (image) {
                    [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
                }
            }
            
        }];
        
        [self.scrollView setMinimumZoomScale:1.0];
        [self.scrollView setMaximumZoomScale:5];
        [self.scrollView setZoomScale:1.0];
    }
}

- (void)setPicImg:(UIImage *)picImg{
    if (picImg != _picImg) {
        _picImg = picImg;
        CGSize maxSize = self.scrollView.size;
        CGFloat widthRatio = maxSize.width/picImg.size.width;
        CGFloat heightRatio = maxSize.height/picImg.size.height;
        CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
        
        if (initialZoom > 1) {
            initialZoom = 1;
        }
        
        CGRect r = self.scrollView.frame;
        r.size.width = picImg.size.width * initialZoom;
        r.size.height = picImg.size.height * initialZoom;
        self.imageView.frame = r;
        self.imageView.center = CGPointMake(self.scrollView.width/2, self.scrollView.height/2);
        self.imageView.image = picImg;
        
        [self.scrollView setMinimumZoomScale:1.0];
        [self.scrollView setMaximumZoomScale:5];
        [self.scrollView setZoomScale:1.0];
    }
}
#pragma mark- scroll
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
#pragma mark- getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _scrollView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
    }
    
    return _imageView;
}

@end
