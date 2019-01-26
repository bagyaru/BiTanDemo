//
//  BTExchangeListModel.h
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTExchangeListModel : BTBaseObject

@property (nonatomic, copy) NSString *exchangeCode;
@property (nonatomic, copy) NSString * exchangeName;
@property (nonatomic, copy) NSString * exchangeNameEN;
@property (nonatomic, assign) NSInteger exchangeId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) double turnoverCNY;
@property (nonatomic, assign) double turnoverUSD;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, strong) NSArray *baseSymbolList;

@end
