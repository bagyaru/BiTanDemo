//
//  CurrentcyModel.h
//  BT
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentcyModel : NSObject<NSCoding>

@property (nullable, nonatomic, copy) NSString *currencyChineseName;
@property (nullable, nonatomic, copy) NSString *currencyChineseNameRelation;
@property (nullable, nonatomic, copy) NSString *currencyCode;
@property (nullable, nonatomic, copy) NSString *currencyCodeRelation;
@property (nullable, nonatomic, copy) NSString *currencyEnglishName;
@property (nullable, nonatomic, copy) NSString *currencyEnglishNameRelation;

@property (nullable, nonatomic, copy) NSString *currencySimpleName;
@property (nullable, nonatomic, copy) NSString *currencySimpleNameRelation;

@property (nonatomic, assign) NSInteger isExist;
@property (nonatomic, assign) double legalTendeCNY;
@property (nonatomic, assign) double legalTendeUSD;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double volume;

@property (nonatomic, assign) double turnoverCNY;
@property (nonatomic, assign) double turnoverUSD;
@property (nonatomic, copy) NSString * icon;

@end
