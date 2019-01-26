//
//  LRSChartView.m
//  LRSChartView
//
//  Created by lreson on 16/7/21.
//  Copyright © 2016年 lreson. All rights reserved.
//

#import "FutureLineChartView.h"
#import "YJYTouchScroll.h"
#import "UIColor+expanded.h"
#import "YJYTouchCollectionView.h"
#import "YJYLinesCell.h"
#import "BTFuturePaoPaoView.h"

#define btnW 12
#define titleWOfY 15
#define kPaoPaoWidth 75.f
#define KCircleRadius 5 //线条上圆圈半径
@interface FutureLineChartView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic,assign)CGFloat jiange;
@property (nonatomic,assign)CGFloat rightJiange;
@property (nonatomic,assign)BOOL showSelect;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)NSMutableArray *charCircleViewArr;

@property (nonatomic, strong) NSMutableArray *countViewArr;
@property (nonatomic, strong) NSMutableArray *dateViewArr;
@property (nonatomic, strong) UILabel *bottomDateView;
@property (nonatomic, strong)NSMutableArray *selectViewArr;

@property (strong,nonatomic) UIBezierPath *circlePath;
@property (strong,nonatomic) CAGradientLayer *gradientlayer;
@property (strong,nonatomic) CAShapeLayer *percentLayer;

@property (nonatomic,strong)YJYTouchCollectionView * xAxiCollectionView;

@property (nonatomic, strong) NSDictionary *defaultAttributedDic;
@property (nonatomic, strong)BTFuturePaoPaoView *paopaoView;


@end

@implementation FutureLineChartView

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
        _row = 4;
    }
    return self;
}

-(YJYTouchCollectionView *)xAxiCollectionView{
    if (!_xAxiCollectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
        collectionViewLayout.minimumInteritemSpacing = 0;
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 0);
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _xAxiCollectionView = [[YJYTouchCollectionView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_chartScrollView.frame), CGRectGetMaxY(_chartScrollView.frame), CGRectGetWidth(_chartScrollView.frame), 30) collectionViewLayout:collectionViewLayout];
        _xAxiCollectionView.backgroundColor = isNightMode?ViewContentBgColor: CWhiteColor;
        [_xAxiCollectionView registerNib:[UINib nibWithNibName:@"YJYLinesCell" bundle:nil] forCellWithReuseIdentifier:@"YJYLinesCell"];
        _xAxiCollectionView.delegate = self;
        _xAxiCollectionView.dataSource = self;
        _xAxiCollectionView.showsHorizontalScrollIndicator = NO;
        _xAxiCollectionView.userInteractionEnabled = YES;
        [self addSubview:_xAxiCollectionView];
    }
    return _xAxiCollectionView;
}

- (NSMutableArray *)charCircleViewArr{
    if (!_charCircleViewArr) {
        _charCircleViewArr = [NSMutableArray new];
    }
    return _charCircleViewArr;
}

- (NSMutableArray*)countViewArr{
    if (!_countViewArr) {
        _countViewArr = [NSMutableArray new];
    }
    return _countViewArr;
}

- (NSMutableArray*)selectViewArr{
    if(!_selectViewArr){
          _selectViewArr = [NSMutableArray new];
    }
    return _selectViewArr;
}
- (NSMutableArray*)dateViewArr{
    if (!_dateViewArr) {
        _dateViewArr = [NSMutableArray new];
    }
    return _dateViewArr;
}

//- (UIView *)selectView {
//    if (!_selectView) {
//        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
//        _selectView.backgroundColor = [UIColor colorWithHexString:@"#108ee9"];
//        [self addSubview:_selectView];
//    }
//    return _selectView;
//}

-(UILabel *)lineLabel{
    
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
    }
    return _lineLabel;
}

#pragma -mark -------------scrollViewDelegate----------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _chartScrollView) {
        _xAxiCollectionView.contentOffset = scrollView.contentOffset;
    }else{
        _chartScrollView.contentOffset = scrollView.contentOffset;
    }
}
#pragma -mark --------------collViewDelegate----------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArrOfX.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJYLinesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYLinesCell" forIndexPath:indexPath];
    cell.titleLB.font = self.x_Font;
    cell.titleLB.textColor = self.x_Color;
    cell.titleLB.text = self.dataArrOfX[indexPath.row];
    cell.titleLB.textAlignment=NSTextAlignmentCenter;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_Xmargin, 20);
}

