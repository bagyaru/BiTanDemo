//
//  Y_KLineView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
#import "Y_KLineMAView.h"
#import "Y_VolumeMAView.h"
#import "Y_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"

#import "Y_StockChartGlobalVariable.h"
#import "Y_KLineVolumeView.h"
#import "Y_StockChartRightYView.h"
#import "Y_KLineAccessoryView.h"
#import "NSDate+Extent.h"
#import "Y_KlineDateView.h"

@interface Y_KLineView() <UIScrollViewDelegate, Y_KLineMainViewDelegate, Y_KLineVolumeViewDelegate, Y_KLineAccessoryViewDelegate,UIGestureRecognizerDelegate>

/**
 *  主K线图
 */
@property (nonatomic, strong) Y_KLineMainView *kLineMainView;

/**
 *  成交量图
 */
@property (nonatomic, strong) Y_KLineVolumeView *kLineVolumeView;

@property (nonatomic, strong) Y_KlineDateView *dateView;
/**
 *  副图
 */
@property (nonatomic, strong) Y_KLineAccessoryView *kLineAccessoryView;

/**
 *  右侧价格图
 */
@property (nonatomic, strong) Y_StockChartRightYView *priceView;

/**
 *  右侧成交量图
 */
@property (nonatomic, strong) Y_StockChartRightYView *volumeView;

/**
 *  右侧Accessory图
 */
@property (nonatomic, strong) Y_StockChartRightYView *accessoryView;

/**
 *  旧的scrollview准确位移
 */
@property (nonatomic, assign) CGFloat oldExactOffset;

/**
 *  kLine-MAView
 */
@property (nonatomic, strong) Y_KLineMAView *kLineMAView;

/**
 *  Volume-MAView
 */
@property (nonatomic, strong) Y_VolumeMAView *volumeMAView;

/**
 *  Accessory-MAView
 */
@property (nonatomic, strong) Y_AccessoryMAView *accessoryMAView;

/**
 *  长按后显示的View
 */
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizotalView;

@property (nonatomic, strong) UILabel *bottomDateView;
@property (nonatomic, strong) UILabel *rightPriceView;


@property (nonatomic, strong) MASConstraint *kLineMainViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *kLineVolumeViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *kLineAccessoryViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *priceViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *volumeViewHeightConstraint;

@property (nonatomic, strong) NSDictionary *defaultAttributedDic;

@property (nonatomic, assign) NSInteger lastScrollValue;

@end

@implementation Y_KLineView

//initWithFrame设置视图比例
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.mainViewRatio = [Y_StockChartGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = [Y_StockChartGlobalVariable kLineVolumeViewRadio];
        
        // main view 边框
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:lineView];
        lineView.backgroundColor = [UIColor lineColor];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(19);
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(14);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *LlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:LlineView];
        LlineView.backgroundColor = [UIColor lineColor];
        [LlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(19);
            make.width.mas_equalTo(0.5);
            make.left.equalTo(self).offset(14);
            make.bottom.equalTo(self.kLineMainView);
        }];
        
        UIView *RlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:RlineView];
        RlineView.backgroundColor = [UIColor lineColor];
        [RlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(19);
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.kLineMainView);
        }];
        
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:lineView1];
        lineView1.backgroundColor = [UIColor lineColor];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineMainView.mas_bottom);
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(14);
            make.height.mas_equalTo(0.5);
        }];
        
        
        
        // volume view 边框
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:lineView2];
        lineView2.backgroundColor = [UIColor lineColor];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.volumeMAView.mas_bottom).offset(2);
            make.left.equalTo(self).offset(14);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *voloumLlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:voloumLlineView];
        voloumLlineView.backgroundColor = [UIColor lineColor];
        [voloumLlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView2.mas_bottom);
            make.left.equalTo(self).offset(14);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.volumeView).offset(-3);
        }];
        
        UIView *voloumRlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:voloumRlineView];
        voloumRlineView.backgroundColor = [UIColor lineColor];
        [voloumRlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView2.mas_bottom);
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.volumeView).offset(-3);
        }];
        
        
        
        // accessory 边框
        UIView *accelineView4 = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:accelineView4];
        accelineView4.backgroundColor = [UIColor lineColor];
        [accelineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accessoryMAView.mas_bottom).offset(5);
            make.left.equalTo(self).offset(14);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *acceLlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:acceLlineView];
        acceLlineView.backgroundColor = [UIColor lineColor];
        [acceLlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accessoryMAView.mas_bottom).offset(5);
            make.left.equalTo(self).offset(14);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.kLineAccessoryView);
        }];
        
        UIView *acceRlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:acceRlineView];
        acceRlineView.backgroundColor = [UIColor lineColor];
        [acceRlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accessoryMAView.mas_bottom).offset(5);
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.kLineAccessoryView);
        }];
        
        UIView *acceBottomlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:acceBottomlineView];
        acceBottomlineView.backgroundColor = [UIColor lineColor];
        [acceBottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(14);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.kLineAccessoryView.mas_bottom);
        }];
    }
    
    return self;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.backgroundColor = [UIColor clearColor];
