//
//  FenshiView.m
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FenshiView.h"
#import "NSString+Utils.h"
#import "KLineHelper.h"


@interface FenshiView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) NSInteger highlightLineCurrentIndex;

@property (nonatomic, assign) BOOL highlightLineCurrentEnabled;

@property (nonatomic, strong) NSDictionary *defaultAttributedDic;

@property (nonatomic, strong) CAScrollLayer *breathingPoint;

@property (nonatomic, assign) BOOL isCanShowVolumn;
@property (nonatomic, strong) NSDictionary *volumnAttributedDic;

@end

@implementation FenshiView{
    CAGradientLayer *_gradientLayer;
    double _avgPointValue;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:self.longPressGesture];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];

}

#pragma mark - Lazy

- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.2;
    }
    return _longPressGesture;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTapGestureAction:)];
    }
    return _tapGesture;
}

- (void)handleLongTapGestureAction:(UITapGestureRecognizer *)recognizer{
    if (self.highlightLineCurrentEnabled) {
        self.highlightLineCurrentEnabled = NO;
          [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_noShowWarningView object:nil];
    }
    [self setNeedsDisplay];
}


- (void)handleLongPressGestureAction:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self];
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightLineCurrentEnabled = NO;
        [self setNeedsDisplay];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_noShowWarningView object:nil];
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint  point = [recognizer locationInView:self];
        
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
    }
}

- (void)getHighlightByTouchPoint:(CGPoint) point{
    if (self.isFullScreen) {
        if (iPhoneX) {
              self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/((ScreenHeight -10 - 50)/ TOTALPOINTS));
        }else{
              self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/((ScreenHeight -10)/ TOTALPOINTS));
        }
       
    }else{
         self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/((ScreenWidth - 10) / TOTALPOINTS));
    }
   
    [self setNeedsDisplay];
}

- (CGFloat)contentTop{
    return self.frame.origin.y;
}

- (CGFloat)contentLeft{
    return self.frame.origin.x;
}

- (CGFloat)contentRight{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)contentBottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)contentWidth{
    return self.frame.size.width;
}

- (CGFloat)contentHeight{
    return self.frame.size.height;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框设置
    CGFloat divideHeight = (rect.size.height - 50) * 3 / 4;
    CGFloat width;
    if (self.isFullScreen) {
        if (iPhoneX) {
            width =  (self.dataArray.count - 1) * ((ScreenHeight - 10 - 50) / TOTALPOINTS);
            if (width < ScreenHeight - 20) {
                width = ScreenHeight - 20;
            }
        }else{
            width =  (self.dataArray.count - 1) * ((ScreenHeight - 10) / TOTALPOINTS);
            if (width < ScreenHeight) {
                width = ScreenHeight;
            }
        }
        
    }else{
        width =  (self.dataArray.count - 1) * ((ScreenWidth - 10) / TOTALPOINTS);
        if (width < ScreenWidth) {
            width = ScreenWidth;
        }
    }
    
    CGFloat chartWidth = width;
    CGRect priceRect = CGRectMake(0, 0, chartWidth, divideHeight);
    CGRect timeRect = CGRectMake(0, divideHeight, chartWidth, 20);
    CGRect amountRect = CGRectMake(0, divideHeight+33, chartWidth, (rect.size.height - 30) / 4.0);
    
    [self drawHLineRect:priceRect inContext:context];
    
    //时间
    [self drawTimesInRect: timeRect inContext: context];
    
    //现价线
    [self drawCurrentPriceLineInRect: priceRect inContext: context isAvg:NO];
    
    //日均线
    [self drawCurrentPriceLineInRect: priceRect inContext: context isAvg:YES];
   
    
    //成交量柱形图
    [self drawLineSegmentsIn:amountRect inContext:context];
    
    
    UIScrollView *scrollView  =  (UIScrollView*)self.superview;
    NSInteger left  = (NSInteger)((scrollView.contentOffset.x - self.contentLeft)/((ScreenWidth - 10) / TOTALPOINTS));
    
    NSMutableArray *mutaArr =@[].mutableCopy;
    NSMutableArray *priceArr = @[].mutableCopy;
    
    NSInteger right = left+40;
    if(left>self.dataArray.count){
        left =self.dataArray.count;
    }
    if(right>self.dataArray.count){
        right =self.dataArray.count;
    }
    for(NSInteger i =left;i<right;i++){
        FenshiModel *model =self.dataArray[i];
        [mutaArr addObject:@(model.volum)];
        [priceArr addObject:@(model.price)];
    }
    
    //最大成交量
    NSNumber *max = [mutaArr valueForKeyPath:@"@max.self"];
    NSString *string = [NSString stringWithFormat:@"VOL %@",[[DigitalHelper shareInstance] isTransformWithDouble:[max doubleValue]]];
    if(max){
        [string drawInRect:CGRectMake(scrollView.contentOffset.x+10, divideHeight+22, 100, 11) withAttributes:self.volumnAttributedDic];
    }
    
    //
//    [self drawHLinePrice:priceRect Value:priceArr inContext:context];
    
    
    if (self.highlightLineCurrentEnabled) {
        if (self.highlightLineCurrentIndex < self.dataArray.count) {
            FenshiModel *model = self.dataArray[self.highlightLineCurrentIndex];
            CGFloat startX = model.pXOffset;
            CGFloat  yPrice = model.pYOffset;
            [self drawHighlighted:context point:CGPointMake(startX, yPrice) idex:self.highlightLineCurrentIndex value:model color:[UIColor blackColor] lineWidth:0.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_ShowWarningView object:model];
        }
        
    }
    
    
}

