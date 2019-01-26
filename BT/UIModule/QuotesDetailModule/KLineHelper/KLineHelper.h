//
//  KLineHelper.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FenshiModel.h"

#define TOTALPOINTS 40.0

@interface KLineHelper : NSObject

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, assign) BOOL isShizhi;

@property (nonatomic, strong) NSMutableArray *trendItems;

@property (nonatomic, assign) double maxVolum;

+ (instancetype)shareInstance;

- (void)setOriginItems: (NSMutableArray *)items;

- (void)updateFromItems: (NSArray *)items;

- (void)updateFromItem: (FenshiModel *)item;

- (NSArray *)fenshiTradeDrawPoint;

-(NSData *)uncompressZippedData:(NSData *)compressedData;

- (float)randomNum;


- (NSArray*)getDataWithModelArr:(NSArray*)fenshiArr;

- (NSArray*)getDataWithKlineNotSubData:(NSArray*)klineArr;

- (NSArray*)getDataWithKlineData:(NSArray*)klineArr;


@end
