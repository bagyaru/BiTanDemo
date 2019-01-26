//
//  CurrencyViewController.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

@interface CurrencyViewController : RootViewController

@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, copy) NSString *  exchangeCode;
@property (nonatomic, copy) NSString * exchangeName;



- (void)startTimer;

- (void)stopTimer;

@end
