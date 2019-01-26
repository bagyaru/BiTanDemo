//
//  LewBarChart.m
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "LewBarChart.h"
#import "LewBar.h"
#import "LewCommon.h"
#import "BTFuturePaoPaoView.h"
#define XLabelMarginTop 5
#define YLabelMarginRight 5
#define XAxisMarginLeft 10
#define XAxisMarginRight 10
#define YAxisMarginTop 10
#define LegendTextSize 10

@interface LewBarChart ()

@property (nonatomic, strong)NSMutableArray<LewBar *> *bars;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) NSMutableArray *pointArr;

@property (nonatomic, strong) UILabel *bottomDateView;
@property (nonatomic, strong) NSDictionary *defaultAttributedDic;
@property (nonatomic, strong)BTFuturePaoPaoView *paopaoView;

@end

@implementation LewBarChart

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _showXAxis = YES;
        _showYAxis = YES;
        
        self.backgroundColor = [UIColor clearColor];
        _bars = [NSMutableArray array];
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [self addGestureRecognizer:longPressGesture];
        _pointArr = @[].mutableCopy;
        
    }
    return self;
}

- (void)show{
    
    [self drawDashLine];
    [self addLeftViews];
    
    CGFloat groupCount = [_data.dataSets[0].yValues count];
    //    CGFloat itemCount = [_data.dataSets count];
    _data.groupSpace = (self.bounds.size.width - _chartMargin.left - _chartMargin.right - groupCount*12)/(groupCount - -1);
    CGFloat groupWidth = (self.bounds.size.width - _chartMargin.left - _chartMargin.right + _data.groupSpace) / groupCount - _data.groupSpace;
    CGFloat barHeight = self.bounds.size.height - _chartMargin.top - _chartMargin.bottom;
    
    CGFloat barWidth = 5; //(groupWidth+_data.itemSpace)/itemCount - _data.itemSpace;
    
    for (int i = 0; i<_data.dataSets.count; i++) {
        LewBarChartDataSet *dataset = _data.dataSets[i];
        for (int j = 0; j<dataset.yValues.count; j++) {
            CGFloat bar_x = _chartMargin.left + j*(groupWidth+_data.groupSpace) + i*(barWidth+_data.itemSpace);
            LewBar *bar = [[LewBar alloc]initWithFrame:CGRectMake(bar_x, _chartMargin.top, barWidth, barHeight)];
            if(i == 0){
                [_pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(bar_x, bar_x+_data.itemSpace +2*barWidth)]];
            }
            NSNumber *yValue = dataset.yValues[j];
            bar.barProgress = isnan(yValue.floatValue/_data.yMaxNum)? 0:(yValue.floatValue/_data.yMaxNum);
            bar.barColor = dataset.barColor;
            bar.backgroundColor = dataset.BarbackGroudColor;
            if (_showNumber) {
                bar.barText = yValue.stringValue;
            }
            bar.displayAnimated = _displayAnimated;
            [_bars addObject:bar];
            [self addSubview:bar];
        }
    }
