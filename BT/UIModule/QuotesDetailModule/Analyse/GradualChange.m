//
//  GradualChange.m
//  横向柱形图测试
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 huangfei. All rights reserved.
//

#import "GradualChange.h"

@implementation GradualChange

+(UIImage*)viewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.layer.cornerRadius =  isVertical?RELATIVE_WIDTH(5):rect.size.height/2;
    view.layer.masksToBounds = YES;
    [view.layer addSublayer:[self barGradientColor:view isVertaical:isVertical]];
    return [self convertViewToImage:view];
}

+(UIImage *)HomeviewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    //[view.layer addSublayer:[self barGradientColor:view isVertaical:isVertical]];
    //部分设置圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    [view.layer addSublayer:[self barGradientColor:view isVertaical:isVertical]];
    return [self convertViewToImage:view];
}

+(UIImage *)HomeviewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical numb:(int)numb {
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    //[view.layer addSublayer:[self barGradientColor:view isVertaical:isVertical]];
    //部分设置圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    if (numb > 5) {//跌的颜色
        view.backgroundColor = CFallColor;
    }else {//涨的颜色
        view.backgroundColor = CRiseColor;
    }
    return [self convertViewToImage:view];
}

+(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  渐变色
 */
+ (CALayer *)barGradientColor:(UIView*)view isVertaical:(BOOL)isVertical{
    CALayer * layer = [CALayer layer];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
//    gradientLayer.colors = @[(id)kHEXCOLOR(0x97d3ff).CGColor, (id)kHEXCOLOR(0x108ee9).CGColor];
    gradientLayer.colors = @[(id)kHEXCOLOR(0x0B7AC9).CGColor, (id)kHEXCOLOR(0x0B7AC9).CGColor];
    gradientLayer.locations = @[@(0.0), @(1.0)];
    gradientLayer.startPoint = isVertical?CGPointMake(0.0, 0.0):CGPointMake(1.0, 0.0);
    gradientLayer.endPoint = isVertical?CGPointMake(0.0, 1.0):CGPointMake(0.0, 0.0);
    [layer addSublayer:gradientLayer];
    return layer;
}

@end