-(void)setLeftDataArr:(NSArray *)leftDataArr{
    _leftDataArr = leftDataArr;
}

-(void)setRightDataArr:(NSArray *)rightDataArr{
    _rightDataArr = rightDataArr;
    self.pageControl.numberOfPages = 1;
    _rightJiange = 0;
}

- (CGFloat)minValue:(NSArray*)array{
    NSNumber *minPrice = [array valueForKeyPath:@"@min.self"];
    CGFloat minValue = [minPrice doubleValue];
    minValue *= 0.99;
    return minValue;
}

- (CGFloat)maxValue:(NSArray*)array{
    NSNumber *maxPrice = [array valueForKeyPath:@"@max.self"];
    CGFloat maxValue = [maxPrice doubleValue];
    return maxValue*1.002;
}

#pragma mark ----------显示---------------
-(void)show{
    [self addDetailViews];
    [self.xAxiCollectionView reloadData];
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
            if(!self.isNoShowGradient){
                [self drawGredientLayer:marr[i] color:@"#108ee9"];
            }
        }
    }
    if (_rightDataArr.count > 0) {
        _minValue = [self minValue:_rightDataArr.firstObject];
        _maxValue = [self maxValue:_rightDataArr.firstObject];
        for (int i = 0; i < _rightDataArr.count; i++) {
            CGFloat jiange1 = ([self maxValue:_rightDataArr[i]] -[self minValue:_rightDataArr[i]])/_row;
            CGFloat min = [self minValue:_rightDataArr[i]];
            CGFloat max = [self maxValue:_rightDataArr[i]];
            if(min < _minValue){
                _minValue = min;
            }
            if(max > _maxValue){
                _maxValue = max;
            }
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
            if(!self.isNoShowGradient){
                [self drawGredientLayer:marr[i] color:@"#108ee9"];
            }
        }
    }
    //
    if (_leftDataArr.count > 0) {
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
        if(!self.isNoShowGradient){
             [self addRightViews];
        }
       
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
- (void)setDataArrOfX:(NSArray *)dataArrOfX{
    _dataArrOfX = dataArrOfX;
    if(self.dataArrOfX.count < 8){
        _Xmargin = (ScreenWidth - titleWOfY*2 )/self.dataArrOfX.count;
    }
}

#pragma mark *******************分割线************************
- (void)addDetailViews{
    self.chartScrollView = [[YJYTouchScroll alloc] initWithFrame:CGRectMake(titleWOfY, self.chartMargin.top, self.bounds.size.width - titleWOfY * 2, self.bounds.size.height - self.chartMargin.top - self.chartMargin.bottom) ]; //
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.userInteractionEnabled = YES;
    [self addSubview:self.chartScrollView];
    [self addLines1With:self]; //不需要划线
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
    [self.chartScrollView addGestureRecognizer:longPressGesture];
    
    if (self.dataArrOfX.count > 0) {
        self.chartScrollView.contentSize = CGSizeMake(_Xmargin*self.dataArrOfX.count, 0);
    }
    CGFloat x_origin = self.chartScrollView.contentSize.width - self.chartScrollView.frame.size.width;
    if(x_origin >0){
        self.chartScrollView.contentOffset = CGPointMake(self.chartScrollView.contentSize.width - self.chartScrollView.frame.size.width, 0);
    }
    self.xAxiCollectionView.contentOffset = self.chartScrollView.contentOffset;
    //
    if(self.chartMargin.left == 0){
        self.xAxiCollectionView.hidden = YES;
    }
    
    for(NSInteger i = 0;i <= _row;i++){
        //虚线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        if(i == 0){
            lineView.frame = CGRectMake(0, 0, self.chartScrollView.contentSize.width, 1);
        }else{
            if(i == _row){
                lineView.frame = CGRectMake(0, Ymargin *i -1, self.chartScrollView.contentSize.width, 1);
            }else{
                lineView.frame = CGRectMake(0, Ymargin *i , self.chartScrollView.contentSize.width, 1);
            }
            
        }
        
        [self.chartScrollView addSubview:lineView];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:lineView.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[SeparateColor CGColor]];
        [shapeLayer setLineWidth:1];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:3],nil]];
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        if(i == 0){
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, self.chartScrollView.contentSize.width,0);
        }else{
            CGPathMoveToPoint(path, NULL, 0, lineView.frame.origin.y);
            CGPathAddLineToPoint(path, NULL, self.chartScrollView.contentSize.width,lineView.frame.origin.y);
        }
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [self.chartScrollView.layer addSublayer:shapeLayer];
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

    for (int i = 0;i<pointArray.count;i++ ) {
        if (i != 0) {
            
//            CGPoint prePoint = [[pointArray objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[pointArray objectAtIndex:i] CGPointValue];
//            //            [beizer addLineToPoint:point];
//            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            //            if (_chartLayerStyle == LRSChartGradient) [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            [beizer addLineToPoint:nowPoint];
            
            //            if (i == pointArray.count-1) {
            //                [beizer moveToPoint:nowPoint];//添加连线
            //                lastPoint = nowPoint;
            //            }
        }
    }
    //    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:colorStr andAlpha:1.0].CGColor;
    shapeLayer.lineWidth = 1;
    [self.chartScrollView.layer addSublayer:shapeLayer];
}
//
- (void)drawGredientLayer:(NSArray*)pointArr color:(NSString*)colorStr{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = CGRectMake(0, 0, self.chartScrollView.contentSize.width, self.chartScrollView.size.height);
    gradientLayer.colors = @[(__bridge id)rgba(16,142,233,0.30).CGColor,(__bridge id)rgba(255,255,255,0.20).CGColor];

    gradientLayer.locations=@[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0);
    gradientLayer.endPoint = CGPointMake(0,1);
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = [self path:pointArr].CGPath;
    gradientLayer.mask = arc;
    [self.chartScrollView.layer addSublayer:gradientLayer];
}

