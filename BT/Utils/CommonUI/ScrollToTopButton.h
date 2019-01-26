//
//  ScrollToTopButton.h
//  BT
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollToTopButton : UIView

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView*)scrollView;
- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView*)scrollView completion:(UIView_ToTop_Operation)completion;

@property (nonatomic, copy) UIView_ToTop_Operation block;

@end

NS_ASSUME_NONNULL_END
