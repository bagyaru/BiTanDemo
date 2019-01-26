//
//  NoLoginView.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LoginOrOptionType){
    LoginOrOptionTypeNoLogin = 1,
    LoginOrOptionTypeNoOption = 2,
    UserCenterNoMessage = 3,
    FocusListVC = 4
};

typedef void(^LoginBlock)(void);
typedef void(^NOOptionBlock)(void);

@interface NoLoginView : BTView

@property (nonatomic, assign) LoginOrOptionType type;

@property (nonatomic, copy) LoginBlock loginBlock;

@property (nonatomic, copy) NOOptionBlock noOptionBlock;

- (void)showInWithParentView:(UIView *)parentView;

@end
