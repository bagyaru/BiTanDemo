//
//  Y-StockChartView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartConstant.h"

//种类
typedef NS_ENUM(NSInteger, Y_KLineType) {
    KLineTypeTimeShare = 1,
    KLineType1Min,
    KLineType3MIn,
    KLineType5Min,
    KLineType10Min,
    KLineType15Min,
    KLineType30Min,
    KLineType1Hour,
    KLineType2Hour,
    KLineType4Hour,
    KLineType6Hour,
    KLineType12Hour,
    KLineType1Day,
    KLineType3Day,
    KLineType1Week
};

/**
 *  Y_StockChartView代理
 */

@protocol Y_StockChartViewDelegate <NSObject>


@end



/**
 *  Y_StockChartView数据源
 */
@protocol Y_StockChartViewDataSource <NSObject>

- (void) stockDatasWithIndex:(NSInteger)index;

@end


@interface Y_StockChartView : UIView

/**
 *  数据源
 */
@property (nonatomic, weak) id<Y_StockChartViewDataSource> dataSource;

/**
 *  当前选中的索引
 */
@property (nonatomic, assign,readonly) Y_KLineType currentLineTypeIndex;

@property (nonatomic, assign) BOOL isUpdateTimeLine;

@property (nonatomic, assign) double ratio;
@property (nonatomic, assign) BOOL isFullScreen;


-(void) reloadData;

- (void)reloadFrame;

- (void)refreshKlineType:(Y_StockChartCenterViewType)type data:(NSArray*)data;

//指标曲线
- (void)refreshWithTargetLineStatus:(Y_StockChartTargetLineStatus)status;

//副指标
- (void)refreshWithAccesoryLineStatus:(Y_StockChartTargetLineStatus)status;

- (void)refreshTimeLine;

@end

/************************ItemModel类************************/
@interface Y_StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) Y_StockChartCenterViewType centerViewType;

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type;

@end
