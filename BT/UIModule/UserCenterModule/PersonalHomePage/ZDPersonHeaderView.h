//
//  DMCommunityDetailHeaderView.h
//  DMRice
//
//  Created by zdd. on 17/4/10.
//  Copyright © zdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDSelectMenuView.h"
#import "BYListBar.h"
#import "BTMyHeaderView.h"
@class ZDPersonHeaderView;
@protocol ZDPersonHeaderViewDelegate <NSObject>
//点击菜单
- (void)personHeaderView:(ZDPersonHeaderView *)communityDetailHeaderView didSelectItemAtIndex:(NSInteger)index;

- (void)clickButton:(NSInteger)index;

@end

@interface ZDPersonHeaderView : UIView

@property (nonatomic, strong)ZDSelectMenuView   *selectMenuView;//菜单

@property (nonatomic, strong) BYListBar *listBar;

@property (nonatomic, weak)id <ZDPersonHeaderViewDelegate> delegate;

@property (nonatomic, strong)UIImageView        *backgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageV;
@property (nonatomic, strong) UILabel *introduceL;
@property (nonatomic, strong)UILabel  *nameLabel;

@property (nonatomic, strong) UIButton *verifyBtn;


@property (nonatomic, assign)NSInteger              selectIndex; //菜单下表

//穿透view的数量
@property (nonatomic, copy)NSArray                    *passthroughViews;

@property (nonatomic, strong) BTMyHeaderView *postHeader;

@end
