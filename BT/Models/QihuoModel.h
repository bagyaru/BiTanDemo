//
//  QihuoModel.h
//  BT
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QihuoModel : NSObject

@property (nullable, nonatomic, copy) NSString *contractCode;
@property (nullable, nonatomic, copy) NSString *contractName;
@property (nonatomic) int32_t futuresId;
@property (nullable, nonatomic, copy) NSString *productCode;
@end