//渐变的path
- (UIBezierPath*)path:(NSArray*)pointArray{
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, self.chartScrollView.size.height -1)];
    
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
            //            [bezierPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2.0, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2.0, nowPoint.y)];
            //            prePoint = nowPoint;
            [bezierPath addLineToPoint:nowPoint];
        }
    }
    [bezierPath addLineToPoint:CGPointMake([pointArray[pointArray.count-1] CGPointValue].x, self.chartScrollView.size.height -1)];
    
    return bezierPath;
}

#pragma mark ----------获取所有坐标点-------------
- (NSMutableArray *)addDataPointWith:(UIView *)view andArr:(NSArray *)DataArr andInterval:(CGFloat)interval{
    CGFloat height = self.chartScrollView.bounds.size.height;
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:DataArr];
    
    double max = [self maxValue:DataArr];
    double min = [self minValue:DataArr];
    
    double intervalValue = _maxValue - _minValue;

    NSMutableArray * marr = [NSMutableArray array];
    
    for (int i = 0; i<arr.count; i++) {
        if(intervalValue == 0){
            intervalValue = 0.001;
        }
        double tempHeight = ([arr[i] doubleValue] - _minValue)/intervalValue;
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
        leftLabel.textColor = FirstColor;
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
        y = CGRectGetHeight(self.frame) - self.chartMargin.bottom - i * Ymargin -20;
        
        NSString *rightValue;
        double num = (_maxValue - _minValue)/_row *i + min;
        rightValue = [DigitalHelperService transformWith:num];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50 + 5 -15 -1, y, 50 - 5, 20)];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textColor = FirstColor;
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.text = [NSString stringWithFormat:@"%@",rightValue];
        leftLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:leftLabel];
    }
}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    if (_chartViewStyle == 0) return;
//    UITouch *touch=[touches anyObject];
//
//    if (touch.view == self.chartScrollView || touch.view.superview == self.chartScrollView) {
//
//        CGPoint point = [touch locationInView:self.chartScrollView];
//        float indexF = (point.x-_Xmargin / 2) / _Xmargin;
//
//        NSInteger index = (point.x-_Xmargin / 2) / _Xmargin;
//        float disparity = indexF - index;
//        if (disparity>0.5) {
//            index = index+1;
//        }
//        [self drawOtherLin:index AndPoint:point];
//        return;
//    }
//}

