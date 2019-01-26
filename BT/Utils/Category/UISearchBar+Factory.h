//
//  UISearchBar+Factory.h
//  Chonps
//
//  Created by tangshilei on 2017/8/16.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Factory)

+ (UISearchBar*)searchBarWithTintColor:(UIColor *)color corner:(CGFloat)corner textFont:(UIFont*)textFont textColor:(UIColor*)textColor placeholderColor:(UIColor*)placeHolderColor placeholderFont:(UIFont*)placeHolderFont;


@end
