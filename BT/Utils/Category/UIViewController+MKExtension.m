//
//  UIViewController+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "UIViewController+MKExtension.h"

@implementation UIViewController (MKExtension)

+ (id)create
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([self class])
                                                 bundle:[NSBundle mainBundle]];
    return [sb instantiateInitialViewController];
}
+ (id)createSbWith:(NSString *)name andId:(NSString *)vcID {
    
    UIStoryboard *czsb = [UIStoryboard storyboardWithName:name bundle:nil];
    
    UIViewController *sbVc = [czsb instantiateViewControllerWithIdentifier:vcID];
    
    return sbVc;
}
@end
