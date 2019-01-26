//
//  XianHuoDetailViewController.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

@interface XianHuoDetailViewController : RootViewController

@property (nonatomic, assign) NSInteger exchangeId;
@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, assign) BOOL isExchangeIntro;

@end
