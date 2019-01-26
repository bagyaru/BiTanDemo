//
//  LewBarChartData.m
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "LewBarChartData.h"
#import "LewCommon.h"

#define GroupSpace 38.0f

@implementation LewBarChartData

- (instancetype)initWithDataSets:(NSArray<LewBarChartDataSet *> *)dataSets{
    self = [super init];
    if (!self) return nil;
    _dataSets = dataSets;
    _groupSpace = GroupSpace;
    _xLabelFontSize = 10;
    _yLabelFontSize = 10;
    _xLabelTextColor = FirstColor;
    _itemSpace = 2;
    _yMaxNum = 0;
    
    LewBarChartDataSet *firstData = [dataSets firstObject];
    NSNumber *firYValue = [firstData.yValues firstObject];
    _yMinNum = firYValue.doubleValue;
    for (LewBarChartDataSet *dataset in dataSets) {
        for (NSNumber *yValue in dataset.yValues) {
            if (yValue.doubleValue > _yMaxNum) {
                _yMaxNum = yValue.doubleValue;
            }
            if (yValue.doubleValue <_yMinNum) {
                _yMinNum = yValue.doubleValue;
            }
        }
    }
    return self;
}

- (BOOL)isGrouped{
    return _dataSets.count>1;
}
@end


@implementation LewBarChartDataSet

- (instancetype)initWithYValues:(NSArray<NSNumber *> *)yValues label:(NSString *)label{
    self = [super init];
    if (!self) return nil;

    _yValues = yValues;
    _label = label;
    _barColor = LewGreen;
    _BarbackGroudColor = nil;
    
    return self;
}

@end