//右边价格
- (void)drawHLinePrice:(CGRect)rect Value:(NSArray*)priceArr inContext:(CGContextRef)context{
    
    CGContextSetStrokeColorWithColor(context, CLineColor.CGColor);
    CGFloat unitHeight = rect.size.height/4;
    
    NSNumber *maxPrice = [priceArr valueForKeyPath:@"@max.self"];
    NSNumber *minPrice = [priceArr valueForKeyPath:@"@min.self"];
    
    double unit = ([maxPrice doubleValue] -[minPrice doubleValue])/4;
    
    UIScrollView *scrollView  =  (UIScrollView*)self.superview;
    CGFloat x;
    
    if (self.isFullScreen) {
        CGFloat height;
        if (iPhoneX) {
            height = ScreenHeight - 50;
        }else{
            height = ScreenHeight;
        }
        x= scrollView.contentOffset.x+ height;
        if(x>self.frame.size.width){
            x = self.frame.size.width;
        }
        
    }else{
        x = scrollView.contentOffset.x+ScreenWidth;
        if(x>self.frame.size.width){
            x = self.frame.size.width;
        }
    }
    for(NSUInteger i =0; i<5; i++){
        double value1 = [minPrice floatValue]+unit*i;
        NSString *valueStr = [NSString stringWithFormat:@"%@",[[DigitalHelper shareInstance] isTransformWithDouble:value1]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:valueStr attributes:self.volumnAttributedDic];
        CGFloat top;
        if(i==4){
            top = 2;
        }else{
            top = unitHeight*(4-i)-12;
        }
        if(unit !=0){
            [valueStr drawInRect:CGRectMake(x - attrStr.size.width-2, top, attrStr.size.width, 12) withAttributes:self.volumnAttributedDic];
        }
    }
    
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    if (_isFullScreen) {
        
    }
}

- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth
{
    
    if (!self.highlightLineCurrentEnabled) {
        return;
    }
    NSString * leftMarkerStr = @"";
    NSString * bottomMarkerStr = @"";
    if ([value isKindOfClass:[FenshiModel class]]) {
        FenshiModel * entity = value;
        if(entity.price<1){
            leftMarkerStr = @(entity.price).p8fString;
        }else{
            leftMarkerStr = @(entity.price).p2fString;
        }
        
        bottomMarkerStr = [[NSDate dateWithTimeIntervalSince1970:entity.time / 1000.0] stringWithFormat:@"yyyy MM.dd HH:mm"];
        
    }else{
        return;
    }
    
    if (nil == leftMarkerStr || nil == bottomMarkerStr) {
        return;
    }
    bottomMarkerStr = [[@" " stringByAppendingString:bottomMarkerStr] stringByAppendingString:@" "];
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, self.contentTop -15);
    CGContextAddLineToPoint(context, point.x, self.contentBottom);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.contentLeft, point.y);
    CGContextAddLineToPoint(context, self.contentRight, point.y);
    CGContextStrokePath(context);
    
    
    CGContextAddArc(context, point.x, point.y, 2, 0, -M_PI*2, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
    
    NSDictionary * drawAttributes = self.defaultAttributedDic;
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:bottomMarkerStr attributes:drawAttributes];
    
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
   
    CGContextSetFillColorWithColor(context, MainTextColor.CGColor);
    CGContextFillRect(context, CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0, self.contentBottom-33-2, bottomMarkerStrAttSize.width+6, bottomMarkerStrAttSize.height+4));
    
    CGRect rect = CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0+3,self.contentBottom-33, bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height);
    
    if (rect.size.width + rect.origin.x > self.contentRight) {
        rect.origin.x = self.contentRight -rect.size.width;
    }
    if (rect.origin.x < self.contentLeft) {
        rect.origin.x = self.contentLeft;
    }
    [self drawLabel:context attributesText:bottomMarkerStrAtt rect:rect];
    
    ////
    NSMutableAttributedString * leftMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:leftMarkerStr attributes:drawAttributes];
    
    UIScrollView *scrollView  =  (UIScrollView*)self.superview;
    CGFloat right = scrollView.contentOffset.x + ScreenWidth;
    CGSize leftMarkerStrAttSize = [leftMarkerStrAtt size];
    CGContextSetFillColorWithColor(context, MainTextColor.CGColor);
    CGContextFillRect(context, CGRectMake(right -leftMarkerStrAttSize.width-6 , point.y -leftMarkerStrAttSize.height/2-1, leftMarkerStrAttSize.width+6, leftMarkerStrAttSize.height+2));
    
    CGRect leftRect = CGRectMake(right -leftMarkerStrAttSize.width-3,point.y-leftMarkerStrAttSize.height/2, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height);
    [self drawLabel:context attributesText:leftMarkerStrAtt rect:leftRect];
}


