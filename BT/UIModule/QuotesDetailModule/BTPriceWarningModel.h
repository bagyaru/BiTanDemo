//
//  BTPriceWarningModel.h
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTPriceWarningModel : BTBaseObject

@property (nonatomic, assign) double dropPrice;
@property (nonatomic, assign) BOOL dropPriceStatus;

@property (nonatomic, assign) double dropRose;
@property (nonatomic, assign) BOOL dropRoseStatus;
@property (nonatomic, copy) NSString * exchangeCode;
@property (nonatomic, copy) NSString * kind;
@property (nonatomic, assign) NSInteger legalType;
@property (nonatomic, assign) NSInteger priceWarningId;
@property (nonatomic, assign) double risePrice;
@property (nonatomic, assign) BOOL risePriceStatus;
@property (nonatomic, assign) double riseRose;
@property (nonatomic, assign) BOOL riseRoseStatus;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * unit;
@property (nonatomic, assign)BOOL isSwitch;
@property (nonatomic, copy) NSString * value;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *placeHolder;

@end
