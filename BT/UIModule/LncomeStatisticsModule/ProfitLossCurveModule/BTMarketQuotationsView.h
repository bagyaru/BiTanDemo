//
//  BTMarketQuotationsView.h
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@protocol BTMarketQuotationsViewDelegate<NSObject>

- (void)requestKLineData:(NSInteger)type;
- (void)refreshRequest;

@end

@interface BTMarketQuotationsView : UIView

@property (nonatomic, assign) NSInteger klineType;//
@property (nonatomic, strong) NSMutableArray *fenshiArr;
@property (nonatomic, strong) CurrencyModel *cryModel;

@property (nonatomic, weak) id<BTMarketQuotationsViewDelegate>delegate;

- (void)configFrame;
- (void)configKLineView:(id)data;
- (void)endRefreshing;


@end
