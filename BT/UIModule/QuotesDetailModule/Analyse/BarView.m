//
//  BarView.m
//  柱状图测试
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 huangfei. All rights reserved.
//

#import "BarView.h"
#import "GradualChange.h"

@interface BarView ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

/** bar高度上限 */
@property (nonatomic, assign) CGFloat barHeightLimit;
/** 动画时间 */



@end

@implementation BarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self commonInit];
        
    }
    
    return self;
}

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _barHeightLimit = self.frame.size.height;
    _percent = 1;
    _animationDuration = 1.5f;
    _opacity = 1.0;
    _isAnimated = YES;
}

#pragma mark - bar

/**
 *  未填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)noFill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, _barHeightLimit, self.frame.size.width, 0)];
    return bezier;
}

/**
 *  填充
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)fill{
    CGFloat currentHeight = _barHeightLimit * self.percent;
    _endYPos = _barHeightLimit - currentHeight;
    
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, _endYPos, self.frame.size.width, currentHeight)];
    return bezier;
}

/**
 *  CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.path = [self fill].CGPath;
    layer.opacity = _opacity;
    
    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [layer addAnimation:animation forKey:nil];
    }
    
    return layer;
}

#pragma mark - 动画

/**
 *  填充动画过程
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = _animationDuration;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = (__bridge id)([self noFill].CGPath);
    fillAnimation.toValue = (__bridge id)([self fill].CGPath);
    
    return fillAnimation;
}

/**
 *  清除之前所有subLayers
 */
- (void)removeAllLayer{
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllLayer];
    [self.layer addSublayer:[self shapeLayer]];
    
    //因为原来那样的话顶部没有圆角
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, self.frame.size.height - self.endYPos)];
    [self addSubview:imgView];
    imgView.image = [GradualChange HomeviewChangeImg:imgView.bounds isVerticalBar:YES];
    
    if (_animationDuration) {
        
        //[UIView animateWithDuration:1.5 animations:^{
            imgView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.frame.size.height+self.endYPos);
        //}];
    }
}
/**
 *  首页重绘
 */
-(void)strokePath:(int)num {
    
    [self removeAllLayer];
    [self.layer addSublayer:[self shapeLayer]];
    
    //因为原来那样的话顶部没有圆角
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, self.frame.size.height - self.endYPos)];
    [self addSubview:imgView];
    imgView.image = [GradualChange HomeviewChangeImg:imgView.bounds isVerticalBar:YES numb:num];
    
    if (_animationDuration) {
        
        [UIView animateWithDuration:1.5 animations:^{
            imgView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.frame.size.height+self.endYPos);
        }];
        
    }
}
-(void)drawRect:(CGRect)rect{
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGFloat minX = 0;
//    CGFloat minY = 0;
//    CGFloat maxX = CGRectGetWidth(self.frame);
//    CGFloat maxY = CGRectGetHeight(self.frame);
//    CGFloat midX = maxX/2;
//    CGFloat midY = maxY/2;
//
//
//    CGContextSetLineWidth(ctx, 1);
//    CGContextMoveToPoint(ctx, minX, midY);
//    CGContextAddArcToPoint(ctx, minX, minY, midX, minY, 4);
//    CGContextAddArcToPoint(ctx, maxX, minY, maxX, midY, 4);
////    CGContextAddLineToPoint(ctx, maxX, minY);
////    CGContextAddLineToPoint(ctx, maxX, maxY);
//    CGContextAddLineToPoint(ctx, maxX, maxY);
//    CGContextAddLineToPoint(ctx, minX, maxY);
//    CGContextClosePath(ctx);
//
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//
////    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
//
//    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}



@end
