//
//  OptiontimeView.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//


///首页选择 交易所
#import <UIKit/UIKit.h>
#import "BTExchangeListModel.h"

typedef void(^HiddenBlock)(void);

typedef void(^OptionTypeBlock)(BTExchangeListModel *model);

@interface OptionExchangeView : UIView

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) HiddenBlock hiddenblock;

@property (nonatomic, copy) OptionTypeBlock optionTypeBlock;

@property (nonatomic, strong) UIView *viewRotation;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) BTExchangeListModel *selectModel;


- (void)showInParentView:(UIView *)parentView relativeView:(UIView *)relativeView;



@end
