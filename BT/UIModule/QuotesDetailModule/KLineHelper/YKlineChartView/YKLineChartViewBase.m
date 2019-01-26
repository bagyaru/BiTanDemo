//
//  YKLineChartViewBase.m
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKLineChartViewBase.h"
#import "YKLineEntity.h"
@interface YKLineChartViewBase()

@property (nonatomic, strong) NSDictionary *highAttributeDict;
@end
@implementation YKLineChartViewBase
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        [self commonInit];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect
{
    UIColor * backgroundColor = self.gridBackgroundColor?:[UIColor whiteColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    
    CGContextSetFillColorWithColor(context, kHEXCOLOR(0xF9F9F9).CGColor);
    CGContextFillRect(context, CGRectMake(0, (self.uperChartHeightScale * self.contentHeight)+7, rect.size.width ,20));//self.contentLeft  self.contentWidth
    [self drawHLineRect:self.contentRect inContext:context];
}

//画横向分割线
- (void)drawHLineRect:(CGRect)rect inContext:(CGContextRef)context{
    
    CGContextSetStrokeColorWithColor(context, CLineColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat Height = (self.uperChartHeightScale * self.contentHeight) + self.contentTop;
    CGFloat unitHeight = Height/4;
    
    
    const CGPoint line2[] = {CGPointMake(0, unitHeight),CGPointMake(self.contentWidth, unitHeight)};
    const CGPoint line3[] = {CGPointMake(0, unitHeight*2),CGPointMake(self.contentWidth, unitHeight*2)};
    const CGPoint line4[] = {CGPointMake(0, unitHeight*3),CGPointMake(self.contentWidth, unitHeight*3)};
    
    //const CGPoint line6[] = {CGPointMake(0, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]) ),CGPointMake(self.contentSize.width, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]))};
    CGContextStrokeLineSegments(context, line2, 2);
    CGContextStrokeLineSegments(context, line3, 2);
    CGContextStrokeLineSegments(context, line4, 2);
    
    
    
}


- (void)drawLabelPrice:(CGContextRef)context{
    
//    CGContextSetStrokeColorWithColor(context, CLineColor.CGColor);
//    CGFloat unitHeight = ((self.uperChartHeightScale * self.contentHeight) + self.contentTop)/4;
//
//    double maxPrice = self.maxPrice;
//    double minPrice = self.minPrice;
//
//    double unit = (maxPrice - minPrice)/4;
//    for(NSUInteger i =0; i<5; i++){
//        double value1 = minPrice +unit*i;
//        NSString *valueStr = [NSString stringWithFormat:@"%@",[[DigitalHelper shareInstance] isTransformWithDouble:value1]];
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:valueStr attributes:self.defaultAttributedDic];
//
//        CGFloat top;
//        if(i==4){
//            top = 2;
//        }else{
//            top = unitHeight*(4-i)-12;
//        }
//        [valueStr drawInRect:CGRectMake(self.contentRight - attrStr.size.width-2, top, attrStr.size.width, 12) withAttributes:self.defaultAttributedDic];
//    }
//
    
    NSDictionary * drawAttributes = self.leftYAxisAttributedDic?:self.defaultAttributedDic;
    //成交量
    NSString * volumn = [NSString stringWithFormat:@"VOL %@",[[DigitalHelper shareInstance] isTransformWithDouble:self.maxVolume]];
    NSMutableAttributedString * maxVolumnAttStr = [[NSMutableAttributedString alloc]initWithString:volumn attributes:drawAttributes];
    
    //((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMaxVolumnAttStr.height )
    CGFloat top = self.contentBottom- (self.contentHeight - (self.uperChartHeightScale * self.contentHeight+18));
    CGSize sizeMaxVolumnAttStr = [maxVolumnAttStr size];
    CGRect maxVolumnRect = CGRectMake(self.contentLeft + 2, top, sizeMaxVolumnAttStr.width, sizeMaxVolumnAttStr.height);
    [self drawLabel:context attributesText:maxVolumnAttStr rect:maxVolumnRect];
}


- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth
{
    
    NSString * leftMarkerStr = @"";
    NSString * bottomMarkerStr = @"";
    NSString * rightMarkerStr = @"";
    NSString * volumeMarkerStr = @"";
    
    
    if ([value isKindOfClass:[YKTimeLineEntity class]]) {
        YKTimeLineEntity * entity = value;
//        leftMarkerStr = [self handleStrWithPrice:entity.lastPirce];
        bottomMarkerStr = entity.currtTime;
        rightMarkerStr = entity.rate;
        
    }else if([value isKindOfClass:[YKLineEntity class]]){
        YKLineEntity * entity = value;
        leftMarkerStr = [[DigitalHelper shareInstance] isTransformWithDouble:entity.close];   //[self handleStrWithPrice:entity.close];
        bottomMarkerStr = entity.date;
        volumeMarkerStr = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entity.volume],[self handleShowWithVolume:entity.volume]];
    }else{
        return;
    }
    
    if (nil == bottomMarkerStr || nil == rightMarkerStr) {
        return;
    }
    bottomMarkerStr = [[@" " stringByAppendingString:bottomMarkerStr] stringByAppendingString:@" "];
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, self.contentTop);
    CGContextAddLineToPoint(context, point.x, self.contentBottom);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.contentLeft, point.y);
    CGContextAddLineToPoint(context, self.contentRight, point.y);
    CGContextStrokePath(context);
    
    CGFloat radius = 3.0;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius));
    
    
    NSDictionary * drawAttributes = self.highlightAttributedDic?:self.highAttributeDict;
    
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:bottomMarkerStr attributes:drawAttributes];
    
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
    
    CGRect rect = CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0+3,  self.contentBottom-bottomMarkerStrAttSize.height-2, bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height);
    
    if (rect.size.width + rect.origin.x > self.contentRight) {
        rect.origin.x = self.contentRight -rect.size.width;
    }
    if (rect.origin.x < self.contentLeft) {
        rect.origin.x = self.contentLeft;
    }
    
    CGContextSetFillColorWithColor(context, MainTextColor.CGColor);
    CGContextFillRect(context, CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  self.contentBottom-bottomMarkerStrAttSize.height -4, bottomMarkerStrAttSize.width+6, bottomMarkerStrAttSize.height+4));
    
    [self drawLabel:context attributesText:bottomMarkerStrAtt rect:rect];
    
    //////////////////////////////////////////////////////
    NSMutableAttributedString * rightMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:leftMarkerStr attributes:drawAttributes];
    CGSize rightMarkerStrAttSize = [rightMarkerStrAtt size];
    CGContextSetFillColorWithColor(context, MainTextColor.CGColor);
    CGContextFillRect(context, CGRectMake(self.contentRight-rightMarkerStrAttSize.width-6 , point.y-rightMarkerStrAttSize.height/2-1, rightMarkerStrAttSize.width+6, rightMarkerStrAttSize.height+2));
    
    [self drawLabel:context attributesText:rightMarkerStrAtt rect:CGRectMake(self.contentRight-rightMarkerStrAttSize.width -3, point.y -rightMarkerStrAttSize.height/2, rightMarkerStrAttSize.width, rightMarkerStrAttSize.height)];
}

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect{
    [attributesText drawInRect:rect];
}

- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color
{
    if ((rect.origin.x + rect.size.width) > self.contentRight) {
        return;
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

-(void)drawCiclyPoint:(CGContextRef)context
                point:(CGPoint)point
               radius:(CGFloat)radius
                color:(UIColor*)color{
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    if (startPoint.x < self.contentLeft ||stopPoint.x >self.contentRight || startPoint.y <self.contentTop || stopPoint.y < self.contentTop) {
        return;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}


- (NSString *)handleRateWithPrice:(CGFloat)price
                         originPX:(CGFloat)originPX
{
    
    if (0 == originPX) {
        return @"--";
    }
    CGFloat rate = (price - originPX)/originPX *100.00;
    if(rate >0){
        return [NSString stringWithFormat:@"+%.2f%@",rate,@"%"];
        
    }
    return [NSString stringWithFormat:@"%.2f%@",rate,@"%"];
}

- (NSString *)handleStrWithPrice:(CGFloat)price
{
    if (self.isETF) {
        return [NSString stringWithFormat:@"%.3f ",price];
    }
    return [NSString stringWithFormat:@"%.2f ",price];
}
- (NSString *)handleShowWithVolume:(CGFloat)volume
{
    volume = volume/100.0;
    
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}
- (NSString *)handleShowNumWithVolume:(CGFloat)volume
{
    volume = volume/100.0;
    if (volume < 10000.0) {
        return [NSString stringWithFormat:@"%.0f ",volume];
    }else if (volume > 10000.0 && volume < 100000000.0){
        return [NSString stringWithFormat:@"%.2f ",volume/10000.0];
    }else{
        return [NSString stringWithFormat:@"%.2f ",volume/100000000.0];
    }
}

- (NSDictionary *)defaultAttributedDic
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:MainTextColor,NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _defaultAttributedDic;
}

- (NSDictionary *)highAttributeDict
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_highAttributeDict) {
        _highAttributeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:CWhiteColor,NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _highAttributeDict;
}

- (NSDictionary *)maAttributeDic
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_maAttributeDic) {
        _maAttributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:CRedColor,NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _maAttributeDic;
}

- (void)setHighlightLineCurrentEnabled:(BOOL)highlightLineCurrentEnabled
{
    
    if (_highlightLineCurrentEnabled != highlightLineCurrentEnabled) {
        _highlightLineCurrentEnabled = highlightLineCurrentEnabled;
        if ( NO == highlightLineCurrentEnabled) {
            if ([self.delegate respondsToSelector:@selector(chartValueNothingSelected:)]) {
                [self.delegate chartValueNothingSelected:self];
            }
        }
    }
}

@end
