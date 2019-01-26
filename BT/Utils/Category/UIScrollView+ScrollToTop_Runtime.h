//
//  UIScrollView+ScrollToTop_Runtime.h
//  BT
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIView_ToTop_Operation)(void);

@interface UIView (ScrollToTop_Runtime)

@property (nonatomic, copy) UIView_ToTop_Operation toTopBlock;

- (void)configToTop:(UIView_ToTop_Operation)block;

@end
