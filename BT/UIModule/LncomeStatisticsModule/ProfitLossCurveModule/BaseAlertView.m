
//  Created by tangshilei on 17/12/20.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "BaseAlertView.h"

@interface BaseAlertView ()


@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *cancelBtn;//取消
@property(nonatomic,strong)UIButton *confimBtn;//确定

@end

@implementation BaseAlertView

+ (void)show{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]){
        self.backgroundColor =[UIColor whiteColor];
        //self.layer.cornerRadius=6.0;
        //self.layer.masksToBounds=YES;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self createCommonView];
    [self createView];
}
- (void)createCommonView{
    
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 200, 100);
}

- (void)createView{
    
}
//取消
- (void)cancel:(UIButton*)btn{
    [self __hide];
}

#pragma mark -
-(UIControl*)viewControl{
    if(!_viewControl){
        _viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [_viewControl setBackgroundColor:kHEXCOLOR(0x000000)];
        if (!self.isClickable) {
          [_viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        }
        [_viewControl addSubview:self];
    }
    return _viewControl;
}
- (void)show{
    if (self.isClear) {
        self.viewControl.alpha = 0.0f;
    }else {
        self.viewControl.alpha = 0.5f;
    }
    [self setInfoViewFrame:NO];
}

- (void)shut{
    [self __hide];
}
//
- (void)__hide{
    [self setInfoViewFrame:YES];
}
- (void) controlPressed{
    [self __hide];
}

- (void)setInfoViewFrame:(BOOL)isDown{
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if(isDown == NO){
        [window addSubview:self.viewControl];
        [window addSubview:self];
        
        self.center = window.center;
        CGPoint center =self.center;
        center.y -= 20;
        self.center=center;
        //        [self animationAlert:self];
        
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:0.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    else{
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 [self.viewControl removeFromSuperview];
                                 [self removeFromSuperview];
                             }
                             
                         }];
    }
    
}

- (void)animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}

@end
