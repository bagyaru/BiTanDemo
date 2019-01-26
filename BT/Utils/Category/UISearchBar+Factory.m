//
//  UISearchBar+Factory.m
//  Chonps
//
//  Created by tangshilei on 2017/8/16.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "UISearchBar+Factory.h"

@implementation UISearchBar (Factory)

+ (UISearchBar*)searchBarWithTintColor:(UIColor *)color corner:(CGFloat)corner textFont:(UIFont*)textFont textColor:(UIColor*)textColor placeholderColor:(UIColor*)placeHolderColor placeholderFont:(UIFont*)placeHolderFont{
    UISearchBar *_searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [_searchBar setBackgroundImage:[self getImageWithColor:[UIColor clearColor] size:_searchBar.frame.size]];
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.tintColor =color;

    UITextField *_searchBarTF = [_searchBar valueForKey:@"_searchField"];
    [_searchBarTF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_searchBarTF setValue:placeHolderFont forKeyPath:@"_placeholderLabel.font"];
    
    _searchBarTF.font =textFont;
    _searchBarTF.textColor =textColor;
    _searchBarTF.layer.cornerRadius = corner;
    _searchBarTF.clipsToBounds = YES;
    
    
    return _searchBar;
    
    
}

+ (UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