- (NSDictionary *)defaultAttributedDic{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:CWhiteColor,NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _defaultAttributedDic;
}

- (NSDictionary *)volumnAttributedDic{
    if (!_volumnAttributedDic) {
        _volumnAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:kHEXCOLOR(0x151419)};
    }
    return _volumnAttributedDic;
}


- (void)drawLabel:(CGContextRef)context attributesText:(NSAttributedString *)attributesText rect:(CGRect)rect{
    [attributesText drawInRect:rect];
}

- (void)colorWithView:(UIView *)view withLayer:(CAGradientLayer *)layer withColorArray:(NSArray *)array {
    
    layer.frame = view.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1）
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    layer.colors = array;
    
    //设置颜色分割点（范围：0-1）
    layer.locations = @[@(0.0f), @(1.0f)];
}

- (void)drawHLineRect:(CGRect)rect inContext:(CGContextRef)context{
    
    CGContextSetStrokeColorWithColor(context, CLineColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat unitHeight = rect.size.height/4;
    
  
    const CGPoint line2[] = {CGPointMake(0, unitHeight),CGPointMake(self.contentWidth, unitHeight)};
    const CGPoint line3[] = {CGPointMake(0, unitHeight*2),CGPointMake(self.contentWidth, unitHeight*2)};
    const CGPoint line4[] = {CGPointMake(0, unitHeight*3),CGPointMake(self.contentWidth, unitHeight*3)};
   
    //const CGPoint line6[] = {CGPointMake(0, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]) ),CGPointMake(self.contentSize.width, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]))};
    CGContextStrokeLineSegments(context, line2, 2);
    CGContextStrokeLineSegments(context, line3, 2);
    CGContextStrokeLineSegments(context, line4, 2);
    
    
    
}

//分时
- (void)drawCurrentPriceLineInRect: (CGRect)rect inContext: (CGContextRef)context isAvg:(BOOL)isAvg{
    if (self.dataArray.count < 1) {
        return;
    }
    CGFloat pointValue = .0;
    
    CGFloat  baseY = rect.size.height  + rect.origin.y;
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //设置线宽度
    CGContextSetLineWidth(context,1);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGFloat xOffset = rect.origin.x;
    CGFloat yOffset = 0;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        FenshiModel *obj = self.dataArray[i];
        pointValue = obj.pointValuePrice;
        _avgPointValue = obj.pointValueAvgPrice;
        
        xOffset  = [self offsetOfIndex:i inRect: rect];
        
        ///////// yOffset的计算
        // yOffset
        if(pointValue == 0){
            yOffset = baseY + pointValue *rect.size.height;
        }else{
            yOffset = baseY + pointValue *rect.size.height;
        }
        obj.pXOffset = xOffset;
        obj.pYOffset = yOffset;
        
        if (isAvg) {
            yOffset = baseY + obj.pointValueAvgPrice * rect.size.height;
        }
        
        
        if (i == 0) {
            CGPathMoveToPoint(linePath, NULL, xOffset , yOffset);
        }
        else
        {
            CGPathAddLineToPoint(linePath, NULL , xOffset, yOffset);
        }
        if (!isAvg) {
            //现价线，最后一点，做个动画
            if (i == self.dataArray.count - 1) {
                self.breathingPoint.frame = CGRectMake(xOffset - 2, yOffset-2,4,4);
            }
        }
    }
    
    UIColor *tempColor;
    if (isAvg) {//均价线颜色
        tempColor = [UIColor colorWithHexString:@"FF6960"]; //[UIColor yellowColor];
    }else{//现价线颜色
        tempColor = [UIColor colorWithHexString:@"0174FF"];
    }
    
    CGContextSetStrokeColorWithColor(context, tempColor.CGColor);
    CGContextAddPath(context, linePath);
    CGContextStrokePath(context);
    if (!isAvg) {
        CGMutablePathRef fillPath = CGPathCreateMutableCopy(linePath);
        CGPathAddLineToPoint(fillPath, NULL, xOffset, rect.origin.y+rect.size.height);
        CGPathAddLineToPoint(fillPath, NULL, rect.origin.x, rect.origin.y+rect.size.height);
        CGPathCloseSubpath(fillPath);
        CGContextAddPath(context, fillPath);
        NSArray *colors = @[(id)[[UIColor colorWithHexString:@"0174FF"] colorWithAlphaComponent:1].CGColor,(id)[[UIColor colorWithHexString:@"0174FF"] colorWithAlphaComponent:0.0].CGColor]; // 渐变色数组
        //创建CGContextRef
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //           CGFloat locations[2] = { 0.0, 1.0 }; // 颜色位置设置,要跟颜色数量相等，否则无效
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, NULL);    // 渐变颜色效果设置
        //起止点设置
        //            CGRect pathRect = CGPathGetBoundingBox(fillPath);
        CGPoint startPoint = CGPointMake(xOffset, baseY - rect.size.height);
        CGPoint endPoint = CGPointMake(xOffset, baseY - 5);
        
        CGContextSaveGState(context);
        CGContextAddPath(context, fillPath);    // 添加路径
        CGContextClip(context);
        // 绘制线性渐变
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        CGContextRestoreGState(context);
        // 需要手动释放
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGPathRelease(fillPath);
        
        CGPathRelease(linePath);
    }else{
        CGPathRelease(linePath);
    }
}

