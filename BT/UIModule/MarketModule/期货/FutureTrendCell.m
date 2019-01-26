//
//  FutureTrendCell.m
//  BT
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureTrendCell.h"
#import "FutureTrendHistHeader.h"
#import "LewBarChart.h"

@interface FutureTrendCell()

@property (nonatomic, strong) LewBarChart *barChart;

@property (nonatomic, strong) FutureTrendHistHeader *headerView;

@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation FutureTrendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(80.0f);
        }];
    }
    return self;
}

- (FutureTrendHistHeader*)headerView{
    if(!_headerView){
        _headerView = [FutureTrendHistHeader loadFromXib];
    }
    return _headerView;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if(dataArr){
        NSMutableArray *countArr = @[].mutableCopy;
        NSMutableArray *dateArr = @[].mutableCopy;
        NSMutableArray *kongArr = @[].mutableCopy;
        //持仓总量
        for(NSDictionary *dict in dataArr){
            [countArr addObject:@([SAFESTRING(dict[@"futuresLong"]) doubleValue])];
            [kongArr addObject:@([SAFESTRING(dict[@"futuresShort"]) doubleValue])];
            NSString *date = [[SAFESTRING(dict[@"date"]) componentsSeparatedByString:@" "] lastObject];
            date = [date substringToIndex:5];
            [dateArr addObject:date];
        }
        [self createIncomeChartLineViewWithArr:countArr kongArr:kongArr xArr:dateArr];
    }
}

- (void)createIncomeChartLineViewWithArr:(NSArray*)data1 kongArr:(NSArray*)data2  xArr:(NSArray*)xArr{
    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[LewBarChart class]]){
            [view removeFromSuperview];
        }
    }
    if(data1.count == 0){
        [self.loadingView showNoDataWith:@"zanwushuju"];
        return;
    }
    _barChart = [[LewBarChart alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 225)];
    _barChart.originData = self.dataArr;
    LewBarChartDataSet *set1 = [[LewBarChartDataSet alloc] initWithYValues:data1 label:@"多头"];
    [set1 setBarColor:kHEXCOLOR(0x00AC1E)];
    LewBarChartDataSet *set2 = [[LewBarChartDataSet alloc] initWithYValues:data2 label:@"空头"];
    [set2 setBarColor:kHEXCOLOR(0xE33C27)];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    LewBarChartData *data = [[LewBarChartData alloc] initWithDataSets:dataSets];
    data.xLabels = xArr;
    data.itemSpace = 2;
    _barChart.data = data;
    _barChart.displayAnimated = YES;
    
    _barChart.chartMargin = UIEdgeInsetsMake(10, 44, 30, 15);
    _barChart.showYAxis = NO;
    _barChart.showNumber = YES;
    [self.contentView addSubview:_barChart];
    [_barChart show];
}


@end
