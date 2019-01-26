//
//  LRSChartView.m
//  LRSChartView
//
//  Created by lreson on 16/7/21.
//  Copyright © 2016年 lreson. All rights reserved.
//

#import "LRSChartView.h"
#import "YJYTouchScroll.h"
#import "UIColor+expanded.h"

#define btnW 12
#define titleWOfY 15
#define kPaoPaoWidth 75.f
#define KCircleRadius 5 //线条上圆圈半径
@interface LRSChartView ()<UIScrollViewDelegate>
{
    CGFloat currentPage;//当前页数s
    //CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
    UIButton *firstBtn;
    UIButton *lastBtn;
}

@property (nonatomic,strong)YJYTouchScroll *chartScrollView;

@property (nonatomic,strong)UIPageControl *pageControl;//分页
@property (nonatomic,strong)NSMutableArray *leftPointArr;//左边的数据源
@property (nonatomic,strong)NSMutableArray *rightPointArr;//左边的数据源
@property (nonatomic,strong)NSMutableArray *leftBtnArr;//左边按钮
@property (nonatomic, strong)NSMutableArray *detailLabelArr;
@property (nonatomic,strong)NSArray *leftScaleArr;
@property (nonatomic,strong)NSArray *rightScaleArr;
@property (nonatomic,strong)NSMutableArray *leftScaleViewArr;//左边的点击显示图
@property (nonatomic,strong)UIView *scaleBgView;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UILabel *scaleLabel;
@property (nonatomic,strong)UILabel *dateTimeLabel;
@property (nonatomic,assign)NSInteger row;
@property (nonatomic,assign)CGFloat leftJiange;
@property (nonatomic,assign)CGFloat jiange;
@property (nonatomic,assign)CGFloat rightJiange;
@property (nonatomic,assign)BOOL showSelect;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)NSMutableArray *charCircleViewArr;
@property (strong,nonatomic) UIBezierPath *circlePath;
@property (strong,nonatomic) CAGradientLayer *gradientlayer;
@property (strong,nonatomic) CAShapeLayer *percentLayer;

@end

@implementation LRSChartView

#pragma mark --------初始化-----------
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        currentPage = 0;
        _precisionScale = 1;
        self.leftPointArr = [NSMutableArray array];
        self.rightPointArr = [NSMutableArray array];
        self.leftBtnArr = [NSMutableArray array];
        self.detailLabelArr = [NSMutableArray array];
        self.leftScaleArr = [NSArray array];
        self.leftScaleViewArr = [NSMutableArray array];
        self.showSelect = NO;
        self.isFloating = NO;
        self.chartViewStyle = 0;
        self.chartLayerStyle = 0;
        self.lineLayerStyle = 1;
        self.proportion = 0.5;
        self.colors = [NSArray array];
        self.lineWidth = 1;
        _Xmargin = 50;
        _row = 5;
    }
    return self;
    
}

-(UILabel *)scaleLabel{
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc]init];
        _scaleLabel.textAlignment = 1;
        _scaleLabel.text = @"3.3681%";
        _scaleLabel.font = [UIFont systemFontOfSize:11];
        _scaleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
        _scaleLabel.textColor = [UIColor whiteColor];
    }
    return _scaleLabel;
    
}

-(UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc]init];
        _dateTimeLabel.textAlignment = 1;
        _dateTimeLabel.text = @"2016.04.16";
        _dateTimeLabel.font = [UIFont systemFontOfSize:11];
        _dateTimeLabel.backgroundColor = [UIColor whiteColor];
        _dateTimeLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _dateTimeLabel;
}

- (NSMutableArray *)charCircleViewArr{
    if (!_charCircleViewArr) {
        _charCircleViewArr = [NSMutableArray new];
    }
    return _charCircleViewArr;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.chartScrollView.frame.size.height)];
        _selectView.backgroundColor = [UIColor colorWithHexString:@"#108ee9"];
        [self.chartScrollView addSubview:_selectView];
    }
    return _selectView;
}

-(UILabel *)lineLabel{
    
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
    }
    return _lineLabel;
}

-(void)setLeftDataArr:(NSArray *)leftDataArr{
    _leftDataArr = leftDataArr;
}

-(void)setRightDataArr:(NSArray *)rightDataArr{
    _rightDataArr = rightDataArr;
    self.pageControl.numberOfPages = 1;
    _rightJiange = 0;
}

