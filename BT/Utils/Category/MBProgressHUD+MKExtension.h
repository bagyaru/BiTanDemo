//
//  MBProgressHUD+MKExtension.h
//  YangDongXi
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MKExtension)

/**
 @brief 提示框，默认显示在window中
 */
+ (MBProgressHUD *)showMessage:(NSString *)msg wait:(BOOL)wait;
+ (MBProgressHUD *)showMessageIsWait:(NSString *)msg wait:(BOOL)wait;

+ (MBProgressHUD *)showMessage:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait;
@end