//        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceVertical = NO;
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
        
        UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slide:)];
        swiperight.delegate = self;
        swiperight.direction = UISwipeGestureRecognizerDirectionUp;
        [_scrollView addGestureRecognizer:swiperight];
        
        UISwipeGestureRecognizer *swipeleft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slideLeft:)];
        swipeleft.delegate = self;
        swipeleft.direction = UISwipeGestureRecognizerDirectionLeft |UISwipeGestureRecognizerDirectionRight;
        [_scrollView addGestureRecognizer:swipeleft];
        
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-24);
        }];
        
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (Y_KLineMAView *)kLineMAView{
    if (!_kLineMAView) {
        _kLineMAView = [Y_KLineMAView view];
        [self addSubview:_kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@20);
        }];
    }
    return _kLineMAView;
}

- (Y_VolumeMAView *)volumeMAView
{
    if (!_volumeMAView) {
        _volumeMAView = [Y_VolumeMAView view];
        [self addSubview:_volumeMAView];
        [_volumeMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineMainView.mas_bottom).offset(2);
            make.height.equalTo(@20);
        }];
    }
    return _volumeMAView;
}

- (Y_AccessoryMAView *)accessoryMAView
{
    if(!_accessoryMAView) {
        _accessoryMAView = [Y_AccessoryMAView new];
        [self addSubview:_accessoryMAView];
        [_accessoryMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineAccessoryView.mas_top);
            make.height.equalTo(@10);
        }];
    }
    return _accessoryMAView;
}

- (Y_KLineMainView *)kLineMainView{
    if (!_kLineMainView && self) {
        _kLineMainView = [Y_KLineMainView new];
        _kLineMainView.delegate = self;
        
        [_kLineMainView setReferenceScrollView:self.scrollView];
        [self insertSubview:_kLineMainView belowSubview:self.scrollView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView);
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(self.scrollView);
        }];
    }
    //加载rightYYView
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    self.accessoryView.backgroundColor = [UIColor clearColor];
    return _kLineMainView;
}

- (Y_KLineVolumeView *)kLineVolumeView{
    if(!_kLineVolumeView && self)
    {
        _kLineVolumeView = [Y_KLineVolumeView new];
        _kLineVolumeView.delegate = self;
        [_kLineVolumeView setReferenceScrollView:self.scrollView];
        [self insertSubview:_kLineVolumeView belowSubview:self.scrollView];
        [_kLineVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineMainView);
            make.top.equalTo(self.kLineMainView.mas_bottom).offset(10);
            make.width.equalTo(self.scrollView.mas_width);
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.volumeViewRatio);
        }];
        [self layoutIfNeeded];
    }
    return _kLineVolumeView;
}

