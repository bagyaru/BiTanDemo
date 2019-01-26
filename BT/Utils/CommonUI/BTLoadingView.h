//
//  BTLoadingView.h
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTView.h"
@protocol BTLoadingViewDelegate<NSObject>

- (void)refreshingData;

@optional//此关键字下声明的方法，是可选实现的方法。

- (void)addLncomeStatistics;

- (void)searchOptional;

@end

@interface BTLoadingView : BTView

@property (nonatomic, weak) id<BTLoadingViewDelegate>delegate;

- (instancetype)initWithParentView:(UIView *)parentView aboveSubView:(UIView *)aboveView delegate:(id<BTLoadingViewDelegate>)delegate;

- (void)showLoading;

- (void)showErrorWith:(NSString *)msg;
//无数据
-(void)showNoDataWith:(NSString *)msg;
//币详情-头部
-(void)showHeadErrorWith:(NSString *)msg;

- (void)showBusinessErrorWith:(NSString*)msg;

//收益统计 添加View
-(void)showLncomeStatisticsView;

//
- (void)showAddOptioal;

//自定义图片
-(void)showNoDataWithMessage:(NSString *)msg imageString:(NSString *)img;

- (void)hiddenLoading;

@end
