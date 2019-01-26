//
//  BTTitleView.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

typedef void(^AddHandleBlock)(void);

@interface BTNaviView : BTView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *fixTitle;

@property (nonatomic, assign) BOOL isHiddenRight;

@property (nonatomic, strong) UIImage *imageRight;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet BTLabel *userNameL;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthCons;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (nonatomic, copy) AddHandleBlock addHandleBlock;

@property (weak, nonatomic) IBOutlet UIView *avatarBgView;

- (void)showInViewWith:(UIView *)parentView;


@end