//    if (_data.isGrouped) {
//        [self setupLegendView];
//    }
}
- (void)drawRect:(CGRect)rect {
 // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘 X 轴数据
    if (_data.xLabels) {
        //        NSUInteger xLabelCount = _data.xLabels.count;
        //        CGFloat xLabelWidth = (self.bounds.size.width - _chartMargin.left - _chartMargin.right + _data.groupSpace) / xLabelCount - _data.groupSpace;
        
        CGFloat xLabelHeight = _chartMargin.bottom - XLabelMarginTop;
        UIFont  *font = [UIFont systemFontOfSize:_data.xLabelFontSize];//设置
        [_data.xLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = [_pointArr[idx] CGPointValue];
            
            //            CGRect rect = CGRectMake(_chartMargin.left+idx*(xLabelWidth+_data.groupSpace), self.bounds.size.height-_chartMargin.bottom + XLabelMarginTop, xLabelWidth, xLabelHeight);
            CGRect rect = CGRectMake(point.x - 10, self.bounds.size.height-_chartMargin.bottom + XLabelMarginTop, point.y - point.x +20 , xLabelHeight);
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            style.alignment = NSTextAlignmentCenter;
            [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:_data.xLabelTextColor} context:nil];
        }];
    }
    // 绘 Y 轴数据
    //    if (_data. yLabels) {
    //        NSUInteger yLabelCount = _data.yLabels.count;
    //        CGFloat yLabelWidth = _chartMargin.left-XAxisMarginLeft;
    //        CGFloat yLabelHeight = _data.yLabelFontSize;
    //
    //        CGFloat yLabelSpace = (self.bounds.size.height-_chartMargin.top-_chartMargin.bottom+YAxisMarginTop-(yLabelCount*yLabelHeight))/(yLabelCount-1);
    //
    //        UIFont  *font = [UIFont systemFontOfSize:_data.yLabelFontSize];//设置
    //        [_data.yLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            CGRect rect = CGRectMake(0, _chartMargin.top-YAxisMarginTop+idx*(yLabelHeight+yLabelSpace), yLabelWidth-YLabelMarginRight, yLabelHeight);
    //
    //            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //            style.alignment = NSTextAlignmentRight;
    //            [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName: _data.yLabelTextColor} context:nil];
    //        }];
    //    }
    // 绘 x/y 坐标轴
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    
    if (_showYAxis) {
        CGContextMoveToPoint(context, _chartMargin.left-XAxisMarginLeft- 0.5, _chartMargin.top-YAxisMarginTop); //设置线的起始点
        CGContextAddLineToPoint(context, _chartMargin.left-XAxisMarginLeft, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线中间的一个点
        CGContextStrokePath(context);//直接把所有的点连起来
    }
//    if (_showXAxis) {
//        CGContextMoveToPoint(context, _chartMargin.left-XAxisMarginLeft, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线的起始点
//        CGContextAddLineToPoint(context, self.bounds.size.width-_chartMargin.right+XAxisMarginRight, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线中间的一个点
//        CGContextStrokePath(context);//直接把所有的点连起来
//    }
}

#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state){
        CGPoint location = [longPress locationInView:self];
        //初始化竖线
        if(!self.verticalView)
        {
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self addSubview:self.verticalView];
            self.verticalView.backgroundColor = rgba(16,142,233,0.30);
            self.verticalView.frame = CGRectMake(0, 0, 30, self.frame.size.height);
            
        }
        if(!self.bottomDateView){
            _bottomDateView = [UILabel new];
            _bottomDateView.font = FONTOFSIZE(9);
            _bottomDateView.textAlignment = NSTextAlignmentCenter;
            _bottomDateView.layer.cornerRadius = 2.0f;
            _bottomDateView.layer.masksToBounds = YES;
            _bottomDateView.textColor = [UIColor whiteColor];
            _bottomDateView.clipsToBounds = YES;
            _bottomDateView.backgroundColor = MainBg_Color;
            [self addSubview:_bottomDateView];
            [_bottomDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-12);
                make.centerX.equalTo(self.verticalView.mas_centerX);
                make.height.mas_equalTo(13);
            }];
        }
        NSInteger index = [self validIndex:location.x];
        
        if(!self.paopaoView){
            self.paopaoView =  [BTFuturePaoPaoView loadFromXib];
            [self addSubview:self.paopaoView];
           
            [self.paopaoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40);
                make.centerX.equalTo(self.verticalView.mas_centerX);
                make.top.equalTo(self);
            }];
        }
        
        if(index >=0 &&index<self.originData.count){
            NSDictionary *dict = self.originData[index];
            NSString *longStr = [NSString stringWithFormat:@"%@%.2f%%", [APPLanguageService sjhSearchContentWith:@"duotou"],[SAFESTRING(dict[@"futuresLong"]) doubleValue]*100];
            NSString *shortStr = [NSString stringWithFormat:@"%@%.2f%%", [APPLanguageService sjhSearchContentWith:@"kongtou"],[SAFESTRING(dict[@"futuresShort"]) doubleValue]*100];
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
            [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width + 14);
            }];
            
            [self layoutIfNeeded];
            CGFloat datePaoX =  self.verticalView.center.x - (width +14)/2;
            CGFloat rightDatePaoX = self.verticalView.center.x + (width +14)/2;
            if(datePaoX < 0){
                [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX).offset((width)/5);
                }];
            }else if(rightDatePaoX > self.frame.size.width){
                [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX).offset(- (width)/5);
                }];
            }else{
                [self.paopaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX);
                }];
            }
            
            NSString *str = [NSString stringWithFormat:@"%@",SAFESTRING(dict[@"date"])];
            NSMutableAttributedString * rightMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:str attributes:self.defaultAttributedDic];
            CGSize rightMarkerStrAttSize = [rightMarkerStrAtt size];
            self.bottomDateView.text = str;
            [_bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.verticalView.mas_centerX);
                make.width.mas_equalTo(rightMarkerStrAttSize.width +14);
            }];
            [self layoutIfNeeded];
            CGFloat dateX =  self.verticalView.center.x - (rightMarkerStrAttSize.width +14)/2;
            CGFloat rightDateX = self.verticalView.center.x + ( rightMarkerStrAttSize.width +14)/2;
            if(dateX < 0){
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX).offset((rightMarkerStrAttSize.width)/5);
                }];
            }else if(rightDateX > self.frame.size.width){
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX).offset(- (rightMarkerStrAttSize.width)/5);
                }];
            }else{
                [self.bottomDateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.verticalView.mas_centerX);
                }];
            }
        }
       //
        CGPoint point = [self isValid:location.x];
        if(point.x == 0){
            self.verticalView.hidden = YES;
            self.bottomDateView.hidden = YES;
            self.paopaoView.hidden = YES;
        }else{
            self.verticalView.hidden = NO;
            self.bottomDateView.hidden = NO;
            self.paopaoView.hidden = NO;
            self.verticalView.frame = CGRectMake(point.x, 0, point.y - point.x, self.frame.size.height - self.chartMargin.bottom);
        }
    }
    if(longPress.state == UIGestureRecognizerStateEnded){
        if(self.verticalView){
            self.verticalView.hidden = YES;
        }
        if(self.bottomDateView){
            self.bottomDateView.hidden = YES;
        }
        if(self.paopaoView){
            self.paopaoView.hidden = YES;
        }
    }
}

