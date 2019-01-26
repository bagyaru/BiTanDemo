//
//  BTExchangeManager.h
//  BT
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTExchangeManager : NSObject

@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, strong) NSString *exchangeName;

SINGLETON_FOR_HEADER(BTExchangeManager)

@end