- (Y_KLineAccessoryView *)kLineAccessoryView{
    if(!_kLineAccessoryView && self)
    {
        _kLineAccessoryView = [Y_KLineAccessoryView new];
        _kLineAccessoryView.delegate = self;
        [self insertSubview:_kLineAccessoryView belowSubview:self.scrollView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineVolumeView);
            make.top.equalTo(self.kLineVolumeView.mas_bottom).offset(10);
            make.width.equalTo(self.kLineVolumeView.mas_width);
            self.kLineAccessoryViewHeightConstraint =   make.height.equalTo(self.scrollView.mas_height).multipliedBy(0.2);
          
        }];
        [self layoutIfNeeded];
    }
    return _kLineAccessoryView;
}

- (Y_KlineDateView*)dateView{
    if(!_dateView){
        _dateView = [Y_KlineDateView new];
        _dateView.backgroundColor = [UIColor backgroundColor];
        [self insertSubview:_dateView belowSubview:self.scrollView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self).offset(-13);
            make.height.mas_equalTo(24);
        }];
        [self layoutIfNeeded];
    }
    return _dateView;
}

- (Y_StockChartRightYView *)priceView
{
    if(!_priceView)
    {
        _priceView = [Y_StockChartRightYView new];
        [self insertSubview:_priceView belowSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.bottom.equalTo(self.kLineMainView.mas_bottom).offset(-1);
        }];
    }
    return _priceView;
}

- (Y_StockChartRightYView *)volumeView
{
    if(!_volumeView){
        _volumeView = [Y_StockChartRightYView new];
        [self insertSubview:_volumeView belowSubview:self.scrollView];
        [self insertSubview:_volumeView aboveSubview:self.kLineVolumeView];
        _volumeView.minValueLabel.hidden = YES;
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineVolumeView.mas_top).offset(15);
            make.right.equalTo(self).offset(-20);
//            make.height.equalTo(self).multipliedBy(self.volumeViewRatio);
            make.bottom.equalTo(self.kLineVolumeView).offset(3);
        }];
    }
    return _volumeView;
}

