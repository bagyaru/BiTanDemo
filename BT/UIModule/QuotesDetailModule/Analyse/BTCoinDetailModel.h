//
//  BTCoinDetailModel.h
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTCoinDetailModel : BTBaseObject

@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * analyzeDate;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign)double quantity;
@property (nonatomic, assign) double rate;
@property (nonatomic, copy) NSString * tradeRecord;
@property (nonatomic, copy) NSString * currencyCode;
@property (nonatomic, strong) NSArray *addressDetailVoList;

@end