//时间
- (void)drawTimesInRect: (CGRect)rect inContext: (CGContextRef)context{
    CGContextSaveGState(context);
    
    //矩形背景色
    UIColor *aColor = kHEXCOLOR(0xF9F9F9);
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    //填充矩形
    CGContextFillRect(context, rect);
    //执行绘画
    CGContextStrokePath(context);
    
    //////////////////////////////////////////////////
    UIColor *tempColor = [UIColor colorWithHexString:@"AAAAAA"];
    NSMutableArray *timeStrs = [NSMutableArray array];
    for (FenshiModel *model in self.dataArray) {
        if (model.lineTime == nil) {
            model.lineTime = @"";
        }
        [timeStrs addObject:model.lineTime];
    }
    UIFont *font = [UIFont systemFontOfSize: 10];
    NSString *rightSecondStr = nil;
    for (NSInteger i = timeStrs.count - 2; i >= 0; i--) {
        NSString *str = timeStrs[i];
        if (str.length > 0) {
            rightSecondStr = str;
            break;
        }
    }
    NSInteger strCount = timeStrs.count;
    CGFloat priOffset = 0.0;
    for (NSInteger i = 0; i < strCount; i++) {
        NSString *str = timeStrs[i];
        CGFloat length = [str sizeWithAttributes: @{NSFontAttributeName: font}].width;
        CGPoint point = CGPointZero;
        point.y = rect.origin.y + 3;

        CGFloat offset;
        if (i == 0) {
            offset =  [self offsetOfIndex:i inRect:rect];
        }else{
            offset =  [self offsetOfIndex:i inRect:rect] - length / 2.0;
            if ([str isEqualToString:rightSecondStr]) {
                priOffset = offset;
                CGFloat  separa;
                if (self.isFullScreen) {
                    if (iPhoneX) {
                        separa = (ScreenHeight - 50 - 10) / TOTALPOINTS;
                    }else{
                        separa = (ScreenHeight - 10) / TOTALPOINTS;
                    }
                    
                }else{
                    separa = (ScreenWidth - 10) / TOTALPOINTS;
                }
                if (priOffset + length / 2.0 + 20 >= (rect.origin.x + rect.size.width - 10 - length / 2.0 - 5)) {
                    continue;
                }
            }
            
            if (offset + length / 2.0 > rect.origin.x + rect.size.width - 15) {
                offset = rect.origin.x + rect.size.width - 10 - length / 2.0 - 5;
            }
        }
        point.x = offset;
        [str yz_drawAtPoint: point withFont: font color:tempColor];
        
        if(i%10 == 0){
            if(i != self.dataArray.count -1){
                
                CGContextSetStrokeColorWithColor(context, CLineColor.CGColor);
                CGContextSetLineWidth(context, 0.5);
                const CGPoint line2[] = {CGPointMake(point.x+15, 0),CGPointMake(point.x+15, rect.origin.y)};
               
                
                //const CGPoint line6[] = {CGPointMake(0, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]) ),CGPointMake(self.contentSize.width, self.frame.size.height * (1 - [YYStockVariable volumeViewRadio]))};
                CGContextStrokeLineSegments(context, line2, 2);
               
                
                
//                CGContextSetStrokeColorWithColor(context,CLineColor.CGColor);
//                CGContextSetLineWidth(context, 0.5);
//                CGContextBeginPath(context);
//                CGContextMoveToPoint(context, point.x+15, 0);
//                CGContextAddLineToPoint(context, point.x+15, rect.origin.y);
//                CGContextStrokePath(context);
            }
            
        }
    }
    CGContextRestoreGState(context);
}

