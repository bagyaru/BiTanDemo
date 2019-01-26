//
//  BTLineChartView.m
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "BTLineChartView.h"
#import "NSDate+Extent.h"

@interface BTLineChartView()
@property (nonatomic, strong) UIView * gredientView;
@property (nonatomic, strong) NSMutableArray * pointXArray;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, strong) NSMutableArray * topPointArray;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL highlightLineCurrentEnabled;
@property (nonatomic, assign) NSInteger highlightLineCurrentIndex;
@property (nonatomic, strong)CAShapeLayer *lineShapeLayer;

@end

static const CGFloat fontSize = 12;
static const CGFloat lineChartXlabelHeight = 16.0f;
static const CGFloat bottomMarginScale = 16.0f;

@implementation BTLineChartView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //[self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}
- (CGFloat)contentTop{
    return self.bounds.origin.y;
}

- (CGFloat)contentLeft{
    return self.bounds.origin.x;
}

- (CGFloat)contentRight{
    return self.bounds.origin.x + self.bounds.size.width;
}

- (CGFloat)contentBottom{
    return self.bounds.origin.y + self.bounds.size.height;
}

- (CGFloat)contentWidth{
    return self.frame.size.width;
}

- (CGFloat)contentHeight{
    return self.frame.size.height;
}

- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.2;
    }
    return _longPressGesture;
}

- (void)handleLongPressGestureAction:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self.mainScroll];
        if (point.x > self.contentLeft && point.x < self.mainScroll.contentSize.width && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightLineCurrentEnabled = NO;
        [self setNeedsDisplay];
        if(_lineShapeLayer){
            [_lineShapeLayer removeFromSuperlayer];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KNoShowProfitInfo" object:nil];
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint  point = [recognizer locationInView:self.mainScroll];
        if (point.x > self.contentLeft && point.x < self.mainScroll.contentSize.width && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
        
    }
}

- (void)getHighlightByTouchPoint:(CGPoint) point{
    self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/(ScreenWidth/10));
    
    NSNumber *max = [self.LineChartDataArray valueForKeyPath:@"@max.self"];
    CGFloat height = self.frame.size.height - bottomMarginScale -20 ;
    CGFloat maxValue =[max doubleValue];
    NSNumber *min =[self.LineChartDataArray valueForKeyPath:@"@min.self"];
    CGFloat minValue =[min doubleValue];
    
    if(_LineChartDataArray.count ==1){
        maxValue =maxValue*1.05;
        minValue =minValue*0.95;
    }
    
    CGFloat delta = maxValue -minValue;
    if(delta ==0){
        delta =1;
    }
    
    
    if (self.highlightLineCurrentEnabled) {
        if (self.highlightLineCurrentIndex < self.LineChartDataArray.count) {
            
            CGFloat startX = [_pointXArray[self.highlightLineCurrentIndex] doubleValue];
            if(self.highlightLineCurrentIndex ==0){
                startX = 0;
            }
            CGFloat yValue= self.frame.size.height-(([_LineChartDataArray[self.highlightLineCurrentIndex] doubleValue]-minValue)*height/delta)-bottomMarginScale;
            [self drawLine:CGPointMake(startX, yValue)];
            NSDictionary *dict =@{@"date":SAFESTRING(_lineChartXLabelArray[self.highlightLineCurrentIndex]),@"profit":SAFESTRING(_LineChartDataArray[self.highlightLineCurrentIndex])};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KShowProfitInfo" object:dict];
        }
        
    }
    
}

- (void)drawLine:(CGPoint)point{
    
    if(_lineShapeLayer){
        [_lineShapeLayer removeFromSuperlayer];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineWidth:1];
    
    _lineShapeLayer = shapeLayer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(point.x, 0)];
    [path addLineToPoint:CGPointMake(point.x, self.frame.size.height)];
    
    [path moveToPoint:CGPointMake(self.contentLeft, point.y)];
    [path addLineToPoint:CGPointMake(self.mainScroll.contentSize.width, point.y)];
    shapeLayer.path =path.CGPath;
    [self.mainScroll.layer addSublayer:shapeLayer];
}