- (CGPoint)isValid:(CGFloat)pointX{
    CGFloat width = _data.groupSpace;
    for(NSValue *value in _pointArr){
        CGPoint point = [value CGPointValue];
        
        if(pointX>= (point.x - width/2) && pointX<= (point.y +width/2)){
            return point;
        }
    }
    return CGPointZero;
}

- (NSInteger)validIndex:(CGFloat)pointX{
    CGFloat width = _data.groupSpace;
    NSUInteger i = -1;
    for(NSValue *value in _pointArr){
        i++;
        CGPoint point = [value CGPointValue];
        if(pointX>= (point.x - width/2) && pointX<= (point.y +width/2)){
            return i;
        }
    }
    return -1;
}

//加左标注
-(void)addLeftViews{
    CGFloat margin = (self.frame.size.height - _chartMargin.bottom - 10) /4;
    CGFloat yMarginValue = (_data.yMaxNum - _data.yMinNum)/4;
    for (NSInteger i = 0;i< 5 ;i++ ) {
        CGFloat y = self.frame.size.height - _chartMargin.bottom -  margin *i + 1;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 , y - 1 -20, 50 - 5, 20)];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textColor = FirstColor;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.adjustsFontSizeToFitWidth = YES;
        double value = _data.yMinNum + yMarginValue*i;
        NSString *leftValue = [NSString stringWithFormat:@"%.3f",value];
        leftLabel.text = [NSString stringWithFormat:@"%@",leftValue];
        [self addSubview:leftLabel];
    }
}

//
- (void)drawDashLine{
    CGFloat margin = (self.frame.size.height - _chartMargin.bottom - 5) /4;
    for (int i = 0; i<5; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15,  self.frame.size.height - _chartMargin.bottom -  margin *i + 1, self.frame.size.width - 30, 1)];
        [self addSubview:lineView];
        [self drawDashLine:lineView lineLength:3 lineSpacing:5 lineColor:SeparateColor];
    }
}

//画虚线
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
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

