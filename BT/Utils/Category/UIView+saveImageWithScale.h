//
//  UIView+saveImageWithScale.h
//  BT
//
//  Created by apple on 2018/5/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (saveImageWithScale)

- (UIImage *)saveImageWithScale:(float)scale;

- (UIImage*)saveImageWithScale:(float)scale frame:(CGRect)frame;
@end