//点击之后画出重点线以及数值
-(void)drawOtherLin:(NSInteger)index AndPoint:(CGPoint)touchpoint{
    if(index > self.dataArrOfX.count-1 || index<0 || self.dataArrOfX.count == 0){
        return ;
    }
//    if (self.showSelect && self.selectIndex== index) {
    //        self.selectView.hidden = YES;
    //        for (UIView *view in self.charCircleViewArr) {
    //            [view removeFromSuperview];
    //        }
    //        self.showSelect = NO;
    //        return;
    //    }
//    self.showSelect = YES;
    self.selectIndex = index;
    [self setPaopaoUI:index];
}

-(void)setPaopaoUI:(NSInteger)index{
    //    [self.chartScrollView bringSubviewToFront:self.selectView];
    for (UIView *view in self.selectViewArr) {
        [view removeFromSuperview];
    }
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    _selectView.backgroundColor = [UIColor colorWithHexString:@"#108ee9"];
    [self addSubview:_selectView];
    self.selectView.frame = CGRectMake(_Xmargin*index+_Xmargin / 2 +15 - self.chartScrollView.contentOffset.x, 0, self.selectView.frame.size.width, self.selectView.frame.size.height -12);
    [self.selectViewArr  addObject:self.selectView];
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
    for (UIView *view in self.countViewArr) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.dateViewArr) {
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
            view.center = CGPointMake(point.x +15 -self.chartScrollView.contentOffset.x, point.y + self.chartMargin.top);
            
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = KCircleRadius;
            view.layer.borderColor = colors[i].CGColor;
            view.layer.borderWidth = 2;
            view.layer.masksToBounds = YES;
            
            [self addSubview:view];
            [self.charCircleViewArr addObject:view];
            NSDictionary *dict;
            if(self.originDataArr.count >0){
                dict = self.originDataArr[index];
            }else{
                dict = nil;
            }
            
            if(!self.isNoShowGradient){
                
                if(self.isHoldCount){
                    UILabel *countLabel = [UILabel new];
                    countLabel.font = FONTOFSIZE(9);
                    countLabel.textAlignment = NSTextAlignmentCenter;
                    countLabel.layer.cornerRadius = 2.0f;
                    countLabel.layer.masksToBounds = YES;
                    countLabel.textColor = [UIColor whiteColor];
                    countLabel.clipsToBounds = YES;
                    [self addSubview:countLabel];
                    countLabel.backgroundColor = kHEXCOLOR(0x108ee9);
                    NSArray *arr = self.rightDataArr.firstObject;
                    NSNumber *nums = arr[index];
                    NSString *countStr = [NSString stringWithFormat:@"%@:%@",self.singleTitle,[DigitalHelperService transformWith:nums.doubleValue]];
                    NSMutableAttributedString * countMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:countStr attributes:self.defaultAttributedDic];
                    CGSize countMarkerStrAttSize = [countMarkerStrAtt size];
                    countLabel.text = countStr;
                    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(24);
                        make.centerX.equalTo(view.mas_centerX);
                        make.centerY.equalTo(view.mas_centerY).offset(-17 -KCircleRadius);
                        make.width.mas_equalTo(countMarkerStrAttSize.width +14);
                    }];
                    
                    [self.countViewArr addObject:countLabel];
                }else{
                    self.paopaoView =  [BTFuturePaoPaoView loadFromXib];
                    [self addSubview:self.paopaoView];
                    NSString *longStr = [NSString stringWithFormat:@"%@%.2f%%", [APPLanguageService sjhSearchContentWith:@"zuoduozhanghu"],[SAFESTRING(dict[@"futuresLong"]) doubleValue]*100];
                    NSString *shortStr = [NSString stringWithFormat:@"%@%.2f%%", [APPLanguageService sjhSearchContentWith:@"zuokongzhanghu"],[SAFESTRING(dict[@"futuresShort"]) doubleValue]*100];
                    self.paopaoView.topL.text = longStr;
                    self.paopaoView.bottomL.text = shortStr;
                    
                    NSMutableAttributedString * longMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:longStr attributes:self.defaultAttributedDic];
                    CGSize longMarkerStrAttSize = [longMarkerStrAtt size];
                    NSMutableAttributedString * shortMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:shortStr attributes:self.defaultAttributedDic];
                    CGSize shortMarkerStrAttSize = [shortMarkerStrAtt size];
                    CGFloat width = longMarkerStrAttSize.width;
                    if(width < shortMarkerStrAttSize.width){
                        width = shortMarkerStrAttSize.width;
                    }
                    [self.paopaoView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(40);
                        make.centerX.equalTo(view.mas_centerX);
                        make.centerY.equalTo(view.mas_centerY).offset(-25 -KCircleRadius);
                        make.width.mas_equalTo(width + 14);
                    }];
                    [self layoutIfNeeded];
                    CGFloat dateX =  view.center.x - (width +14)/2;
                    CGFloat rightDateX = view.center.x + (width +14)/2;
                    if(dateX < 0){
                        [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(view.mas_centerX).offset((width)/5);
                        }];
                    }else if(rightDateX > self.frame.size.width){
                        [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(view.mas_centerX).offset(- (width)/5);
                        }];
                    }else{
                        [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(view.mas_centerX);
                        }];
                    }
                    
                    [self.countViewArr addObject:self.paopaoView];
                }
            }
            
            //
            _bottomDateView = [UILabel new];
            _bottomDateView.font = FONTOFSIZE(9);
            _bottomDateView.textAlignment = NSTextAlignmentCenter;
            _bottomDateView.layer.cornerRadius = 2.0f;
            _bottomDateView.layer.masksToBounds = YES;
            _bottomDateView.textColor = [UIColor whiteColor];
            _bottomDateView.clipsToBounds = YES;
            _bottomDateView.backgroundColor = MainBg_Color;
            [self addSubview:self.bottomDateView];
            [self.dateViewArr addObject:self.bottomDateView];
            
            NSString *dateStr;
            if([dict isKindOfClass:[NSDictionary class]]){
                dateStr = [NSString stringWithFormat:@"%@",SAFESTRING(dict[@"date"])];
            }else{
                dateStr = self.dataArrOfX[index];
            }
            
            NSString *str = dateStr;
            NSMutableAttributedString * rightMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:str attributes:self.defaultAttributedDic];
            CGSize rightMarkerStrAttSize = [rightMarkerStrAtt size];
            self.bottomDateView.text = str;
            //
            [self.bottomDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-(_chartMargin.bottom - 13 -7));
                make.height.mas_equalTo(13);
                make.centerX.equalTo(view.mas_centerX);
                make.width.mas_equalTo(rightMarkerStrAttSize.width +14);
            }];
            
            [self layoutIfNeeded];
            CGFloat dateX =  view.center.x - (rightMarkerStrAttSize.width +14)/2;
            CGFloat rightDateX = view.center.x + ( rightMarkerStrAttSize.width +14)/2;
            if(dateX < 0){
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX).offset((rightMarkerStrAttSize.width)/5);
                }];
            }else if(rightDateX > self.frame.size.width){
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX).offset(- (rightMarkerStrAttSize.width)/5);
                }];
            }else{
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX);
                }];
            }
            
        }
    }
}

