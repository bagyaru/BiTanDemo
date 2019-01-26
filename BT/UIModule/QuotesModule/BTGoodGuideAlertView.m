//
//  BTGoodGuideAlertView.m
//  BT
//
//  Created by admin on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGoodGuideAlertView.h"

@implementation BTGoodGuideAlertView

+ (void)showBTGoodGuideAlertView{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTGoodGuideAlertView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    [alertView show];
    //进入币详情三次后提示 且每个版本只提示一次
    [UserDefaults setBool:YES forKey:isOrNoGoodGuideTishi];
    [UserDefaults synchronize];
    [UserDefaults removeObjectForKey:BTGoodGuideTishi];
}

+ (CGRect)frameOfAlert{
    CGFloat width = ScreenWidth-80;
    return CGRectMake(0, 0, width, 200);
}
//五星好评
- (IBAction)wxhpBtnClick:(BTButton *)sender {
    [MobClick event:@"Praise_guide_1"];
    [self __hide];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[APP_DOWNLOADURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}
//去吐槽
- (IBAction)qtcBtnClcik:(BTButton *)sender {
    
    [MobClick event:@"Praise_guide_1"];
    
    [self __hide];
    
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisMine_advice];
    [BTCMInstance pushViewControllerWithName:@"FeedBack" andParams:nil];
}
//下次再说
- (IBAction)xczsBtnClcik:(BTButton *)sender {
    [MobClick event:@"Praise_guide_2"];
    [self __hide];
}


@end