//量竖线
- (void)drawLineSegmentsIn:(CGRect)rect inContext: (CGContextRef)context{
    CGContextSaveGState(context);
    
    CGFloat pointValue;
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        FenshiModel *obj = self.dataArray[i];
        xOffset  = [self offsetOfIndex:i inRect: rect];;
        pointValue = obj.pointValueVolum;
        if (pointValue > 1) {
            pointValue = 0.5;
        }
        yOffset = rect.origin.y + rect.size.height - pointValue*rect.size.height;
        CGContextMoveToPoint(context, xOffset, yOffset);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextSetLineWidth(context,4);
        CGContextAddLineToPoint(context, xOffset, rect.size.height+rect.origin.y);
        if (obj.rise) {
            UIColor *riseColor = CGreenColor;
            if (riseColor == nil) {
                riseColor = CGreenColor;
            }
            
            CGContextSetStrokeColorWithColor(context, riseColor.CGColor);
        }
        else
        {
            UIColor *fallColor = CRedColor;
            if (fallColor == nil) {
                fallColor = CRedColor;
            }
            CGContextSetStrokeColorWithColor(context, fallColor.CGColor);
        }
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

//分时的框
- (void)drawPriceBoundsInRect:(CGRect)rect inContext: (CGContextRef)context
{
    CGContextSaveGState(context);
    UIColor *lastCloseLineColor = [UIColor redColor];
    [lastCloseLineColor setStroke];
    CGFloat dash[] = {4,4};
    CGContextSetLineDash(context, 0, dash, 2);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+(rect.size.height - 10)/2.0);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+(rect.size.height - 10 )/2.0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

//量框
- (void)drawVolumeBoundsInRect:(CGRect)rect inContext: (CGContextRef)context{
    CGContextSaveGState(context);
    UIColor *borderColor = CBlackColor;
    [borderColor setStroke];
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+rect.size.height-0.5);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-0.5);
    CGContextStrokePath(context);
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (CGFloat)offsetOfIndex: (NSInteger)index inRect: (CGRect)rect{
    CGFloat  separa;
    if (self.isFullScreen) {
        if (iPhoneX) {
            separa = (ScreenHeight - 50 - 10) / TOTALPOINTS;
        }else{
            separa = (ScreenHeight - 10) / TOTALPOINTS;
        }
        
    }else{
         separa = (ScreenWidth - 10) / TOTALPOINTS;
    }
   return rect.origin.x + separa * index;
}

- (CALayer *)breathingPoint
{
    if (!_breathingPoint) {
        _breathingPoint = [CAScrollLayer layer];
        [self.layer addSublayer:_breathingPoint];
        _breathingPoint.backgroundColor = [UIColor whiteColor].CGColor;
        _breathingPoint.cornerRadius = 2;
        _breathingPoint.masksToBounds = YES;
        _breathingPoint.borderWidth = 1;
        _breathingPoint.borderColor = [UIColor colorWithHexString:@"2787B7"].CGColor;
        
        [_breathingPoint addAnimation:[self groupAnimationDurTimes:1.5f] forKey:@"breathingPoint"];
    }
    return _breathingPoint;
}

-(CABasicAnimation *)breathingLight:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.3f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

-(CAAnimationGroup *)groupAnimationDurTimes:(float)time;
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    
    NSArray * array = @[[self breathingLight:time],scaleAnim];
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations= array;
    animation.duration=time;
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
