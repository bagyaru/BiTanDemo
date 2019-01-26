//
//  CurrencyModel.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CurrencyModel.h"

@implementation CurrencyModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end
