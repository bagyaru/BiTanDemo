//
//  AppHelper.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTButton.h"

typedef NS_ENUM(NSInteger,RefreshState) {
    RefreshStateNormal = 1,
    RefreshStatePull = 2,
    RefreshStateUp = 3,
};

@interface AppHelper : NSObject

+ (void)requestCurrency;

+ (BTButton *)yellowTitleBtn;


+ (UIView *)addLineTopWithParentView:(UIView *)iv;

+ (UIView *)addLineWithParentView:(UIView *)iv;

+ (UIView *)addSeparateLineWithParentView:(UIView *)iv;

+ (UIView*)addBottomLineWithParentView:(UIView*)iv;


+ (UIView*)addLeftLineWithParentView:(UIView*)iv;


+ (void)setView:(UIView *)iv borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

/////
+ (void)saveExchangeCode:(NSString*)exchangeCode;
+ (NSString*)getExchangeCode;

+ (void)saveExchangeName:(NSString*)name;
+ (NSString*)getExchangeName;

+ (void)saveApiKey:(NSString*)apiKey withExchangeCode:(NSString*)exchangeCode;

+ (NSString*)apikeyWithExchangeCode:(NSString*)exchangeCode;

+ (void)saveApiSecret:(NSString*)ApiSecret withExchangeCode:(NSString*)exchangeCode;

+ (NSString*)apiSecretWithExchangeCode:(NSString*)exchangeCode;

+ (void)saveApiAccountId:(NSString*)accountId;

+ (NSString*)getAccountId;

+ (void)saveHbApiAccountId:(NSString*)accountId;

+ (NSString*)getHbApiAccountId;


//存储交易所数据
+ (void)saveExchangeData:(NSArray*)data withExchangeCode:(NSString*)exchangeCode;

+ (NSArray*)getExchangeData:(NSString*)exchangeCode;

//存储交易所总数据
+ (void)saveExchangeTotalInfo:(NSDictionary*)info withEXCode:(NSString*)exchnageCode;

+ (NSDictionary*)getExchangeTotolInfo:(NSString*)exchangeCode;

+ (NSArray*)concatFirstArr:(NSArray*)firstArr secondArray:(NSArray*)secondArr;

+ (void)startRefreshTasks;

+ (void)clearTanliTime;


+ (void)saveMainIndex:(NSString*)mainIndex;

+ (NSString*)mainIndex;

+ (void)saveAccessoryIndex:(NSString*)accessoryIndex;

+ (NSString*)accessoryIndex;




@end
