//
//  Y_KLineAccessoryView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineAccessoryView.h"
#import "Y_KLineModel.h"

#import "UIColor+Y_StockChart.h"
#import "Y_KLineAccessory.h"
#import "Y_KLineVolumePositionModel.h"
#import "Y_KLinePositionModel.h"
#import "Y_MALine.h"

@interface Y_KLineAccessoryView() {
    UIScrollView *_scrollView;
}

/**
 *  需要绘制的Volume_MACD位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineAccessoryPositionModels;

/**
 *  Volume_DIF位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DIFPositions;

/**
 *  Volume_DEA位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DEAPositions;

/**
 *  KDJ_K位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_KPositions;

/**
 *  KDJ_D位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_DPositions;

/**
 *  KDJ_J位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_JPositions;

//RSI 6 数组
@property (nonatomic, strong) NSMutableArray *Accessory_RSI6_Positions;
//RSI 12 数组
@property (nonatomic, strong) NSMutableArray *Accessory_RSI12_Positions;

//RSI 24 数组
@property (nonatomic, strong) NSMutableArray *Accessory_RSI24_Positions;

@property (nonatomic, strong) NSMutableArray *NetFlow_Positions;

@property (nonatomic, assign) CGPoint zeroPoint;


@end

@implementation Y_KLineAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        self.Accessory_DIFPositions = @[].mutableCopy;
        self.Accessory_DEAPositions = @[].mutableCopy;
        self.Accessory_KDJ_KPositions = @[].mutableCopy;
        self.Accessory_KDJ_DPositions = @[].mutableCopy;
        self.Accessory_KDJ_JPositions = @[].mutableCopy;
        
        self.Accessory_RSI6_Positions = @[].mutableCopy;
        self.Accessory_RSI12_Positions = @[].mutableCopy;
        self.Accessory_RSI24_Positions = @[].mutableCopy;
        
        self.NetFlow_Positions = @[].mutableCopy;
        
        

    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //MACD needDrawKLineAccessoryPositionModels
    if(self.targetLineStatus == Y_StockChartTargetLineStatusMACD){
        
        if(!self.needDrawKLineAccessoryPositionModels)
        {
            return;
        }
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /**
     *  副图，需要区分是MACD线还是KDJ线，进而选择不同的数据源和绘制方法
     */
    if(self.targetLineStatus == Y_StockChartTargetLineStatusMACD)
    {
        /**
         MACD
         */
        Y_KLineAccessory *kLineAccessory = [[Y_KLineAccessory alloc]initWithContext:context];
        [self.needDrawKLineAccessoryPositionModels enumerateObjectsUsingBlock:^(Y_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLineAccessory.positionModel = volumePositionModel;
            kLineAccessory.kLineModel = self.needDrawKLineModels[idx];
            kLineAccessory.lineColor = self.kLineColors[idx];
            [kLineAccessory draw];
        }];
        
        Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
        
        //画DIF线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.Accessory_DIFPositions;
        [MALine draw];
        
        //画DEA线
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.Accessory_DEAPositions;
        [MALine draw];
    } else if(self.targetLineStatus == Y_StockChartTargetLineStatusKDJ){
        /**
        KDJ
         */
        Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
        
        //画KDJ_K线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.Accessory_KDJ_KPositions;
        [MALine draw];
        
        //画KDJ_D线
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.Accessory_KDJ_DPositions;
        [MALine draw];
        
        //画KDJ_J线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.Accessory_KDJ_JPositions;
        [MALine draw];
    } else if(self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        /**
         RSI
         */
        Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
        
        //画RSI6线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.Accessory_RSI6_Positions;
        [MALine draw];
        
        //画RSI12线
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.Accessory_RSI12_Positions;
        [MALine draw];
        
        //画RSI24线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.Accessory_RSI24_Positions;
        [MALine draw];
    }else if(self.targetLineStatus == Y_StockChartTargetLineStatusNetCapital){
       
        Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.NetFlow_Positions;
        [MALine draw];
        [self drawHLineRect:self.frame inContext:context];
    }
    
}