- (Y_StockChartRightYView *)accessoryView
{
    if(!_accessoryView)
    {
        _accessoryView = [Y_StockChartRightYView new];
        [self insertSubview:_accessoryView aboveSubview:self.scrollView];
        _accessoryView.minValueLabel.hidden = YES;
        [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineAccessoryView.mas_top).offset(15);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(self.kLineAccessoryView.mas_height);
        }];
    }
    return _accessoryView;
}
#pragma mark - set方法
- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    self.dateView.isFullScreen = isFullScreen;
    CGFloat volumeRatio = 0.20;
    CGFloat ratio =  20/346.0f;
    CGFloat mainRatio = 1 - ratio - 2 *volumeRatio;
    if(self.isFullScreen){
        ratio = 20.0f/ (ScreenWidth - 80 - 44 -10);
        mainRatio =  1 - ratio - 2*volumeRatio;
    }
    if(self.accessoryLineStatus == Y_StockChartTargetLineStatusAccessoryClose){
        
        [Y_StockChartGlobalVariable setkLineMainViewRadio: 0.79];
        [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.18];
        self.accessoryMAView.hidden = YES;
        
    } else {
        [Y_StockChartGlobalVariable setkLineMainViewRadio: mainRatio];
        [Y_StockChartGlobalVariable setkLineVolumeViewRadio:volumeRatio];
        self.accessoryMAView.hidden = NO;
    }
    [self.kLineMainViewHeightConstraint uninstall];
    [_kLineMainView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy([Y_StockChartGlobalVariable kLineMainViewRadio]);
    }];
    [self.kLineVolumeViewHeightConstraint uninstall];
    [self.kLineVolumeView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy([Y_StockChartGlobalVariable kLineVolumeViewRadio]);
    }];
    [self.kLineAccessoryViewHeightConstraint uninstall];
    [self.kLineAccessoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.kLineAccessoryViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy(volumeRatio);
    }];
    
}
#pragma mark kLineModels设置方法
- (void)setKLineModels:(NSArray *)kLineModels
{
    self.lastScrollValue = 0;
    if(!kLineModels) {
        return;
    }
    _kLineModels = kLineModels;
    [self private_drawKLineMainView];
    //设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * [Y_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [Y_StockChartGlobalVariable kLineGap] + 10;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    
    
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    Y_KLineModel *model = [kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.accessoryLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
}

- (void)setAccessoryLineStatus:(Y_StockChartTargetLineStatus)accessoryLineStatus{
    _accessoryLineStatus = accessoryLineStatus;
    if(accessoryLineStatus <= 104){
//        CGFloat volumeRatio = 0.15;
         CGFloat volumeRatio = 0.20;
        CGFloat ratio =  20/346.0f;
        CGFloat mainRatio = 1 - ratio - 2 *volumeRatio;
        if(self.isFullScreen){
            ratio = 20.0f/ (ScreenWidth - 80 - 44 -10);
            mainRatio =  1 - ratio - 2*volumeRatio;
        }
        
        if(accessoryLineStatus == Y_StockChartTargetLineStatusAccessoryClose){
            
            [Y_StockChartGlobalVariable setkLineMainViewRadio: 0.79];
            [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.18];
            self.accessoryMAView.hidden = YES;
            
        } else {
            [Y_StockChartGlobalVariable setkLineMainViewRadio: mainRatio];
            [Y_StockChartGlobalVariable setkLineVolumeViewRadio:volumeRatio];
            self.accessoryMAView.hidden = NO;
        }
        
        [self.kLineMainViewHeightConstraint uninstall];
        [_kLineMainView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy([Y_StockChartGlobalVariable kLineMainViewRadio]);
        }];
        [self.kLineVolumeViewHeightConstraint uninstall];
        [self.kLineVolumeView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy([Y_StockChartGlobalVariable kLineVolumeViewRadio]);
        }];
        [self.kLineAccessoryViewHeightConstraint uninstall];
        [self.kLineAccessoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineAccessoryViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy(volumeRatio);
        }];
        [self reDraw];
    }
}

- (void)setTargetLineStatus:(Y_StockChartTargetLineStatus)targetLineStatus
{
    _targetLineStatus = targetLineStatus;
    if(targetLineStatus > 104){
        // main MA
        self.kLineMAView.targetLineStatus = targetLineStatus;
        Y_KLineModel *lastModel = self.kLineModels.lastObject;
        [self.kLineMAView maProfileWithModel:lastModel];
        [self reDraw];
    }
}
#pragma mark - event事件处理方法
#pragma mark 缩放执行方法
- (void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > Y_StockChartScaleBound) {
        CGFloat oldKLineWidth = [Y_StockChartGlobalVariable kLineWidth];

        NSInteger oldNeedDrawStartIndex = self.kLineMainView.needDrawStartIndex;
        NSLog(@"原来的index%ld",(long)self.kLineMainView.needDrawStartIndex);
        [Y_StockChartGlobalVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + Y_StockChartScaleFactor) : (1 - Y_StockChartScaleFactor))];
        // K线宽度发生了实际改变
        if ([Y_StockChartGlobalVariable kLineWidth] != oldKLineWidth) {
            oldScale = pinch.scale;
            //更新MainView的宽度
            [self.kLineMainView updateMainViewWidth];

            CGFloat lineGap = [Y_StockChartGlobalVariable kLineGap];
            CGFloat lineWidth = [Y_StockChartGlobalVariable kLineWidth];
            CGFloat scrollViewWidth = self.scrollView.frame.size.width;
            NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);

            if( pinch.numberOfTouches == 2 ) {
                CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
                CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
                CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);

                NSUInteger oldLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + oldKLineWidth);

                NSUInteger newLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
                self.kLineMainView.pinchStartIndex = oldNeedDrawStartIndex; //- (newLeftArrCount - oldLeftArrCount);

                NSInteger remainCount = self.kLineModels.count - (oldLeftArrCount +oldNeedDrawStartIndex);
                NSInteger count = remainCount - (needDrawKLineCount - newLeftArrCount);
                CGFloat width = count *(lineGap +lineWidth);
                CGFloat offset = self.scrollView.contentSize.width - self.scrollView.frame.size.width - width;

                if(offset > self.scrollView.contentSize.width - self.scrollView.frame.size.width){
                    offset = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
                }
                if(offset < 0){
                    offset = 0;
                }
                self.scrollView.contentOffset = CGPointMake(offset, self.scrollView.contentOffset.y);

                NSLog(@"计算得出的index%ld",(long)self.kLineMainView.pinchStartIndex);
            }
            [self.kLineMainView drawMainView];
        }
    }


}

