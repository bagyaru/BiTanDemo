//
//  Y_KLine.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLine.h"
#import "UIColor+Y_StockChart.h"
#import "Y_StockChartGlobalVariable.h"
#import "Y_StockChartConstant.h"
@interface Y_KLine()

/**
 *  context
 */
@property (nonatomic, assign) CGContextRef context;

/**
 *  最后一个绘制日期点
 */
@property (nonatomic, assign) CGPoint lastDrawDatePoint;

@property (nonatomic, strong) NSDictionary *defaultAttributedDic;

@end

@implementation Y_KLine

#pragma mark 根据context初始化
- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
        _lastDrawDatePoint = CGPointZero;
    }
    return self;
}
- (void)drawHighAndLow:(CGRect)bound{
    Y_KLineModel *firstModel = self.needKlineModel.firstObject;
    __block double minAssert = firstModel.Low.doubleValue;
    __block NSNumber* maxAssert = firstModel.High;
    [self.needKlineModel enumerateObjectsUsingBlock:^(Y_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if(kLineModel.High.doubleValue > maxAssert.doubleValue)
        {
            maxAssert = kLineModel.High;
        }
        if(kLineModel.Low.doubleValue < minAssert)
        {
            minAssert = kLineModel.Low.doubleValue;
        }
    }];
    if ([self.kLineModel.High isEqualToNumber:maxAssert]) {
        NSString * date = [NSString stringWithFormat:@"←%@",[DigitalHelperService isTransformWithDouble:self.kLineModel.High.doubleValue]];
        NSDictionary * drawAttributes = self.defaultAttributedDic;
        NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
        CGSize dateStrAttSize = [dateStrAtt size];
        if (self.kLinePositionModel.HighPoint.x + dateStrAttSize.width > bound.size.width) {
            NSString * date = [NSString stringWithFormat:@"%@→",[DigitalHelperService isTransformWithDouble:self.kLineModel.High.doubleValue]];
            NSDictionary * drawAttributes =self.defaultAttributedDic;
            NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
            [self drawLabel:self.context attributesText:dateStrAtt rect:CGRectMake(self.kLinePositionModel.HighPoint.x - dateStrAttSize.width,self.kLinePositionModel.HighPoint.y - dateStrAttSize.height / 2.0, dateStrAttSize.width, dateStrAttSize.height)];
        }else{
            [self drawLabel:self.context attributesText:dateStrAtt rect:CGRectMake(self.kLinePositionModel.HighPoint.x,self.kLinePositionModel.HighPoint.y - dateStrAttSize.height / 2.0, dateStrAttSize.width, dateStrAttSize.height)];
        }
    }
    if (self.kLineModel.Low.doubleValue == minAssert) {
        NSString * date = [NSString stringWithFormat:@"←%@",[DigitalHelperService isTransformWithDouble:self.kLineModel.Low.doubleValue]];
        NSDictionary * drawAttributes = self.defaultAttributedDic;
        NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
        CGSize dateStrAttSize = [dateStrAtt size];
        if (self.kLinePositionModel.LowPoint.x + dateStrAttSize.width > bound.size.width) {
            NSString * date = [NSString stringWithFormat:@"%@→",[DigitalHelperService isTransformWithDouble:self.kLineModel.Low.doubleValue]];
            NSDictionary * drawAttributes = self.defaultAttributedDic;
            NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
            [self drawLabel:self.context attributesText:dateStrAtt rect:CGRectMake(self.kLinePositionModel.LowPoint.x - dateStrAttSize.width,self.kLinePositionModel.LowPoint.y - dateStrAttSize.height/2, dateStrAttSize.width, dateStrAttSize.height)];
        }else{
            [self drawLabel:self.context attributesText:dateStrAtt rect:CGRectMake(self.kLinePositionModel.LowPoint.x,self.kLinePositionModel.LowPoint.y - dateStrAttSize.height/2, dateStrAttSize.width, dateStrAttSize.height)];
        }
    }
}
#pragma 绘制K线 - 单个
- (UIColor *)draw{
    //判断数据是否为空
    if(!self.kLineModel || !self.context || !self.kLinePositionModel)
    {
        return nil;
    }
    
    CGContextRef context = self.context;
    
    //设置画笔颜色
    UIColor *strokeColor = self.kLinePositionModel.OpenPoint.y < self.kLinePositionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextEOClip(self.context);
    //画中间较宽的开收盘线段-实体线
    CGContextSetLineWidth(context, [Y_StockChartGlobalVariable kLineWidth]);
    
    const CGPoint solidPoints[] = {self.kLinePositionModel.OpenPoint, self.kLinePositionModel.ClosePoint};
    //画线
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上下影线
    CGContextSetLineWidth(context, Y_StockChartShadowLineWidth);
    const CGPoint shadowPoints[] = {self.kLinePositionModel.HighPoint, self.kLinePositionModel.LowPoint};
    //画线
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    
//    NSString *dateStr = self.kLineModel.Date;
    
    //时间
    
    //CGFloat width = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.width;
    //坐标
    //- width/2
//    CGPoint drawDatePoint = CGPointMake(self.kLinePositionModel.LowPoint.x, self.maxY + 5);
//    if(CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || drawDatePoint.x - self.lastDrawDatePoint.x > 60 ){
//        [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
//        self.lastDrawDatePoint = drawDatePoint;
//    }
    return strokeColor;
}

- (NSDictionary *)defaultAttributedDic{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor assistTextColor]};
    }
    return _defaultAttributedDic;
}

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect{
    [attributesText drawInRect:rect];
}

@end
