//
//  DetailHelper.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntroduceModel.h"
#import "FenshiModel.h"

@interface DetailHelper : NSObject

+ (NSArray*)baseInfoWithModel:(IntroduceModel*)model;
+ (NSArray*)privateInfoWithModel:(IntroduceModel*)model;
+ (NSArray*)teamInfoWithModel:(IntroduceModel*)model;
+ (NSArray*)githubInfoWithModel:(IntroduceModel*)model;


+ (NSArray*)introduceArrWithModel:(IntroduceModel*)model;

+ (NSArray*)fenshiSelectArr;

+ (NSArray *)BTBitaneIndexFenshiSelectArr;

+ (NSArray*)mainIndexArr;

+ (NSString*)processData:(NSString*)originStr;

+ (NSArray*)updateFromItem:(FenshiModel *)item arr:(NSArray*)klineArr;

+ (NSArray*)updateItem:(FenshiModel *)item arr:(NSArray*)klineArr;

@end
