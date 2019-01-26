//
//  MBProgressHUD+MKExtension.m
//  YangDongXi
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MBProgressHUD+MKExtension.h"
#import "UIImage+GIF.h"
@implementation MBProgressHUD (MKExtension)

+ (MBProgressHUD *)showMessage:(NSString *)msg wait:(BOOL)wait;
{
    return [self showMessagea:msg inView:[[UIApplication sharedApplication] keyWindow] wait:YES];
}
+ (MBProgressHUD *)showMessageIsWait:(NSString *)msg wait:(BOOL)wait{
    return [self showMessagea:msg inView:[[UIApplication sharedApplication] keyWindow] wait:wait];
}
+ (MBProgressHUD *)showMessage:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.userInteractionEnabled = wait;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = msg;
    
    if (!wait)
    {
        hud.mode = MBProgressHUDModeText;
        //hud.backgroundColor = [UIColor blackColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [hud hide:YES];
                       });
    }
    [hud show:YES];
    return hud;
}

+ (MBProgressHUD *)showMessagea:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    
    [view addSubview:hud];
    hud.userInteractionEnabled = wait;
    hud.removeFromSuperViewOnHide = YES;
    //    hud.detailsLabel.text = msg;
    //    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    //    hud.contentColor = [UIColor colorWithHex:0xFFFFFF];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.bezelView.backgroundColor = [UIColor grayColor];
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    
    if (wait)
    {
        hud.mode = MBProgressHUDModeCustomView;
        //hud.backgroundColor = [UIColor blackColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [hud hide:YES];
                       });
    }
    
    [hud show:YES];
    return hud;
}

@end
