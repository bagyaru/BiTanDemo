//
//  UIWindow+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/1/22.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "UIWindow+MKExtension.h"

@implementation UIWindow (MKExtension)

- (UIViewController *)topViewController
{
    return [self topViewController:self.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end