// 获取数据最大值,并计算每一行间隔值
- (CGFloat)spaceValue:(NSArray *)array{
    CGFloat minValue = MAXFLOAT;
    CGFloat maxValue = -MAXFLOAT;
    for (int i = 0; i < [array count]; i++) {
        if ([array[i] doubleValue] * _precisionScale> maxValue) {
            maxValue = [array[i] doubleValue] * _precisionScale;
        }
        if ([array[i] doubleValue] * _precisionScale < minValue) {
            minValue = [array[i] doubleValue] * _precisionScale;
        }
    }
    double max = maxValue *1.002;
//    NSInteger tenValue = 0;
//    while (max / 10) {max = max / 10;tenValue++;}
//    CGFloat space_Value = ((max + 1) * pow(10, tenValue)) / _row;
//    return space_Value / _precisionScale;
    return max/_row;
}

- (CGFloat)minValue:(NSArray*)array{
    //    CGFloat minValue = MAXFLOAT;
    //    CGFloat maxValue = -MAXFLOAT;
    //    for (int i = 0; i < [array count]; i++) {
    //        if ([array[i] floatValue] * _precisionScale> maxValue) {
    //            maxValue = [array[i] floatValue] * _precisionScale;
    //        }
    //        if ([array[i] floatValue] * _precisionScale < minValue) {
    //            minValue = [array[i] floatValue] * _precisionScale;
    //        }
    //    }
    NSNumber *minPrice = [array valueForKeyPath:@"@min.self"];
    CGFloat minValue = [minPrice doubleValue];
    minValue *= 0.99;
    return minValue;
}

- (CGFloat)maxValue:(NSArray*)array{
    
    NSNumber *maxPrice = [array valueForKeyPath:@"@max.self"];
    CGFloat maxValue = [maxPrice doubleValue];
    //    CGFloat maxValue = -MAXFLOAT;
    //    for (int i = 0; i < [array count]; i++) {
    //        if ([array[i] floatValue] * _precisionScale> maxValue) {
    //            maxValue = [array[i] floatValue] * _precisionScale;
    //        }
    //        if ([array[i] floatValue] * _precisionScale < minValue) {
    //            minValue = [array[i] floatValue] * _precisionScale;
    //        }
    //    }
    return maxValue*1.02;
}

// 只取小数点之前的数字
- (CGFloat)getNumber:(CGFloat)value{
    NSString *string = [NSString stringWithFormat:@"%f",value];
    if (![[NSMutableString stringWithString:string] containsString:@"."]) {
        return value;
    }
    return [[[string componentsSeparatedByString:@"."] firstObject] floatValue];
}

#pragma mark ----------显示---------------
-(void)show{
    [self addDetailViews];
    [self addLines1With:self.chartScrollView]; //不需要划线
    
    if (self.dataArrOfX.count > 0) {
        self.chartScrollView.contentSize = CGSizeMake(_Xmargin*self.dataArrOfX.count, 0);
    }
    CGFloat x_origin = self.chartScrollView.contentSize.width - self.chartScrollView.frame.size.width;
    if(x_origin >0){
        self.chartScrollView.contentOffset = CGPointMake(self.chartScrollView.contentSize.width - self.chartScrollView.frame.size.width, 0);
    }
    //
    switch (_chartViewStyle) {
        case 0:
            [self showLeftRightView];
            break;
        case 1:
            [self showLeftRightView];
            break;
        case 2:
            [self showLeftRightView];
            break;
            
        default:
            break;
    }
}

