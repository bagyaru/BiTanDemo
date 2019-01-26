//
//  BarView.h
//  柱状图测试
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 huangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarView : UIView

/** bar颜色 */
@property (nonatomic, strong) UIColor * barColor;
/** 是否带动画显示(默认为YES，带动画) */
@property (nonatomic, assign) BOOL isAnimated;
/** 图表透明度(范围0 ~ 1, 默认为1.f) */
@property (nonatomic, assign) CGFloat opacity;
/** 百分比小数 */
@property (nonatomic, assign) CGFloat percent;
/** bar终点Y值 */
@property (nonatomic, assign, readonly) CGFloat endYPos;

@property (nonatomic, assign) CGFloat animationDuration;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;
/**
 *  首页重绘
 */
- (void)strokePath:(int)num;

@end
