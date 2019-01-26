//
//  ItemModel.h
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject<NSCoding>

@property (nullable, nonatomic, copy) NSString *currencyChineseName;
@property (nullable, nonatomic, copy) NSString *currencyChineseNameRelation;
@property (nullable, nonatomic, copy) NSString *currencyCode;
@property (nullable, nonatomic, copy) NSString *currencyCodeRelation;
@property (nullable, nonatomic, copy) NSString *currencyEnglishName;
@property (nullable, nonatomic, copy) NSString *currencyEnglishNameRelation;

@property (nonatomic, strong) NSString * _Nonnull currencySimpleName;

@property (nonatomic, strong) NSString * _Nullable currencySimpleNameRelation;

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString * exchangeCode;
@property (nonatomic, copy) NSString * exchangeName;
@property (nonatomic, assign) NSInteger userGroupId;
@property (nonatomic, copy) NSString *  icon;

@property (nonatomic, assign) BOOL isSelected;



@end