//显示左右两种标线
-(void)showLeftRightView{
    if (_leftDataArr.count > 0) {
        for (int i = 0; i < _leftDataArr.count; i++) {
            CGFloat jiange1 = ([self maxValue:_leftDataArr[i]] -[self minValue:_leftDataArr[i]] )/_row;
            if (jiange1 > _leftJiange) {
                _leftJiange = jiange1;
            }
        }
        NSMutableArray * marr = [NSMutableArray array];
        for (int i = 0; i < _leftDataArr.count; i++) {
            NSArray * arr = _leftDataArr[i];
            [marr addObject:[self addDataPointWith:self.chartScrollView andArr:arr andInterval:_leftJiange]];//添加点
        }
        for (int i = 0; i<marr.count; i++) {
            NSArray * arr = [NSArray array];
            if (i < _colors.count) {
                arr = _colors[i];
            }
            [self drawGredientLayer:marr[i] color:@"#108ee9"];
        }
    }
    if (_rightDataArr.count > 0) {
        for (int i = 0; i < _rightDataArr.count; i++) {
            CGFloat jiange1 = ([self maxValue:_rightDataArr[i]] -[self minValue:_rightDataArr[i]])/_row;
            if (jiange1 > _rightJiange) {
                _rightJiange = jiange1;
            }
        }
        NSMutableArray * marr = [NSMutableArray array];
        for (int i = 0; i < _rightDataArr.count; i++) {
            NSArray * arr = _rightDataArr[i];
            [marr addObject:[self addDataPointWith:self.chartScrollView andArr:arr andInterval:_rightJiange]];//添加点
        }
        for (int i = 0; i<marr.count; i++) {
            NSArray * arr = [NSArray array];
            if (i < _colors.count) {
                arr = _colors[i];
            }
            [self drawGredientLayer:marr[i] color:@"#c52b18"];
        }
    }
    
    //
    if (_leftDataArr.count > 0) {
//        for (int i = 0; i < _leftDataArr.count; i++) {
//            CGFloat jiange1 = [self spaceValue:_leftDataArr[i]];
//            if (jiange1 > _leftJiange) {
//                _leftJiange = jiange1;
//            }
//        }
        NSMutableArray * marr = [NSMutableArray array];
        for (int i = 0; i < _leftDataArr.count; i++) {
            NSArray * arr = _leftDataArr[i];
            [marr addObject:[self addDataPointWith:self.chartScrollView andArr:arr andInterval:_leftJiange]];//添加点
        }
        [self.leftPointArr addObjectsFromArray:marr];
        for (int i = 0; i<marr.count; i++) {
            NSArray * arr = [NSArray array];
            if (i < _colors.count) {
                arr = _colors[i];
            }
            [self addBezierPoint:marr[i] andColorStr:_leftColorStrArr[i] andColors:arr];
        }
        ////添加连线
        [self addLeftViews];
    }
    
    if (_rightDataArr.count > 0) {
//        for (int i = 0; i < _rightDataArr.count; i++) {
//            CGFloat jiange1 = [self spaceValue:_rightDataArr[i]];
//            if (jiange1 > _rightJiange) {
//                _rightJiange = jiange1;
//            }
//        }
        
        NSMutableArray * marr = [NSMutableArray array];
        for (int i = 0; i < _rightDataArr.count; i++) {
            NSArray * arr = _rightDataArr[i];
            [marr addObject:[self addDataPointWith:self.chartScrollView andArr:arr andInterval:_rightJiange]];//添加点
        }
        [self.rightPointArr addObjectsFromArray:marr];
        for (int i = 0; i<marr.count; i++) {
            NSArray * arr = [NSArray array];
            if (i < _colors.count) {
                arr = _colors[i];
            }
            [self addBezierPoint:marr[i] andColorStr:_rightColorStrArr[i] andColors:arr];
        }
        ////添加连线
        [self addRightViews];
    }
    
    //处理数据
    if (self.leftPointArr.count > 0) {
        for (int i = 0; i < self.leftPointArr.count; i++) {
            NSMutableArray * marr = [NSMutableArray arrayWithArray:self.leftPointArr[i]];
            if (marr.count > 2) {
                [marr removeObjectAtIndex:0];
                [marr removeObjectAtIndex:marr.count - 1];
            }
            
            self.leftPointArr[i] = marr;
        }
    }
    
    if (self.rightPointArr.count > 0) {
        for (int i = 0; i < self.rightPointArr.count; i++) {
            NSMutableArray * marr = [NSMutableArray arrayWithArray:self.rightPointArr[i]];
            if (marr.count > 2) {
                [marr removeObjectAtIndex:0];
                [marr removeObjectAtIndex:marr.count - 1];
            }
            
            self.rightPointArr[i] = marr;
        }
    }
}

#pragma mark *******************数据源************************
-(void)setDataArrOfX:(NSArray *)dataArrOfX{
    _dataArrOfX = dataArrOfX;
    if(self.dataArrOfX.count < 8){
        _Xmargin = (ScreenWidth - titleWOfY*2 )/self.dataArrOfX.count;
    }
}

