//
//  Y_KLineMainView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMainView.h"
#import "UIColor+Y_StockChart.h"

#import "Y_KLine.h"
#import "Y_MALine.h"
#import "Y_KLinePositionModel.h"
#import "Y_StockChartGlobalVariable.h"
#import "Masonry.h"
@interface Y_KLineMainView()


/**
 *  Index开始X的值
 */
@property (nonatomic, assign) CGFloat startXPosition;

/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;

/**
 *  旧的缩放值
 */
@property (nonatomic, assign) CGFloat oldScale;

/**
 *  MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA7Positions;

@property (nonatomic, strong) NSMutableArray *MA10Positions;


/**
 *  MA30位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA30Positions;

/**
 *  BOLL_MB位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_MBPositions;

/**
 *  BOLL_UP位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_UPPositions;

/**
 *  BOLL_DN位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_DNPositions;

//EMA7
@property (nonatomic, strong) NSMutableArray *EMA7Positions;

@property (nonatomic, strong) NSMutableArray *EMA10Positions;

@property (nonatomic, strong) NSMutableArray *EMA30Positions;

@property (nonatomic, strong) CALayer *breathingPoint;


@end

@implementation Y_KLineMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.needDrawKLineModels = @[].mutableCopy;
        self.needDrawKLinePositionModels = @[].mutableCopy;
        self.MA7Positions = @[].mutableCopy;
        self.MA10Positions = @[].mutableCopy;
        self.MA30Positions = @[].mutableCopy;
        
        self.BOLL_UPPositions = @[].mutableCopy;
        self.BOLL_DNPositions = @[].mutableCopy;
        self.BOLL_MBPositions = @[].mutableCopy;
        
        self.EMA7Positions = @[].mutableCopy;
        self.EMA10Positions = @[].mutableCopy;
        self.EMA30Positions = @[].mutableCopy;
        
        _needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
    }
    return self;
}

#pragma mark - 绘图相关方法

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    CGFloat xOffset = self.referenceScrollView.contentOffset.x;
    
    //如果数组为空，则不进行绘制，直接设置本view为背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!self.kLineModels)
    {
        CGContextClearRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
        CGContextFillRect(context, rect);
        return;
    }
    //设置View的背景颜色
    NSMutableArray *kLineColors = @[].mutableCopy;
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
    CGContextFillRect(context, rect);
    
    
    [self drawHLineRect:rect inContext:context];
    
    //设置显示日期的区域背景颜色
    CGContextSetFillColorWithColor(context, [UIColor assistBackgroundColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, Y_StockChartKLineMainViewMaxY+20, self.frame.size.width, 20));
    
    Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
    
    if(self.MainViewType == Y_StockChartcenterViewTypeKline)
    {
        Y_KLine *kLine = [[Y_KLine alloc]initWithContext:context];
        kLine.maxY = Y_StockChartKLineMainViewMaxY;
//        [self.breathingPoint removeFromSuperlayer];
        
        
        __block   BOOL isMax = NO;
        __block   BOOL isMin = NO;
        Y_KLineModel *firstModel = self.needDrawKLineModels.firstObject;
        __block double minAssert = firstModel.Low.doubleValue;
        __block NSNumber* maxAssert = firstModel.High;
        [self.needDrawKLineModels enumerateObjectsUsingBlock:^(Y_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if(kLineModel.High.doubleValue > maxAssert.doubleValue)
            {
                maxAssert = kLineModel.High;
            }
            if(kLineModel.Low.doubleValue < minAssert)
            {
                minAssert = kLineModel.Low.doubleValue;
            }
        }];
        
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLine.kLinePositionModel = kLinePositionModel;
            kLine.kLineModel = self.needDrawKLineModels[idx];
            kLine.needKlineModel = self.needDrawKLineModels;
            UIColor *kLineColor = [kLine draw];
            if([kLine.kLineModel.High isEqualToNumber:maxAssert]){
                if(!isMax){
                    [kLine drawHighAndLow:rect];
                    isMax = YES;
                }
            }
            if(kLine.kLineModel.Low.doubleValue  == minAssert){
                if(!isMin){
                    [kLine drawHighAndLow:rect];
                    isMin = YES;
                }
            }
            [kLineColors addObject:kLineColor];
        }];
        
        
    } else {//分时线处理
        
        //渐变色
        [self drawLinearGradient:context path:[self getPath:context] startColor:[[UIColor redColor] colorWithAlphaComponent:1].CGColor endColor:[[UIColor colorWithHexString:@"0174FF"] colorWithAlphaComponent:1.0].CGColor];
        
        
        __block NSMutableArray *positions = @[].mutableCopy;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *strokeColor = positionModel.OpenPoint.y < positionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
            [kLineColors addObject:strokeColor];
            [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
            if(idx == self.needDrawKLinePositionModels.count - 1){
                Y_KLineModel *model = self.kLineModels.lastObject;
                if([self.needDrawKLineModels containsObject:model]){
//                    [self.referenceScrollView.layer insertSublayer:_breathingPoint above:self.layer];
//                    CGFloat x = self.referenceScrollView.contentOffset.x + positionModel.ClosePoint.x - 3;
                    CGContextSetRGBFillColor(context, 255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0f, 1.0f);
                    CGContextFillPath(context);
                    
                    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"2787B7"].CGColor);
                    CGContextAddArc(context, positionModel.ClosePoint.x - 1 , positionModel.ClosePoint.y -1, 2, 0 , 2 *M_PI, 0);
                    
                    
                    
                   
//                    if(x >ScreenWidth - 10){
//                        self.breathingPoint.hidden = NO;
//                        self.breathingPoint.frame = CGRectMake(self.referenceScrollView.contentOffset.x + positionModel.ClosePoint.x - 3,
//                                                               positionModel.ClosePoint.y + 2,4,4);
//                    }else{
//                        self.breathingPoint.hidden = YES;
//                    }
                    
                }
            }
            
        }];
        
        MALine.MAPositions = positions;
        MALine.MAType = -1;
        [MALine draw];
       
//        __block CGPoint lastDrawDatePoint = CGPointZero;//fix
//        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            CGPoint point = [positions[idx] CGPointValue];
//            //日期
//            NSString *dateStr = self.needDrawKLineModels[idx].Date;
//            //时间
//            //CGFloat width = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.width;
//            // CGPoint drawDatePoint = CGPointMake(point.x -width/2, Y_StockChartKLineMainViewMaxY + 5);
//            CGPoint drawDatePoint = CGPointMake(point.x, Y_StockChartKLineMainViewMaxY + 5);
//            //to do
//            if(CGPointEqualToPoint(lastDrawDatePoint, CGPointZero) || point.x - lastDrawDatePoint.x > 60 ){
//
//                [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
//                lastDrawDatePoint = drawDatePoint;
//            }
//        }];
    }
    
    //主指标
    if (self.targetLineStatus == Y_StockChartTargetLineStatusBOLL) {
        // 画BOLL MB线 标准线
        MALine.MAType = Y_BOLL_MB;
        MALine.BOLLPositions = self.BOLL_MBPositions;
        [MALine draw];
        
        // 画BOLL UP 上浮线
        MALine.MAType = Y_BOLL_UP;
        MALine.BOLLPositions = self.BOLL_UPPositions;
        [MALine draw];
        
        // 画BOLL DN下浮线
        MALine.MAType = Y_BOLL_DN;
        MALine.BOLLPositions = self.BOLL_DNPositions;
        [MALine draw];
        
    } else if ( self.targetLineStatus == Y_StockChartTargetLineStatusMA){
        
        //画MA7线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.MA7Positions;
        [MALine draw];
        
        //MA10
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.MA10Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.MA30Positions;
        [MALine draw];
        
    }else if(self.targetLineStatus == Y_StockChartTargetLineStatusEMA) {
        //画MA7线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.EMA7Positions;
        [MALine draw];
        
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.EMA10Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.EMA30Positions;
        [MALine draw];
    }
    
    if(self.delegate && kLineColors.count > 0)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineColors:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(drawDate:models:)]){
        [self.delegate drawDate:self.needDrawKLinePositionModels models:self.needDrawKLineModels];
    }
}

- (CGPathRef)getPath:(CGContextRef)context{
    CGMutablePathRef path = CGPathCreateMutable();
    __block NSMutableArray *positions = @[].mutableCopy;
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
    }];
    
    CGPoint firstPoint = [positions.firstObject CGPointValue];
    NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：BOLL画线");
    CGContextMoveToPoint(context, firstPoint.x, Y_StockChartKLineMainViewMaxY +20);
    CGContextAddLineToPoint(context, firstPoint.x, firstPoint.y);

    for (NSInteger idx = 1; idx < positions.count ; idx++)
    {
        CGPoint point = [positions[idx] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
        if(idx == positions.count -1){
            CGContextAddLineToPoint(context, point.x, Y_StockChartKLineMainViewMaxY +20);
        }
    }
    
    return path;
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    
    CGMutablePathRef fillPath = CGPathCreateMutableCopy(path);
    NSArray *colors = @[(id)[[UIColor colorWithHexString:@"63BEFF"] colorWithAlphaComponent:0.1].CGColor,(id)[[UIColor colorWithHexString:@"63BEFF"] colorWithAlphaComponent:0.1].CGColor]; // 渐变色数组
    //创建CGContextRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //           CGFloat locations[2] = { 0.0, 1.0 }; // 颜色位置设置,要跟颜色数量相等，否则无效
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, NULL);    // 渐变颜色效果设置
    //起止点设置
    //            CGRect pathRect = CGPathGetBoundingBox(fillPath);
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, self.frame.size.height);
    
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
    
    CGPathRelease(path);
}


- (void)drawHLineRect:(CGRect)rect inContext:(CGContextRef)context{
    CGContextSetStrokeColorWithColor(context, [UIColor lineColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat unitHeight = (Y_StockChartKLineMainViewMaxY +20)/4;
    
    const CGPoint line2[] = {CGPointMake(0, unitHeight),CGPointMake(self.frame.size.width, unitHeight)};
    const CGPoint line3[] = {CGPointMake(0, unitHeight*2),CGPointMake(self.frame.size.width, unitHeight*2)};
    const CGPoint line4[] = {CGPointMake(0, unitHeight*3),CGPointMake(self.frame.size.width, unitHeight*3)};
    CGContextStrokeLineSegments(context, line2, 2);
    CGContextStrokeLineSegments(context, line3, 2);
    CGContextStrokeLineSegments(context, line4, 2);
}

#pragma mark 重新设置相关数据，然后重绘
- (void)drawMainView{
    //    NSAssert(self.kLineModels, @"kLineModels不能为空");
    if(self.kLineModels.count == 0) return;
    //提取需要的kLineModel
    [self private_extractNeedDrawModels];
    //转换model为坐标model
    [self private_convertToKLinePositionModelWithKLineModels];
    
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

/**
 *  更新MainView的宽度
 */
