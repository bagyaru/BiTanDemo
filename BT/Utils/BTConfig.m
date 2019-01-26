//
//  BTConfig.m
//  BT
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTConfig.h"

@implementation BTConfig

+ (BTConfig *)sharedInstance {
    static BTConfig *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[BTConfig alloc] init];
    });
    
    return instance;
}

@end