- (void)drawHLineRect:(CGRect)rect inContext:(CGContextRef)context{
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 0.5);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor lineColor].CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 0, self.zeroPoint.y);
    CGFloat lengths[] = {3,3};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, self.frame.size.width,self.zeroPoint.y);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}

#pragma mark - 公有方法
#pragma mark 绘制volume方法
- (void)draw
{
    NSInteger kLineModelcount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;
    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelcount && kLinePositionModelCount == kLineModelcount, @"数据异常，无法绘制Volume");
    self.needDrawKLineAccessoryPositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

- (void)setReferenceScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = Y_StockChartKLineAccessoryViewMinY +3;
    CGFloat maxY = Y_StockChartKLineAccessoryViewMaxY - 5;
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;

    if(self.targetLineStatus == Y_StockChartTargetLineStatusMACD)
    {
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.DIF)
            {
                if(model.DIF.floatValue < minValue) {
                    minValue = model.DIF.floatValue;
                }
                if(model.DIF.floatValue > maxValue) {
                    maxValue = model.DIF.floatValue;
                }
            }
            
            if(model.DEA)
            {
                if (minValue > model.DEA.floatValue) {
                    minValue = model.DEA.floatValue;
                }
                if (maxValue < model.DEA.floatValue) {
                    maxValue = model.DEA.floatValue;
                }
            }
            if(model.MACD)
            {
                if (minValue > model.MACD.floatValue) {
                    minValue = model.MACD.floatValue;
                }
                if (maxValue < model.MACD.floatValue) {
                    maxValue = model.MACD.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_DIFPositions removeAllObjects];
        [self.Accessory_DEAPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            
            
            CGFloat yPosition = -(model.MACD.floatValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
            
//            CGFloat yPosition = ABS(minY + (model.MACD.floatValue - minValue)/unitValue);
            
            CGPoint startPoint = CGPointMake(xPosition, yPosition);
            
            CGPoint endPoint = CGPointMake(xPosition,Y_StockChartKLineAccessoryViewMiddleY);
            Y_KLineVolumePositionModel *volumePositionModel = [Y_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
            [volumePositionModels addObject:volumePositionModel];
            
            //MA坐标转换
            CGFloat DIFY = maxY;
            CGFloat DEAY = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.DIF)
                {
                    DIFY = -(model.DIF.floatValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
//                    DIFY = maxY - (model.DIF.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.DEA)
                {
                    DEAY = -(model.DEA.floatValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
//                    DEAY = maxY - (model.DEA.floatValue - minValue)/unitValue;

                }
            }
            
            NSAssert(!isnan(DIFY) && !isnan(DEAY), @"出现NAN值");
            
            CGPoint DIFPoint = CGPointMake(xPosition, DIFY);
            CGPoint DEAPoint = CGPointMake(xPosition, DEAY);
            
            if(model.DIF)
            {
                [self.Accessory_DIFPositions addObject: [NSValue valueWithCGPoint: DIFPoint]];
            }
            if(model.DEA)
            {
                [self.Accessory_DEAPositions addObject: [NSValue valueWithCGPoint: DEAPoint]];
            }
        }];
    } else  if(self.targetLineStatus == Y_StockChartTargetLineStatusKDJ){
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.KDJ_K)
            {
                if (minValue > model.KDJ_K.floatValue) {
                    minValue = model.KDJ_K.floatValue;
                }
                if (maxValue < model.KDJ_K.floatValue) {
                    maxValue = model.KDJ_K.floatValue;
                }
            }
            
            if(model.KDJ_D)
            {
                if (minValue > model.KDJ_D.floatValue) {
                    minValue = model.KDJ_D.floatValue;
                }
                if (maxValue < model.KDJ_D.floatValue) {
                    maxValue = model.KDJ_D.floatValue;
                }
            }
            if(model.KDJ_J)
            {
                if (minValue > model.KDJ_J.floatValue) {
                    minValue = model.KDJ_J.floatValue;
                }
                if (maxValue < model.KDJ_J.floatValue) {
                    maxValue = model.KDJ_J.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_KDJ_KPositions removeAllObjects];
        [self.Accessory_KDJ_DPositions removeAllObjects];
        [self.Accessory_KDJ_JPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat KDJ_K_Y = maxY;
            CGFloat KDJ_D_Y = maxY;
            CGFloat KDJ_J_Y = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_K)
                {
                    KDJ_K_Y = maxY - (model.KDJ_K.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_D)
                {
                    KDJ_D_Y = maxY - (model.KDJ_D.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_J)
                {
                    KDJ_J_Y = maxY - (model.KDJ_J.floatValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
            
            CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
            CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
            CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);

            
            if(model.KDJ_K)
            {
                [self.Accessory_KDJ_KPositions addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
            }
            if(model.KDJ_D)
            {
                [self.Accessory_KDJ_DPositions addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
            }
            if(model.KDJ_J)
            {
                [self.Accessory_KDJ_JPositions addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
            }
        }];
    }if(self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        
        // RSI
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.RSI_6)
            {
                if (minValue > model.RSI_6.floatValue) {
                    minValue = model.RSI_6.floatValue;
                }
                if (maxValue < model.RSI_6.floatValue) {
                    maxValue = model.RSI_6.floatValue;
                }
            }
            
            if(model.RSI_12)
            {
                if (minValue > model.RSI_12.floatValue) {
                    minValue = model.RSI_12.floatValue;
                }
                if (maxValue < model.RSI_12.floatValue) {
                    maxValue = model.RSI_12.floatValue;
                }
            }
            if(model.RSI_24)
            {
                if (minValue > model.RSI_24.floatValue) {
                    minValue = model.RSI_24.floatValue;
                }
                if (maxValue < model.RSI_24.floatValue) {
                    maxValue = model.RSI_24.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_RSI6_Positions removeAllObjects];
        [self.Accessory_RSI12_Positions removeAllObjects];
        [self.Accessory_RSI24_Positions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat KDJ_K_Y = maxY;
            CGFloat KDJ_D_Y = maxY;
            CGFloat KDJ_J_Y = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.RSI_6)
                {
                    KDJ_K_Y = maxY - (model.RSI_6.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.RSI_12)
                {
                    KDJ_D_Y = maxY - (model.RSI_12.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                //处理一下线条
                if(model.RSI_24.doubleValue >0){
                    KDJ_J_Y = maxY - (model.RSI_24.floatValue - minValue)/unitValue;
                }else{
                    KDJ_J_Y = maxY - (model.RSI_24.floatValue - minValue)/unitValue - 1;
                }
                
            }
            
            NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
            
            CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
            CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
            CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);
            
            
            //处理线条重叠的情况
            if(model.RSI_6)
            {
                [self.Accessory_RSI6_Positions addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
            }
            if(model.RSI_12)
            {
                [self.Accessory_RSI12_Positions addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
            }
            if(model.RSI_24)
            {
                [self.Accessory_RSI24_Positions addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
            }
        }];
    }else  if(self.targetLineStatus == Y_StockChartTargetLineStatusNetCapital){
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.netInflow){
                if (minValue > model.netInflow.floatValue) {
                    minValue = model.netInflow.floatValue;
                }
                if (maxValue < model.netInflow.floatValue) {
                    maxValue = model.netInflow.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        self.zeroPoint = CGPointMake(0, maxY - (0 - minValue)/unitValue);
        
        [self.NetFlow_Positions removeAllObjects];
       
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat net_y = maxY;
            
            if(unitValue > 0.0000001){
                if(model.netInflow)
                {
                    net_y = maxY - (model.netInflow.floatValue - minValue)/unitValue;
                }
                
            }
            CGPoint net_flowPoint = CGPointMake(xPosition, net_y);
            if(model.netInflow){
                [self.NetFlow_Positions addObject: [NSValue valueWithCGPoint: net_flowPoint]];
            }
        }];
           
    }
         
    
    //
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineAccessoryViewCurrentMaxValue:minValue:)])
    {
        [self.delegate kLineAccessoryViewCurrentMaxValue:maxValue minValue:minValue];
    }
    return volumePositionModels;
}
@end
