//
//  XianHuoModel.h
//  BT
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XianHuoModel : NSObject

@property (nullable, nonatomic, copy) NSString *exchangeCode;
@property (nullable, nonatomic, copy) NSString *exchangeName;
@property (nonatomic) int32_t exchangeId;
@property (nullable, nonatomic, copy) NSString *exchangeLabel;
@end