-(void)addLines1With:(UIView *)view{
    CGFloat magrginHeight = (view.bounds.size.height - self.chartMargin.top - self.chartMargin.bottom)/ _row;
    Ymargin = magrginHeight;
}

#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state){
        
        CGPoint point = [longPress locationInView:self.chartScrollView];
//        CGPoint xPoint = [self.chartScrollView convertPoint:point toView:self];
//
//        if(xPoint.x <titleWOfY){
//            for (UIView *view in self.charCircleViewArr) {
//                [view removeFromSuperview];
//            }
//            for (UIView *view in self.countViewArr) {
//                [view removeFromSuperview];
//            }
//            for (UIView *view in self.dateViewArr) {
//                [view removeFromSuperview];
//            }
//            for (UIView *view in self.selectViewArr) {
//                [view removeFromSuperview];
//            }
//            return;
//        }
        self.selectView.hidden = NO;
        float indexF = (point.x-_Xmargin / 2) / _Xmargin;
        
        NSInteger index = (point.x-_Xmargin / 2) / _Xmargin;
        float disparity = indexF - index;
        if (disparity>0.5) {
            index = index+1;
        }
        [self drawOtherLin:index AndPoint:point];
    }
    if(longPress.state == UIGestureRecognizerStateEnded){
        if(self.cancelBlock){
            self.cancelBlock();
        }
        for (UIView *view in self.charCircleViewArr) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.countViewArr) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.dateViewArr) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.selectViewArr) {
            [view removeFromSuperview];
        }
    }
}

- (NSDictionary *)defaultAttributedDic{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _defaultAttributedDic;
}

@end