#pragma mark *******************分割线************************
-(void)addDetailViews{
    self.chartScrollView = [[YJYTouchScroll alloc] initWithFrame:CGRectMake(titleWOfY, 0, self.bounds.size.width - titleWOfY * 2, self.bounds.size.height)]; // -40
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.userInteractionEnabled = YES;
    [self addSubview:self.chartScrollView];
    
    for(NSInteger i=0;i<=_row;i++){
        //虚线
        if(i >= 0){
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [shapeLayer setBounds:self.chartScrollView.bounds];
            [shapeLayer setPosition:self.chartScrollView.center];
            [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
            [shapeLayer setStrokeColor:[kHEXCOLOR(0xdddddd) CGColor]];
            //            [shapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
            [shapeLayer setLineWidth:0.5f];
            [shapeLayer setLineJoin:kCALineJoinRound];
            [shapeLayer setLineDashPattern:
             [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
              [NSNumber numberWithInt:3],nil]];
            // Setup the path
            CGMutablePathRef path = CGPathCreateMutable();
            if(i == 0){
                CGPathMoveToPoint(path, NULL, 0, 10);
                CGPathAddLineToPoint(path, NULL, self.chartScrollView.contentSize.width,10);
            }else{
                CGPathMoveToPoint(path, NULL, 0, Ymargin *i+10);
                CGPathAddLineToPoint(path, NULL, self.chartScrollView.contentSize.width,Ymargin *i+10);
            }
            [shapeLayer setPath:path];
            CGPathRelease(path);
            [self.chartScrollView.layer addSublayer:shapeLayer];
        }
    }
    
}

#pragma mark 渐变线条
-(void)buildBGCircleLayer:(NSArray *)colors{
    CAShapeLayer *bgCircleLayer = [CAShapeLayer layer];
    bgCircleLayer.path = _circlePath.CGPath;
    bgCircleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
    bgCircleLayer.lineWidth = _lineWidth;
    bgCircleLayer.lineCap = kCALineCapRound; // 截面形状
}

#pragma mark ----------绘画折现----------------
-(void)addBezierPoint:(NSArray *)pointArray andColorStr:(NSString *)colorStr andColors:(NSArray *)colors{

    //取得起始点
    CGPoint p1 = [[pointArray objectAtIndex:0] CGPointValue];
    CGPoint p2 = [[pointArray objectAtIndex:0] CGPointValue];
    p2.y = p2.y + 5 < CGRectGetHeight(self.chartScrollView.frame) ? p2.y + 5 : CGRectGetHeight(self.chartScrollView.frame);
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    _circlePath = beizer;
    
    //直线的连线
    UIBezierPath *beizer2 = [UIBezierPath bezierPath];
    [beizer2 moveToPoint:p1];
    [beizer2 addLineToPoint:CGPointMake(100, 10)];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:CGPointMake(0, CGRectGetHeight(self.chartScrollView.frame))];
    
    [bezier1 addLineToPoint:p1];

    for (int i = 0;i<pointArray.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[pointArray objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[pointArray objectAtIndex:i] CGPointValue];
            //            [beizer addLineToPoint:point];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (_chartLayerStyle == LRSChartGradient) [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == pointArray.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint = nowPoint;
            }
            
        }
    }
    CGFloat bgViewHeight = self.chartScrollView.bounds.size.height;
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    [bezier1 addLineToPoint:p1];
    
    //    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:colorStr andAlpha:1.0].CGColor;
    shapeLayer.lineWidth = 1;
    
    [self.chartScrollView.layer addSublayer:shapeLayer];
    
//    CABasicAnimation *anmi = [CABasicAnimation animation];
//    anmi.keyPath = @"strokeEnd";
//    anmi.fromValue = [NSNumber numberWithFloat:0];
//    anmi.toValue = [NSNumber numberWithFloat:1.0f];
//    anmi.duration =2.0f;
//    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anmi.autoreverses = NO;
//    [shapeLayer addAnimation:anmi forKey:@"stroke"];
}
//
- (void)drawGredientLayer:(NSArray*)pointArr color:(NSString*)colorStr{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.chartScrollView.contentSize.width, self.frame.size.height);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:colorStr andAlpha:0.2].CGColor,(__bridge id)[UIColor colorWithHexString:colorStr andAlpha:0.2].CGColor];

    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,1);
    gradientLayer.endPoint = CGPointMake(0,0);
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = [self path:pointArr].CGPath;
    gradientLayer.mask = arc;
    [self.chartScrollView.layer addSublayer:gradientLayer];
}

//渐变的path
- (UIBezierPath*)path:(NSArray*)pointArray{
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, self.frame.size.height)];
    
    CGPoint prePoint;
    CGPoint nowPoint;
    for (int idx =0; idx<pointArray.count; idx++) {
        
        CGPoint p1 = [[pointArray objectAtIndex:0] CGPointValue];
        if (idx == 0) {
            CGPoint startPoint = p1;
            [bezierPath addLineToPoint:startPoint];
            prePoint = startPoint;
        }else{
            nowPoint = [[pointArray objectAtIndex:idx] CGPointValue];
            [bezierPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];
            prePoint = nowPoint;
        }
    }
    [bezierPath addLineToPoint:CGPointMake([pointArray[pointArray.count-1] CGPointValue].x, self.frame.size.height)];
    
    return bezierPath;
}