- (CGFloat)updateScrollViewContentWidth {
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    CGFloat kLineViewWidth = self.kLineModels.count * [Y_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [Y_StockChartGlobalVariable kLineGap];
    
    if(kLineViewWidth < self.scrollView.bounds.size.width) {
        kLineViewWidth = self.scrollView.bounds.size.width;
    }
    
    //更新scrollview的contentsize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
    return kLineViewWidth;
}
#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.scrollView];
//        location = [self.kLineMainView.layer convertPoint:location fromLayer:self.scrollView.layer];
//        if([self.kLineMainView.layer containsPoint:location]){
//
//
//
//        }
        
        if(ABS(oldPositionX - location.x) < ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap])/2)
        {
            return;
        }
        
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        //初始化竖线
        if(!self.verticalView)
        {
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self insertSubview:self.verticalView aboveSubview:self.scrollView];
            self.verticalView.backgroundColor = [UIColor longPressLineColor];
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(20);
                make.width.equalTo(@(Y_StockChartLongPressVerticalViewWidth));
                make.bottom.equalTo(self);
                make.left.equalTo(@(-10));
            }];
            
        }
        //更新竖线位置
        CGFloat rightXPosition = [self.kLineMainView getExactXPositionWithOriginXPosition:location.x];
        
        
        //区分分时 和k线 十字线 竖线的颜色 宽度
//        if(self.MainViewType == Y_StockChartcenterViewTypeTimeLine){
//            self.verticalView.backgroundColor = [UIColor longPressLineColor];
            [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(rightXPosition +15));
            }];
