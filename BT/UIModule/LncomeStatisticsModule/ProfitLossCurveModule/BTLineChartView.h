//
//  BTLineChartView.h
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTLineChartView : UIView
@property (nonatomic, strong) NSArray * lineChartYLabelArray;
@property (nonatomic, strong) NSArray * lineChartXLabelArray; // X轴数据
@property (nonatomic, strong) NSArray * LineChartDataArray; // 数据源
@property (nonatomic, copy) NSArray *scaleNums;
@end