- (void)updateMainViewWidth{
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    CGFloat kLineViewWidth = self.kLineModels.count * [Y_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2;

    if(kLineViewWidth < self.referenceScrollView.bounds.size.width) {
        kLineViewWidth = self.referenceScrollView.bounds.size.width;
    }
    //    if (kLineViewWidth < [UIScreen mainScreen].bounds.size.width) {
    //        kLineViewWidth = [UIScreen mainScreen].bounds.size.width;
    //    }
//
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(kLineViewWidth));
//    }];
    [self layoutIfNeeded];
    //更新scrollview的contentsize
//    self.referenceScrollView.contentSize = CGSizeMake(kLineViewWidth, self.referenceScrollView.contentSize.height);
    self.referenceScrollView.contentSize = CGSizeMake(kLineViewWidth, 0);
}

- (void)setReferenceScrollView:(UIScrollView *)scrollView {
    _referenceScrollView = scrollView;
    [self private_addAllEventListener];
}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition{
    CGFloat xPositoinInMainView = originXPosition - self.referenceScrollView.contentOffset.x;
    NSInteger startIndex = (NSInteger)((xPositoinInMainView - self.startXPosition) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        CGFloat minX = kLinePositionModel.HighPoint.x - ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        CGFloat maxX = kLinePositionModel.HighPoint.x + ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        
        if(xPositoinInMainView > minX && xPositoinInMainView < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
            {
                [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            return kLinePositionModel.HighPoint.x;
        }
        
    }
    return 0.f;
}

- (CGFloat)getExactYPositionWithOriginYPosition:(CGFloat)originYPosition{
    CGFloat xPositoinInMainView = originYPosition - self.referenceScrollView.contentOffset.x;
    NSInteger startIndex = (NSInteger)((xPositoinInMainView - self.startXPosition) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        CGFloat minX = kLinePositionModel.HighPoint.x - ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        CGFloat maxX = kLinePositionModel.HighPoint.x + ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        
        if(xPositoinInMainView > minX && xPositoinInMainView < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
            {
                [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            return kLinePositionModel.ClosePoint.y;
        }
        
    }
    return 0.f;
}

- (Y_KLineModel*)getExactModelWithPosition:(CGFloat)originXPosition{
    CGFloat xPositoinInMainView = originXPosition - self.referenceScrollView.contentOffset.x;
    NSInteger startIndex = (NSInteger)((xPositoinInMainView - self.startXPosition) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        CGFloat minX = kLinePositionModel.HighPoint.x - ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        CGFloat maxX = kLinePositionModel.HighPoint.x + ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        
        if(xPositoinInMainView > minX && xPositoinInMainView < maxX)
        {
            return self.needDrawKLineModels[index];
            
        }
        
    }
    return nil;
    
}

#pragma mark - setter,getter方法
- (CGFloat)startXPosition{
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount + 1) * [Y_StockChartGlobalVariable kLineGap] + leftArrCount * [Y_StockChartGlobalVariable kLineWidth] ;//+ [Y_StockChartGlobalVariable kLineWidth]/2;
    //    CGFloat startXPosition = self.referenceScrollView.contentOffset.x + [Y_StockChartGlobalVariable kLineGap] +[Y_StockChartGlobalVariable kLineWidth]/2;
    return startXPosition;
}

- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffsetX = self.referenceScrollView.contentOffset.x < 0 ? 0 : self.referenceScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

- (void)setKLineModels:(NSArray *)kLineModels{
    _kLineModels = kLineModels;
    [self updateMainViewWidth];
}

#pragma mark 私有方法
//提取需要绘制的数组
- (NSArray *)private_extractNeedDrawModels{
    CGFloat lineGap = [Y_StockChartGlobalVariable kLineGap];
    CGFloat lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.referenceScrollView.frame.size.width;
//    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
//    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex ;
    
//    if(self.pinchStartIndex > 0) {
//        needDrawKLineStartIndex = self.pinchStartIndex;
//        _needDrawStartIndex = self.pinchStartIndex;
//        self.pinchStartIndex = -1;
//    } else {
//        needDrawKLineStartIndex = self.needDrawStartIndex;
//    }
//    [self.needDrawKLineModels removeAllObjects];
//
//    //赋值数组
//    if(needDrawKLineStartIndex < self.kLineModels.count)
//    {
//        if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
//        {
//            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
//        } else{
//            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
//        }
//    }
    
    NSInteger startIndex = self.needDrawStartIndex;
    NSInteger drawLineCount = (self.referenceScrollView.frame.size.width) / ([Y_StockChartGlobalVariable kLineGap] +  [Y_StockChartGlobalVariable kLineWidth]);
    //    NSInteger drawLineCount = (self.stockScrollView.frame.size.width - [YYStockVariable lineGap]) / ([YYStockVariable lineGap] +  [YYStockVariable lineWidth]);
    [self.needDrawKLineModels removeAllObjects];
    if(startIndex < self.kLineModels.count){
        NSInteger length = startIndex + drawLineCount < self.kLineModels.count ? drawLineCount + 1 : self.kLineModels.count - startIndex;
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(startIndex, length)]];
    }
    
    //响应代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineModels:)])
    {
        [self.delegate kLineMainViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
    }
    return self.needDrawKLineModels;
}

#pragma mark 将model转化为Position模型
- (NSArray *)private_convertToKLinePositionModelWithKLineModels {
    if(!self.needDrawKLineModels)
    {
        return nil;
    }
    
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    Y_KLineModel *firstModel = kLineModels.firstObject;
    __block CGFloat minAssert = firstModel.Low.floatValue;
    __block CGFloat maxAssert = firstModel.High.floatValue;
    CGFloat xOffset = self.referenceScrollView.contentOffset.x <0 ?0 :self.referenceScrollView.contentOffset.x;
    
    ////  解决分时线 平缓的问题
    if(self.MainViewType == Y_StockChartcenterViewTypeTimeLine){
         minAssert = firstModel.Close.floatValue;
         maxAssert = firstModel.Close.floatValue;
    }
    //    __block CGFloat minMA7 = CGFLOAT_MAX;
    //    __block CGFloat maxMA7 = CGFLOAT_MIN;
    //    __block CGFloat minMA30 = CGFLOAT_MAX;
    //    __block CGFloat maxMA30 = CGFLOAT_MIN;
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
         ////  解决分时线 平缓的问题
        if(self.MainViewType == Y_StockChartcenterViewTypeTimeLine){
            if(kLineModel.Close.floatValue > maxAssert)
            {
                maxAssert = kLineModel.Close.floatValue;
            }
            if(kLineModel.Close.floatValue < minAssert)
            {
                minAssert = kLineModel.Close.floatValue;
            }
        }else{
            if(kLineModel.High.floatValue > maxAssert)
            {
                maxAssert = kLineModel.High.floatValue;
            }
            if(kLineModel.Low.floatValue < minAssert)
            {
                minAssert = kLineModel.Low.floatValue;
            }
        }
        
        
        if (_targetLineStatus == Y_StockChartTargetLineStatusBOLL) {
            
            if(kLineModel.BOLL_MB)
            {
                if (minAssert > kLineModel.BOLL_MB.floatValue) {
                    minAssert = kLineModel.BOLL_MB.floatValue;
                }
                if (maxAssert < kLineModel.BOLL_MB.floatValue) {
                    maxAssert = kLineModel.BOLL_MB.floatValue;
                }
            }
            if(kLineModel.BOLL_UP)
            {
                if (minAssert > kLineModel.BOLL_UP.floatValue) {
                    minAssert = kLineModel.BOLL_UP.floatValue;
                }
                if (maxAssert < kLineModel.BOLL_UP.floatValue) {
                    maxAssert = kLineModel.BOLL_UP.floatValue;
                }
            }
            
            if(kLineModel.BOLL_DN)
            {
                if (minAssert > kLineModel.BOLL_DN.floatValue) {
                    minAssert = kLineModel.BOLL_DN.floatValue;
                }
                if (maxAssert < kLineModel.BOLL_DN.floatValue) {
                    maxAssert = kLineModel.BOLL_DN.floatValue;
                }
            }
            
            
            
        } else if (_targetLineStatus == Y_StockChartTargetLineStatusMA) {
            
            
            if(kLineModel.MA7)
            {
                if (minAssert > kLineModel.MA7.floatValue) {
                    minAssert = kLineModel.MA7.floatValue;
                }
                if (maxAssert < kLineModel.MA7.floatValue) {
                    maxAssert = kLineModel.MA7.floatValue;
                }
            }
            if(kLineModel.MA10)
            {
                if (minAssert > kLineModel.MA10.floatValue) {
                    minAssert = kLineModel.MA10.floatValue;
                }
                if (maxAssert < kLineModel.MA10.floatValue) {
                    maxAssert = kLineModel.MA10.floatValue;
                }
            }
            
            if(kLineModel.MA30)
            {
                if (minAssert > kLineModel.MA30.floatValue) {
                    minAssert = kLineModel.MA30.floatValue;
                }
                if (maxAssert < kLineModel.MA30.floatValue) {
                    maxAssert = kLineModel.MA30.floatValue;
                }
            }
            
            
        }else if (_targetLineStatus == Y_StockChartTargetLineStatusEMA) {
            if(kLineModel.EMA7)
            {
                if (minAssert > kLineModel.EMA7.floatValue) {
                    minAssert = kLineModel.EMA7.floatValue;
                }
                if (maxAssert < kLineModel.EMA7.floatValue) {
                    maxAssert = kLineModel.EMA7.floatValue;
                }
            }
            
            if(kLineModel.EMA10)
            {
                if (minAssert > kLineModel.EMA10.floatValue) {
                    minAssert = kLineModel.EMA10.floatValue;
                }
                if (maxAssert < kLineModel.EMA10.floatValue) {
                    maxAssert = kLineModel.EMA10.floatValue;
                }
            }
            if(kLineModel.EMA30)
            {
                if (minAssert > kLineModel.EMA30.floatValue) {
                    minAssert = kLineModel.EMA30.floatValue;
                }
                if (maxAssert < kLineModel.EMA30.floatValue) {
                    maxAssert = kLineModel.EMA30.floatValue;
                }
            }
        }
        
        
    }];
    
    
    maxAssert *= 1.0001;
    minAssert *= 0.9991;
    
    
    CGFloat minY = Y_StockChartKLineMainViewMinY;
    CGFloat maxY = self.referenceScrollView.frame.size.height * [Y_StockChartGlobalVariable kLineMainViewRadio] - 30;
    //
    
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    //    CGFloat ma7UnitValue = (maxMA7 - minMA7) / (maxY - minY);
    //    CGFloat ma30UnitValue = (maxMA30 - minMA30) / (maxY - minY);
    [self.needDrawKLinePositionModels removeAllObjects];
    [self.MA7Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA30Positions removeAllObjects];
    
    [self.BOLL_MBPositions removeAllObjects];
    [self.BOLL_UPPositions removeAllObjects];
    [self.BOLL_DNPositions removeAllObjects];
    
    
    [self.EMA7Positions removeAllObjects];
    [self.EMA10Positions removeAllObjects];
    [self.EMA30Positions removeAllObjects];
    
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0 ; idx < kLineModelsCount; ++idx)
    {
        //K线坐标转换
        Y_KLineModel *kLineModel = kLineModels[idx];
        
        CGFloat xPosition = self.startXPosition + idx * ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap]) - xOffset;
        
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Open.floatValue - minAssert)/unitValue));
        CGFloat closePointY = ABS(maxY - (kLineModel.Close.floatValue - minAssert)/unitValue);
        if(ABS(closePointY - openPoint.y) < Y_StockChartKLineMinWidth)
        {
            if(openPoint.y > closePointY)
            {
                openPoint.y = closePointY + Y_StockChartKLineMinWidth;
            } else if(openPoint.y < closePointY)
            {
                closePointY = openPoint.y + Y_StockChartKLineMinWidth;
            } else {
                if(idx > 0)
                {
                    Y_KLineModel *preKLineModel = kLineModels[idx-1];
                    if(kLineModel.Open.floatValue > preKLineModel.Close.floatValue)
                    {
                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
                    }
                } else if(idx+1 < kLineModelsCount){
                    
                    //idx==0即第一个时
                    Y_KLineModel *subKLineModel = kLineModels[idx+1];
                    if(kLineModel.Close.floatValue < subKLineModel.Open.floatValue)
                    {
                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.High.floatValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Low.floatValue - minAssert)/unitValue));
        
        Y_KLinePositionModel *kLinePositionModel = [Y_KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
        
        
        if(_targetLineStatus == Y_StockChartTargetLineStatusMA){
            //MA坐标转换
            CGFloat ma7Y = maxY;
            CGFloat ma10Y = maxY;
            CGFloat ma30Y = maxY;
            
            if(unitValue > 0.0000001)
            {
                if(kLineModel.MA7)
                {
                    ma7Y = maxY - (kLineModel.MA7.floatValue - minAssert)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(kLineModel.MA10)
                {
                    ma10Y = maxY - (kLineModel.MA10.floatValue - minAssert)/unitValue;
                }
                
            }
            
            
            if(unitValue > 0.0000001)
            {
                if(kLineModel.MA30)
                {
                    ma30Y = maxY - (kLineModel.MA30.floatValue - minAssert)/unitValue;
                }
            }
            
            NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
            
            CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
            CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
            CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
            
            if(kLineModel.MA7)
            {
                [self.MA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
            }
            if(kLineModel.MA10){
                 [self.MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
            }
            if(kLineModel.MA30)
            {
                [self.MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
            }
        }
        
        
        //EMA 线
        if(_targetLineStatus == Y_StockChartTargetLineStatusEMA){
            // EMA坐标转换
            CGFloat ma7Y = maxY;
            CGFloat ma10Y = maxY;
            CGFloat ma30Y = maxY;
            if(unitValue > 0.0000001)
            {
                if(kLineModel.EMA7)
                {
                    ma7Y = maxY - (kLineModel.EMA7.floatValue - minAssert)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(kLineModel.EMA10)
                {
                    ma10Y = maxY - (kLineModel.EMA10.floatValue - minAssert)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(kLineModel.EMA30)
                {
                    ma30Y = maxY - (kLineModel.EMA30.floatValue - minAssert)/unitValue;
                }
            }
            
            NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
            
            CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
            CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
            
            if(kLineModel.EMA7)
            {
                [self.EMA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
            }
            
            if(kLineModel.EMA10)
            {
                [self.EMA10Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
            }
            
            if(kLineModel.EMA30)
            {
                [self.EMA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
            }
        }
        
        
        // BOLL 线
        if(_targetLineStatus == Y_StockChartTargetLineStatusBOLL){
            
            
            //BOLL坐标转换
            CGFloat boll_mbY = maxY;
            CGFloat boll_upY = maxY;
            CGFloat boll_dnY = maxY;
            
            NSLog(@"position：\n上: %@ \n中: %@ \n下: %@",kLineModel.BOLL_UP,kLineModel.BOLL_MB,kLineModel.BOLL_DN);
            
            
            if(unitValue > 0.0000001)
            {
                
                if(kLineModel.BOLL_MB)
                {
                    boll_mbY = maxY - (kLineModel.BOLL_MB.floatValue - minAssert)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(kLineModel.BOLL_DN)
                {
                    boll_dnY = maxY - (kLineModel.BOLL_DN.floatValue - minAssert)/unitValue ;
                }
            }
            
            if(unitValue > 0.0000001)
            {
                if(kLineModel.BOLL_UP)
                {
                    boll_upY = maxY - (kLineModel.BOLL_UP.floatValue - minAssert)/unitValue;
                }
            }
            
            NSAssert(!isnan(boll_mbY) && !isnan(boll_upY) && !isnan(boll_dnY), @"出现BOLL值");
            
            CGPoint boll_mbPoint = CGPointMake(xPosition, boll_mbY);
            CGPoint boll_upPoint = CGPointMake(xPosition, boll_upY);
            CGPoint boll_dnPoint = CGPointMake(xPosition, boll_dnY);
            
            
            if (kLineModel.BOLL_MB) {
                [self.BOLL_MBPositions addObject:[NSValue valueWithCGPoint:boll_mbPoint]];
            }
            
            if (kLineModel.BOLL_UP) {
                [self.BOLL_UPPositions addObject:[NSValue valueWithCGPoint:boll_upPoint]];
            }
            if (kLineModel.BOLL_DN) {
                [self.BOLL_DNPositions addObject:[NSValue valueWithCGPoint:boll_dnPoint]];
            }
            
        }
        
    }
    
    
    //响应代理方法
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentMaxPrice:minPrice:)])
        {
            [self.delegate kLineMainViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLinePositionModels:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

static char *observerContext = NULL;
#pragma mark 添加所有事件监听的方法
- (void)private_addAllEventListener{
    //KVO监听scrollview的状态变化
    [_referenceScrollView addObserver:self forKeyPath:Y_StockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}

#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法,设置父scrollview

#pragma mark KVO监听实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:Y_StockChartContentOffsetKey])
    {
        CGFloat difValue = ABS(self.referenceScrollView.contentOffset.x - self.oldContentOffsetX);
        if(difValue >= [Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth])
        {
            self.oldContentOffsetX = self.referenceScrollView.contentOffset.x;
            [self drawMainView];
        }

    }
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 移除所有监听
- (void)removeAllObserver{
    [_referenceScrollView removeObserver:self forKeyPath:Y_StockChartContentOffsetKey context:observerContext];
}

- (CALayer *)breathingPoint
{
    if (!_breathingPoint) {
        _breathingPoint = [CAScrollLayer layer];
        _breathingPoint.backgroundColor = [UIColor whiteColor].CGColor;
        _breathingPoint.cornerRadius = 2;
        _breathingPoint.masksToBounds = YES;
        _breathingPoint.borderWidth = 1;
        _breathingPoint.borderColor = [UIColor colorWithHexString:@"2787B7"].CGColor;
        
        [_breathingPoint addAnimation:[self groupAnimationDurTimes:1.5f] forKey:@"breathingPoint"];
    }
    return _breathingPoint;
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

@end
