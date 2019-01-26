//
//  OptionIndexView.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HiddenBlock)(void);

typedef void(^OptionTypeBlock)(NSInteger type,NSString *str);

@interface OptionIndexView : UIView

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) HiddenBlock hiddenblock;

@property (nonatomic, copy) OptionTypeBlock optionTypeBlock;

@property (nonatomic, strong) UIView *viewRotation;

@property (nonatomic, strong) NSArray *dataArr;

- (void)showInParentView:(UIView *)parentView relativeView:(UIView *)relativeView;

- (NSInteger)fromeWithTitle:(NSString *)title;

- (void)hiddenView;


//主指标
@property (nonatomic, strong) NSString *mainTag;

//副指标
@property (nonatomic, strong) NSString *accessoryTag;


@end
