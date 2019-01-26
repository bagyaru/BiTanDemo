//
//  CountryCodeViewController.h
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"
typedef void(^CountryCodeBlock)(NSString* code);
@interface CountryCodeViewController : RootViewController

@property (nonatomic,strong) CountryCodeBlock codeBlock;

@end
