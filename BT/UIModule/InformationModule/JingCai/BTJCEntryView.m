//
//  BTJCEntryView.m
//  BT
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTJCEntryView.h"

@implementation BTJCEntryView

//竞猜入口
- (IBAction)JingCaiBtnClick:(UIButton *)sender {
    
    [BTCMInstance pushViewControllerWithName:@"BTJingCaiMain" andParams:nil];
}

@end
