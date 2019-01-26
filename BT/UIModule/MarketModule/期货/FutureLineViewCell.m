//
//  LineViewTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureLineViewCell.h"
#import "FutureLineChartView.h"

#import "FutureHolderHeader.h"
#import "NSDate+Extent.h"
@interface FutureLineViewCell()

@property (nonatomic, strong) FutureLineChartView *incomeChartLineView;

@property (nonatomic, strong) FutureHolderHeader *headerView;

@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation FutureLineViewCell

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

- (FutureHolderHeader*)headerView{
    if(!_headerView){
        _headerView = [FutureHolderHeader loadFromXib];
        //点击按钮
        WS(ws)
        _headerView.completion = ^(NSInteger type) {
            if([ws.delegate respondsToSelector:@selector(refreshDataWithType:)]){
                [ws.delegate refreshDataWithType:type];
            }
        };
    }
    return _headerView;
}

- (void)setTitle:(NSString *)title{
    self.headerView.titleL.fixText = title;
}

- (void)setIsHoldCount:(BOOL)isHoldCount{
    _isHoldCount = isHoldCount;
    if(isHoldCount){
        self.headerView.fiveBtn.fixTitle = @"1h";
        self.headerView.fiftyBtn.fixTitle = @"4h";
        self.headerView.hourBtn.fixTitle = @"12h";
    }
}

- (void)setInfo:(NSArray *)info{
    _info = info;
    if(info){
        NSMutableArray *countArr = @[].mutableCopy;
        NSMutableArray *dateArr = @[].mutableCopy;
        //持仓总量
        if(self.isHoldCount){
            for(NSDictionary *dict in info){
                [countArr addObject:@([SAFESTRING(dict[@"data"]) doubleValue])];
                NSString *date = [[SAFESTRING(dict[@"date"]) componentsSeparatedByString:@" "] lastObject];
                date = [date substringToIndex:5];
                [dateArr addObject:date];
            }
            
        }else{//趋势图
            for(NSDictionary *dict in info){
                [countArr addObject:@([SAFESTRING(dict[@"futuresLong"]) doubleValue])];
                NSString *date = [[SAFESTRING(dict[@"date"]) componentsSeparatedByString:@" "] lastObject];
                date = [date substringToIndex:5];
                [dateArr addObject:date];
            }
        }
        [self createIncomeChartLineViewWithArr:countArr xArr:dateArr];
    }
}

- (void)createIncomeChartLineViewWithArr:(NSArray*)data xArr:(NSArray*)xArr{
    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[FutureLineChartView class]]){
            [view removeFromSuperview];
        }
    }
    if(data.count == 0){
        [self.loadingView showNoDataWith:@"zanwushuju"];
        return;
    }
    NSArray *tempDataArrRightOfY = @[data];
    _incomeChartLineView = [[FutureLineChartView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 305 - 80)];
    _incomeChartLineView.isHoldCount = self.isHoldCount;
    _incomeChartLineView.originDataArr = self.info;
    _incomeChartLineView.singleTitle = [APPLanguageService wyhSearchContentWith:@"shuliang"];
    //是否可以浮动
    _incomeChartLineView.chartMargin = UIEdgeInsetsMake(30, 15, 30, 15);
    _incomeChartLineView.isFloating = YES;
    //设置X轴坐标字体大小
    _incomeChartLineView.x_Font = [UIFont systemFontOfSize:10];
    //设置X轴坐标字体颜色
    _incomeChartLineView.x_Color = FirstColor;
    //设置Y轴坐标字体大小
    _incomeChartLineView.y_Font = [UIFont systemFontOfSize:10];
    //设置Y轴坐标字体颜色
    _incomeChartLineView.y_Color = FirstColor;
    //设置X轴数据间隔
    _incomeChartLineView.Xmargin = 50;
    //设置背景颜色
    _incomeChartLineView.backgroundColor = [UIColor clearColor];
    //是否根据折线数据浮动泡泡
    //_incomeChartLineView.isFloating = YES;
    //折线图数据
    //    _incomeChartLineView.leftDataArr = tempDataArrOfY;
    _incomeChartLineView.rightDataArr = tempDataArrRightOfY;
    
    //折线图所有颜色
    _incomeChartLineView.leftColorStrArr = @[@"#4d87ea"];
    _incomeChartLineView.rightColorStrArr = @[@"#4d87ea"];
    //设置折线样式
    _incomeChartLineView.chartViewStyle = LRSChartViewLeftRightLine;
    //设置图层效果
    _incomeChartLineView.chartLayerStyle = LRSChartGradient;
    //设置折现效果
    _incomeChartLineView.lineLayerStyle = LRSLineLayerNone;
    //底部日期
    _incomeChartLineView.dataArrOfX = xArr;
    //开始画图
    [_incomeChartLineView show];
    [self.contentView addSubview:_incomeChartLineView];
}

@end