//        }else{
//            self.verticalView.backgroundColor = [UIColor longKLineVerticalColor];
//            [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(@([Y_StockChartGlobalVariable kLineWidth]));
//                make.left.equalTo(@(rightXPosition + 15 - [Y_StockChartGlobalVariable kLineWidth]/2));
//            }];
//        }
        
        //初始化横线
        if(!self.horizotalView)
        {
            self.horizotalView = [UIView new];
            self.horizotalView.clipsToBounds = YES;
            [self insertSubview:self.horizotalView aboveSubview:self.scrollView];
            self.horizotalView.backgroundColor = [UIColor longPressLineColor];
            [self.horizotalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(20);
                make.height.mas_equalTo(@(Y_StockChartLongPressVerticalViewWidth));
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
            }];
        }
        CGFloat rightYPotion = [self.kLineMainView getExactYPositionWithOriginYPosition:location.x];
        Y_KLineModel *model = [self.kLineMainView getExactModelWithPosition:location.x];
        if(rightYPotion == 0 ||rightXPosition == 0){
            self.horizotalView.hidden = YES;
            self.rightPriceView.hidden = YES;
            self.verticalView.hidden = YES;
            self.bottomDateView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_noShowWarningRotationView object:nil];
        }else{
            self.horizotalView.hidden = NO;
            self.rightPriceView.hidden = NO;
            self.verticalView.hidden = NO;
            self.bottomDateView.hidden = NO;
            [self.verticalView layoutIfNeeded];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_ShowWarningRotationView object:model userInfo:nil];
        }
        NSString *time = [NSDate getTimeStrFromInterval:SAFESTRING(@(model.time)) andFormatter:@"YYYY-MM-dd HH:mm"];
        NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:time attributes:self.defaultAttributedDic];
        CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
       
        if(!_bottomDateView){
            self.bottomDateView = [UILabel new];
            self.bottomDateView.font = FONTOFSIZE(9);
            self.bottomDateView.textAlignment = NSTextAlignmentCenter;
            self.bottomDateView.layer.cornerRadius = 2.0f;
            self.bottomDateView.layer.masksToBounds = YES;
            self.bottomDateView.textColor = [UIColor whiteColor];
            self.bottomDateView.clipsToBounds = YES;
            [self addSubview:self.bottomDateView];
            self.bottomDateView.backgroundColor = kHEXCOLOR(0x108ee9);
            [self.bottomDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-10);
                make.height.mas_equalTo(14);
                make.centerX.equalTo(self.verticalView.mas_centerX);
                make.width.mas_equalTo(bottomMarkerStrAttSize.width +14);
            }];
        }
        [self layoutIfNeeded];
        CGFloat dateX =  self.verticalView.center.x - (bottomMarkerStrAttSize.width +14)/2;
        CGFloat rightDateX = self.verticalView.center.x + ( bottomMarkerStrAttSize.width +14)/2;
        if(dateX < 0){
            [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.verticalView.mas_centerX).offset((bottomMarkerStrAttSize.width +14)/2);
            }];
        }else if(rightDateX > self.frame.size.width){
            [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.verticalView.mas_centerX).offset(- (bottomMarkerStrAttSize.width +14)/2);
            }];
        }else{
            [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.verticalView.mas_centerX);
            }];
        }
        
        if(!_rightPriceView){
            self.rightPriceView = [UILabel new];
            self.rightPriceView.clipsToBounds = YES;
            self.rightPriceView.textAlignment = NSTextAlignmentCenter;
            self.rightPriceView.layer.cornerRadius = 2.0f;
            self.rightPriceView.layer.masksToBounds = YES;
            self.rightPriceView.font = FONTOFSIZE(9);
            self.rightPriceView.textColor = [UIColor whiteColor];
            [self addSubview:self.rightPriceView];
            self.rightPriceView.backgroundColor = kHEXCOLOR(0x108ee9);
            [self.rightPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(13));
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self.horizotalView.mas_centerY);
            }];
        }
        [self.horizotalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(rightYPotion+20); //根据上面的距离而变
        }];
        //        [self.horizotalView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self).offset(location.y); //根据上面的距离而变
        //        }];
        NSString *price = [DigitalHelperService isTransformWithDouble:model.Close.doubleValue];
        NSMutableAttributedString * rightMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:price attributes:self.defaultAttributedDic];
        CGSize rightMarkerStrAttSize = [rightMarkerStrAtt size];
        //
        [self.rightPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rightMarkerStrAttSize.width +14);
        }];
        
        self.bottomDateView.text = time;
        self.rightPriceView.text = price;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        //取消竖线
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        if(self.horizotalView)
        {
            self.horizotalView.hidden = YES;
        }
        
        if(self.rightPriceView){
            self.rightPriceView.hidden = YES;
        }
        
        if(self.bottomDateView){
            self.bottomDateView.hidden = YES;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_noShowWarningRotationView object:nil];
        
        oldPositionX = 0;
        //恢复scrollView的滑动
        self.scrollView.scrollEnabled = YES;
        
        Y_KLineModel *lastModel = self.kLineModels.lastObject;
        [self.kLineMAView maProfileWithModel:lastModel];
        [self.volumeMAView maProfileWithModel:lastModel];
        [self.accessoryMAView maProfileWithModel:lastModel];
    }
}

#pragma mark 重绘
- (void)reDraw
{
    self.kLineMainView.MainViewType = self.MainViewType;
    
    if(self.targetLineStatus > 104)
    {
        self.kLineMainView.targetLineStatus = self.targetLineStatus;
    }
    
    if(self.accessoryLineStatus <= 104){
        
        
    }
    [self.kLineMainView drawMainView];
}


