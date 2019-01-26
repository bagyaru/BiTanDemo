//
//  UIView+MKExtension.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKExtension)

/**
 @brief 从xib中加载view
 */
+ (id)loadFromXib;

- (void)setTapActionWithBlock:(void (^)(void))block;

-(UIViewController *)getCurrentViewController;
@end