- (void)drawDashLayer{
    NSNumber *max = [self.LineChartDataArray valueForKeyPath:@"@max.self"];
    CGFloat height = self.frame.size.height - bottomMarginScale -20;
    CGFloat maxValue =[max doubleValue];
    NSNumber *min =[self.LineChartDataArray valueForKeyPath:@"@min.self"];
    CGFloat minValue =[min doubleValue];
   
    if(_LineChartDataArray.count ==1){
        maxValue =maxValue*1.05;
        minValue =minValue*0.95;
    }
    
    CGFloat delta = maxValue -minValue;
    if(delta ==0){
        delta =1;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:HexRGB(0xC0E2F9).CGColor];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:1],nil]];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point;
    
    CGRect rect = self.bounds;
    for (NSUInteger i = 0; i < _scaleNums.count; i++) {
        
        point =CGPointMake(0, self.frame.size.height-(([_scaleNums[i] doubleValue]-minValue)*height/delta)-bottomMarginScale);
        NSString *numstr =[NSString stringWithFormat:@"%@",[self.scaleNums[i] unitP2fString]];
        CATextLayer *layerText = [[CATextLayer alloc] init];
        // 背景颜色
        layerText.backgroundColor = [UIColor clearColor].CGColor;
        // 渲染分辨率-重要，否则显示模糊
        layerText.contentsScale = [UIScreen mainScreen].scale;
        // 显示位置
        layerText.alignmentMode = kCAAlignmentRight;
        layerText.frame = CGRectMake(rect.size.width-80, point.y -20, 90, 20);
        // 添加到父图层
        [self.layer addSublayer:layerText];
        
        // 分行显示
        layerText.wrapped = YES;
        // 超长显示时，省略号位置
        layerText.truncationMode = kCATruncationNone;
        // 字体颜色
        layerText.foregroundColor = HexRGB(0x8D949F).CGColor;
        // 字体名称、大小
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef =CGFontCreateWithFontName(fontName);
        layerText.font = fontRef;
        layerText.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        // 字体对方方式
        layerText.alignmentMode = kCAAlignmentJustified;
        
        layerText.string = numstr;
        [path moveToPoint:CGPointMake(point.x, point.y)];
        // 这里是改变虚线的宽度
        //[path addLineToPoint:CGPointMake(self.totalWidth - 5, point.y)];
        [path addLineToPoint:CGPointMake(ScreenWidth - 5, point.y)];
        
    }
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

// 底部X视图
- (void)setLineChartXLabelArray:(NSArray *)lineChartXLabelArray{
    _lineChartXLabelArray = lineChartXLabelArray;
    if (!_lineChartXLabelArray) return;
    for(UIView *view in self.mainScroll.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    _pointXArray = [[NSMutableArray alloc]init];
    self.totalWidth =0;
    CGFloat screenWidth =[UIScreen mainScreen].bounds.size.width;
    for (int idx = 0; idx < _lineChartXLabelArray.count; idx ++) {
        CGFloat x = idx*(screenWidth/10.0);//self.totalWidth+marginScale;
        CGFloat y = self.frame.size.height- lineChartXlabelHeight;
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(x, y, screenWidth/10.0, lineChartXlabelHeight);
        label.text = [NSDate getTimeStrFromInterval:_lineChartXLabelArray[idx] andFormatter:@"dd"];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HexRGB(0x8E9091);
        label.font = [UIFont systemFontOfSize:fontSize];
        [_pointXArray addObject:[NSString stringWithFormat:@"%.f",label.center.x]];
        [self.mainScroll addSubview:label];
        self.totalWidth = label.frame.origin.x+label.frame.size.width;
        
        [self.mainScroll setContentSize:CGSizeMake(CGRectGetMaxX(label.frame), 0)];
    }
    [self.mainScroll addGestureRecognizer:self.longPressGesture];
}
// 根据文字动态获取字体宽度
- (CGFloat)getLabelWidthWithText:(NSString *)text{
    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}].width;
    return width;
}

//可滚动视图
- (UIScrollView *)mainScroll{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainScroll];
    }
    return _mainScroll;
}
// 设置折线图
- (void)setLineChartDataArray:(NSArray *)LineChartDataArray{
    _LineChartDataArray = LineChartDataArray;
    
    if (_LineChartDataArray.count ==0) return;


    //重置layer
    for(int i =0;i< self.mainScroll.layer.sublayers.count;i ++){
        CALayer *layer = self.mainScroll.layer.sublayers[i];
        if([layer isKindOfClass:[CAShapeLayer class]]){
             [layer removeFromSuperlayer];
        }
        if([layer isKindOfClass:[CAGradientLayer class]]){
            [layer removeFromSuperlayer];
        }
       
    }
    for(int i =0;i< self.layer.sublayers.count;i ++){
        CALayer *layer = self.layer.sublayers[i];
        if([layer isKindOfClass:[CAShapeLayer class]]){
            [layer removeFromSuperlayer];
        }
        if([layer isKindOfClass:[CATextLayer class]]){
            [layer removeFromSuperlayer];
        }
    }
    
    UIBezierPath * bezierPath = [self getPath];
    CAShapeLayer * layers = [CAShapeLayer layer];
    layers.path = bezierPath.CGPath;
    layers.lineWidth = 2.0;
    layers.strokeColor = HexRGB(0x1495EB).CGColor;
    layers.fillColor = [UIColor clearColor].CGColor;
    //[self doAnimationWithLayer:layers];
    
    [self drawGredientLayer]; // 渐变
    [self.mainScroll.layer addSublayer:layers];
    [self drawDashLayer];
    
    //只有一个数据的时候
    NSNumber *max = [self.LineChartDataArray valueForKeyPath:@"@max.self"];
    CGFloat height = self.frame.size.height - bottomMarginScale -20;
    CGFloat maxValue =[max doubleValue];
    NSNumber *min =[self.LineChartDataArray valueForKeyPath:@"@min.self"];
    CGFloat minValue =[min doubleValue];
    
    if(_LineChartDataArray.count ==1){
        maxValue =maxValue*1.05;
        minValue =minValue*0.95;
    }
    
    CGFloat delta = maxValue -minValue;
    if(delta ==0){
        delta =1;
    }
    if(_LineChartDataArray.count ==1){
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-(([_LineChartDataArray[self.highlightLineCurrentIndex] doubleValue]-minValue)*height/delta)-bottomMarginScale, 10, 10)];
        view.layer.cornerRadius =5.0f;
        view.layer.masksToBounds =YES;
        view.backgroundColor =HexRGB(0x1495EB);
        [self.mainScroll addSubview:view];
    }
}

