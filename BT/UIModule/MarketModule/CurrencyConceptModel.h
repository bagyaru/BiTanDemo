//
//  CurrencyConceptModel.h
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface CurrencyConceptModel : BTBaseObject

@property (nonatomic, assign) double averageRose;
@property (nonatomic, copy) NSString *conceptClassifyName;
@property (nonatomic, assign) NSInteger conceptId;
@property (nonatomic, assign) NSInteger hot;
@property (nonatomic, assign) NSInteger kindCount;
@property (nonatomic, copy) NSString *maxKind;
@property (nonatomic, copy) NSString * minKind;
@property (nonatomic, assign) double maxRose;
@property (nonatomic, assign) double minRose;
@property (nonatomic, assign) NSInteger sort;


@end