#pragma mark ----------获取所有坐标点-------------
-(NSMutableArray *)addDataPointWith:(UIView *)view andArr:(NSArray *)DataArr andInterval:(CGFloat)interval{
    CGFloat height = self.chartScrollView.bounds.size.height;
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:DataArr];
    
    double max = [self maxValue:DataArr];
    double min = [self minValue:DataArr];
    
    double intervalValue = max - min;
    NSMutableArray * marr = [NSMutableArray array];
    
    for (int i = 0; i<arr.count; i++) {
        if(intervalValue == 0){
            intervalValue = 0.001;
        }
        double tempHeight = ([arr[i] doubleValue] - min)/intervalValue;
        
        //        float tempHeight = [arr[i] doubleValue] / (interval * _row) ;
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(((_Xmargin)*i + _Xmargin / 2) , (height *(1 - tempHeight)))];
        if (i == 0) {
            NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(0 , (height *(1 - tempHeight)))];
            [marr addObject:point1];
        }
        [marr addObject:point];
        if (i + 1 == arr.count) {
            NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake((_Xmargin)* (i + 1) , (height *(1 - tempHeight)))];
            [marr addObject:point1];
        }
    }
    return marr;
}

#pragma mark ---------添加左侧Y轴标注--------------
//个数
-(void)addLeftViews{
    double min = [self minValue:self.leftDataArr.firstObject];
    
    for (NSInteger i = 0;i<= _row ;i++ ) {
        CGFloat y;
        if(i == 0){
            y = CGRectGetHeight(_chartScrollView.frame) - 10;
        }else{
            y = CGRectGetHeight(_chartScrollView.frame) - i * Ymargin;
        }
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleWOfY + 1, y - 4, 50 - 5, 20)];
        leftLabel.font = FONTOFSIZE(10.0f);
        leftLabel.textColor = [UIColor colorWithHexString:@"0x111210"];;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.adjustsFontSizeToFitWidth = YES;
        NSString *leftValue;
        double num = _leftJiange *i + min;
        
        leftValue = [DigitalHelperService analyseTransformWith:num];
        leftLabel.text = [NSString stringWithFormat:@"%@",leftValue];
        [self addSubview:leftLabel];
    }
}
#pragma mark ---------添加右侧Y轴标注--------------
-(void)addRightViews{
    double min = [self minValue:self.rightDataArr.firstObject];
    for (NSInteger i = 0; i<= _row ;i++ ) {
        CGFloat y;
        if(i == 0){
            y = CGRectGetHeight(_chartScrollView.frame) - 10;
        }else{
            y = CGRectGetHeight(_chartScrollView.frame) - i * Ymargin;
        }
        NSString *rightValue;
        double num = _rightJiange *i + min;
        rightValue = [DigitalHelperService transformWith:num];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50 + 5 -15 -1, y - 4, 50 - 5, 20)];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textColor = [UIColor colorWithHexString:@"0x111210"];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.text = [NSString stringWithFormat:@"%@",rightValue];
        leftLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:leftLabel];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_chartViewStyle == 0) return;
    UITouch *touch=[touches anyObject];
    
    if (touch.view == self.chartScrollView || touch.view.superview == self.chartScrollView) {
    
        CGPoint point = [touch locationInView:self.chartScrollView];
        float indexF = (point.x-_Xmargin / 2) / _Xmargin;
        
        NSInteger index = (point.x-_Xmargin / 2) / _Xmargin;
        float disparity = indexF - index;
        if (disparity>0.5) {
            index = index+1;
        }
        [self drawOtherLin:index AndPoint:point];
        return;
    }
}

//点击之后画出重点线以及数值
-(void)drawOtherLin:(NSInteger)index AndPoint:(CGPoint)touchpoint{
    if(index > self.dataArrOfX.count-1 || index<0 || self.dataArrOfX.count == 0){
        return ;
    }
    if (self.showSelect && self.selectIndex== index) {
        self.selectView.hidden = YES;
        for (UIView *view in self.charCircleViewArr) {
            [view removeFromSuperview];
        }
        self.showSelect = NO;
        return;
    }
    self.showSelect = YES;
    self.selectIndex = index;
    [self setPaopaoUI:index];
}

