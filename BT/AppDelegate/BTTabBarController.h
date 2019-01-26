//
//  BTMainViewController.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTabBarController : UITabBarController
//回到首页
- (void)guideToHome;
//回到行情
- (void)guideToQuotes;
//回到社区
- (void)guideToInfomation;
//回到发现
- (void)guideToDiscoveryMain;
//回到我的
- (void)guideToUserCenter;
@end
