//
//  SettingNickNameViewController.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"
typedef void (^changeSuccess)(NSString * str);
@interface SettingIntroduceViewController : RootViewController
@property (nonatomic,strong)NSString *oldNickName;

@property (nonatomic,  copy)changeSuccess SuccessBlock;

@end