-(void)setPaopaoUI:(NSInteger)index{
    [self.chartScrollView bringSubviewToFront:self.selectView];
    self.selectView.hidden = NO;
    self.selectView.frame = CGRectMake(_Xmargin*index+_Xmargin / 2, 0, self.selectView.frame.size.width, self.selectView.frame.size.height);
    [self.chartScrollView bringSubviewToFront:self.selectView];
    [self addCircle:index];
    
    if(self.completion){
        self.completion(index);
    }
}

//圆圈
- (void)addCircle:(NSInteger)index{
    for (UIView *view in self.charCircleViewArr) {
        [view removeFromSuperview];
    }
    NSMutableArray * leftColorArr = [NSMutableArray array];
    NSMutableArray *mutaArr =@[].mutableCopy;
    if(self.leftPointArr.count > 0){
        [mutaArr addObjectsFromArray:self.leftPointArr];
    }
    if(self.rightPointArr.count > 0){
        [mutaArr addObjectsFromArray:self.rightPointArr];
    }
    switch (_chartViewStyle) {
        case 0:
            for (int i = 0; i < _leftColorStrArr.count; i++) {
                [leftColorArr addObject:[UIColor colorWithHexString:_leftColorStrArr[i]]];
            }
            
            [self.charCircleViewArr removeAllObjects];
            [self drawCircle:index arr:self.leftPointArr color:leftColorArr];
            break;
        case 1:
            for (int i = 0; i < _leftColorStrArr.count; i++) {
                [leftColorArr addObject:[UIColor colorWithHexString:_leftColorStrArr[i]]];
            }
            
            [self.charCircleViewArr removeAllObjects];
            [self drawCircle:index arr:self.leftPointArr color:leftColorArr];
            break;
        
        case 2:
            
            for (int i = 0; i < _leftColorStrArr.count; i++) {
                [leftColorArr addObject:[UIColor colorWithHexString:_leftColorStrArr[i]]];
            }
            
            
            for (int i = 0; i < _rightColorStrArr.count; i++) {
                [leftColorArr addObject:[UIColor colorWithHexString:_rightColorStrArr[i]]];
            }
            
            [self.charCircleViewArr removeAllObjects];
            
            [self drawCircle:index arr:mutaArr color:leftColorArr];
            
            
            break;
            
        default:
            break;
    }
}

- (void)drawCircle:(NSInteger)index arr:(NSArray *)pointArr color:(NSArray<UIColor *> *)colors{
    for (int i = 0; i<pointArr.count; i++) {
        NSArray *arr = pointArr[i];
        if (arr.count > index){
            CGPoint point = [arr[index] CGPointValue];
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCircleRadius*2, KCircleRadius*2)];
            view.center = point;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = KCircleRadius;
            view.layer.borderColor = colors[i].CGColor;
            view.layer.borderWidth = 2;
            view.layer.masksToBounds = YES;
            [self.chartScrollView addSubview:view];
            [self.charCircleViewArr addObject:view];
        }
    }
}

-(void)addLines1With:(UIView *)view{
    
    CGFloat magrginHeight = (view.bounds.size.height)/ _row;
    Ymargin = magrginHeight;
    
//    CAShapeLayer * dashLayer = [CAShapeLayer layer];
//    dashLayer.strokeColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1].CGColor;
//    // 默认设置路径宽度为0，使其在起始状态下不显示
//    dashLayer.lineWidth = 0.5;
//
//    UIBezierPath * path = [[UIBezierPath alloc]init];
//    path.lineWidth = 1.0;
//
//    [path moveToPoint:CGPointMake(titleWOfY, CGRectGetHeight(_chartScrollView.frame))];
//    [path addLineToPoint:CGPointMake(titleWOfY,0)];
//    [path moveToPoint:CGPointMake(titleWOfY, CGRectGetHeight(_chartScrollView.frame))];
//    [path addLineToPoint:CGPointMake(CGRectGetMaxX(_chartScrollView.frame),CGRectGetHeight(_chartScrollView.frame))];
//    if (_chartViewStyle == LRSChartViewLeftRightLine) {
//        [path moveToPoint:CGPointMake(CGRectGetMaxX(_chartScrollView.frame) + 1, CGRectGetHeight(_chartScrollView.frame))];
//        [path addLineToPoint:CGPointMake(CGRectGetMaxX(_chartScrollView.frame) + 1,0)];
//    }
//    dashLayer.path = path.CGPath;
//    [self.layer addSublayer:dashLayer];

}

@end
