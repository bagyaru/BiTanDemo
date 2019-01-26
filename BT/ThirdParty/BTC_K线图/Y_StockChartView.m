//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"
#import "Y_KLineView.h"
#import "Masonry.h"
#import "Y_StockChartSegmentView.h"
#import "Y_StockChartGlobalVariable.h"

@interface Y_StockChartView() <Y_StockChartSegmentViewDelegate>

/**
 *  K线图View
 */
@property (nonatomic, strong) Y_KLineView *kLineView;

/**
 *  底部选择View
 */
@property (nonatomic, strong) Y_StockChartSegmentView *segmentView;

/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end


@implementation Y_StockChartView

-(void) reloadData{
    _kLineView.frame = self.bounds;
    [_kLineView layoutIfNeeded];
    [_kLineView reDraw];
}

//设置frame
- (void)reloadFrame{
    _kLineView.frame = self.bounds;
    [_kLineView layoutIfNeeded];
}

- (Y_KLineView *)kLineView{
    if(!_kLineView){
        _kLineView = [Y_KLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self);
            make.left.equalTo(self);
        }];
    }
    return _kLineView;
}

- (void)refreshWithAccesoryLineStatus:(Y_StockChartTargetLineStatus)status{
    self.kLineView.accessoryLineStatus = status;
    if(self.kLineView.kLineModels.count == 0) return;
    [self.kLineView reDraw];
}

- (void)refreshWithTargetLineStatus:(Y_StockChartTargetLineStatus)status{
    self.kLineView.targetLineStatus = status;
    if(self.kLineView.kLineModels.count == 0) return;
    [self.kLineView reDraw];
}

- (void)refreshKlineType:(Y_StockChartCenterViewType)type data:(NSArray *)data{
    self.kLineView.isUpdateTimeLine = self.isUpdateTimeLine;
    self.kLineView.MainViewType = type;
    self.kLineView.contentOffset = self.kLineView.scrollView.contentOffset;
    self.kLineView.contentRightWidth = self.kLineView.scrollView.contentSize.width - self.kLineView.scrollView.frame.size.width;
    self.kLineView.kLineModels = data;
    
    //初始化 默认为MA
    self.kLineView.targetLineStatus = [[AppHelper mainIndex] integerValue];
    self.kLineView.accessoryLineStatus = [[AppHelper accessoryIndex] integerValue]; //Y_StockChartTargetLineStatusMACD;
    
    [self.kLineView reDraw];
}

- (void)refreshTimeLine{
    CGFloat offset = self.kLineView.contentOffset.x;
    CGFloat margin = self.kLineView.scrollView.contentSize.width - self.kLineView.scrollView.frame.size.width;
    if(offset >= self.kLineView.contentRightWidth){
        self.kLineView.scrollView.contentOffset = CGPointMake(margin, 0);
    }else{
        self.kLineView.scrollView.contentOffset = self.kLineView.contentOffset;
    }
}

#pragma mark - 代理方法
- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index{
    self.currentIndex = index;
    [self.dataSource stockDatasWithIndex:index];
}

- (void)setRatio:(double)ratio{
    self.kLineView.ratio = ratio;
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    self.kLineView.isFullScreen = isFullScreen;
}

@end


/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type
{
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
