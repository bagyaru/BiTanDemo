
//  Created by tangshilei on 17/12/20.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

//投票设置
@interface BaseAlertView : UIView
@property(nonatomic,assign)BOOL isClickable;
@property(nonatomic,assign)BOOL isClear;
@property(nonatomic,strong)UIControl *viewControl;
//over ride
+ (CGRect)frameOfAlert;
- (void)createView;

//interface
+ (void)show;

- (void)show;
- (void)__hide;

- (void)controlPressed;

@end