//得到折线的path
- (UIBezierPath *)getPath{
    NSNumber *max = [self.LineChartDataArray valueForKeyPath:@"@max.self"];
    NSNumber *min =[self.LineChartDataArray valueForKeyPath:@"@min.self"];
    
    CGFloat height = self.frame.size.height - bottomMarginScale -20 ;
    CGFloat maxValue =[max doubleValue];
    CGFloat minValue =[min doubleValue];
    
    self.topPointArray = [[NSMutableArray alloc]init];
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    CGPoint prePoint;
    CGPoint nowPoint;
    CGFloat delta = maxValue -minValue;
    if(delta ==0){
        delta =1;
    }
    for (int idx =0; idx<_LineChartDataArray.count; idx++) {
        if (idx == 0) {
           CGPoint startPoint = CGPointMake(0, self.frame.size.height-(([_LineChartDataArray[0] doubleValue]-minValue)*height/delta)-bottomMarginScale);
            [bezierPath moveToPoint:startPoint];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:startPoint]];
            prePoint = startPoint;
        }else{
            nowPoint= CGPointMake([_pointXArray[idx] doubleValue], self.frame.size.height-(([_LineChartDataArray[idx] doubleValue]-minValue)*height/delta)-bottomMarginScale);
            [bezierPath addLineToPoint:nowPoint];
            
            //[bezierPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];
            prePoint = nowPoint;
            [bezierPath addLineToPoint:nowPoint];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:nowPoint]];
        }
    }
    return bezierPath;
    
}
/*
 @parameter 背景颜色填充
 */

- (void)drawGredientLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.totalWidth, self.frame.size.height-bottomMarginScale);
    gradientLayer.colors = @[(__bridge id)HexRGB(0xFFFFFF).CGColor,(__bridge id)HexRGB(0xC0E2F9).CGColor];
    
    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,1);
    gradientLayer.endPoint = CGPointMake(0,0);
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = [self path].CGPath;
    gradientLayer.mask = arc;
    [self.mainScroll.layer addSublayer:gradientLayer];
}
//渐变的path
- (UIBezierPath*)path{
    NSNumber *max = [self.LineChartDataArray valueForKeyPath:@"@max.self"];
    CGFloat height = self.frame.size.height - bottomMarginScale -20 ;
    CGFloat maxValue =[max doubleValue];
    NSNumber *min =[self.LineChartDataArray valueForKeyPath:@"@min.self"];
    CGFloat minValue =[min doubleValue];
    CGFloat delta = maxValue -minValue;
    if(delta ==0){
        delta =1;
    }
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, self.frame.size.height-bottomMarginScale)];
    CGPoint prePoint;
    CGPoint nowPoint;
    for (int idx =0; idx<_LineChartDataArray.count; idx++) {
        if (idx == 0) {
            CGPoint startPoint = CGPointMake(0, self.frame.size.height-(([_LineChartDataArray[0] doubleValue]-minValue)*height/delta)-bottomMarginScale);
            [bezierPath addLineToPoint:startPoint];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:startPoint]];
            prePoint = startPoint;
        }else{
            
            nowPoint= CGPointMake([_pointXArray[idx] doubleValue], self.frame.size.height-(([_LineChartDataArray[idx] doubleValue]-minValue)*height/delta)-bottomMarginScale);
            
            [bezierPath addLineToPoint:nowPoint];
            // [bezierPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];
            prePoint = nowPoint;
            [bezierPath addLineToPoint:nowPoint];
            [self.topPointArray addObject:[NSValue valueWithCGPoint:nowPoint]];
        }
    }
    [bezierPath addLineToPoint:CGPointMake(([_pointXArray[_pointXArray.count-1] doubleValue]), self.frame.size.height-bottomMarginScale)];
    
    return bezierPath;
}

- (void)doAnimationWithLayer:(CAShapeLayer *)layer{
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = 2;
    baseAnimation.fromValue = @0.0;
    baseAnimation.toValue = @1.0;
    baseAnimation.repeatCount = 1;
    [layer addAnimation:baseAnimation forKey:@"strokeAnimation"];
}
@end