#pragma mark - 私有方法
#pragma mark 画KLineMainView
- (void)private_drawKLineMainView
{
    self.kLineMainView.kLineModels = self.kLineModels;
    [self.kLineMainView layoutIfNeeded];
    [self.kLineMainView drawMainView];
}
- (void)private_drawKLineVolumeView
{
    NSAssert(self.kLineVolumeView, @"kLineVolume不存在");
    //更新约束
    [self.kLineVolumeView layoutIfNeeded];
    [self.kLineVolumeView draw];
}
- (void)private_drawKLineAccessoryView
{
    //更新约束
    self.accessoryMAView.targetLineStatus = self.accessoryLineStatus;
    [self.accessoryMAView maProfileWithModel:_kLineModels.lastObject];
    [self.kLineAccessoryView layoutIfNeeded];
    [self.kLineAccessoryView draw];
}
#pragma mark VolumeView代理
- (void)kLineVolumeViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume
{
    self.volumeView.maxValue = maxVolume;
    self.volumeView.minValue = minVolume;
    self.volumeView.middleValue = (maxVolume - minVolume)/2 + minVolume;
}
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice - minPrice)/2 + minPrice;
}
- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue
{
    self.accessoryView.maxValue = maxValue;
    self.accessoryView.minValue = minValue;
    self.accessoryView.middleValue = (maxValue - minValue)/2 + minValue;
}
#pragma mark MainView更新时通知下方的view进行相应内容更新
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
    self.kLineVolumeView.needDrawKLineModels = needDrawKLineModels;
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
}
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
    self.kLineVolumeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}


// 设置 指标类型，上面 和下面部分不一致
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
    
    self.kLineVolumeView.kLineColors = kLineColors;
    if(self.targetLineStatus >104)
    {
        self.kLineVolumeView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineVolumeView];
    self.kLineAccessoryView.kLineColors = kLineColors;
    
    if(self.accessoryLineStatus <= 104)
    {
        self.kLineAccessoryView.targetLineStatus = self.accessoryLineStatus;
    }
    [self private_drawKLineAccessoryView];
}

- (void)drawDate:(NSArray *)positions models:(NSArray<Y_KLineModel*> *)models{
    self.dateView.needDrawKLinePositionModels = positions;
    self.dateView.needDrawKLineModels = models;
    [self.dateView draw];
}


- (void)kLineMainViewLongPressKLinePositionModel:(Y_KLinePositionModel *)kLinePositionModel kLineModel:(Y_KLineModel *)kLineModel{
    //更新ma信息
    [self.kLineMAView maProfileWithModel:kLineModel];
    [self.volumeMAView maProfileWithModel:kLineModel];
    [self.accessoryMAView maProfileWithModel:kLineModel];
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"这是  %f-----%f=====%f",scrollView.contentSize.width,scrollView.contentOffset.x,self.kLineMainView.frame.size.width);
    
//    if(ABS(scrollView.contentOffset.x - self.lastScrollValue)>2){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"0"}];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"1"}];
//    }
//    self.lastScrollValue = scrollView.contentOffset.x;
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"0"}];
////    if(ABS(scrollView.contentOffset.x - self.lastScrollValue)>2){
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"0"}];
////    }else{
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"1"}];
////    }
////    self.lastScrollValue = scrollView.contentOffset.x;
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"1"}];
}

//侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
        
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)slide:(UIGestureRecognizer*)gesture{
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        _scrollView.scrollEnabled = YES;
    }else{
        _scrollView.scrollEnabled = NO;
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"1"}];
}

- (void)slideLeft:(UIGestureRecognizer*)gesture{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"kline_scroll" object:nil userInfo:@{@"canScroll":@"0"}];
}

- (void)dealloc{
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSDictionary *)defaultAttributedDic{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _defaultAttributedDic;
}

- (void)setRatio:(double)ratio{
    self.volumeMAView.ratio = ratio;
}

@end
