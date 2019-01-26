//
//  KLineModel.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineModel : NSObject

@property (nonatomic, assign) double closePrice;

@property (nonatomic, assign) long long currentTime;

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, assign) double maxPrice;

@property (nonatomic, assign) double minPrice;

@property (nonatomic, assign) double openPrice;

@property (nonatomic, assign) double volume;


@end
