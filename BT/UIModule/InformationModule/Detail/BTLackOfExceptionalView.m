//
//  BTLackOfExceptionalView.m
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLackOfExceptionalView.h"

@implementation BTLackOfExceptionalView

+(void)showLackOfExceptionalView {
    
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTLackOfExceptionalView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    [alertView show];
}
+ (CGRect)frameOfAlert{
    CGFloat width = 300;
    return CGRectMake(0, 0, width, 120);
}
- (IBAction)cancelBtnClick:(BTButton *)sender {
    [self __hide];
}
- (IBAction)quzhuanquBtnClick:(BTButton *)sender {
    
    [self __hide];
    [MobClick event:@"tanli_task"];
    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiChild" andParams:@{@"currentPage":@(1)}];
}

@end
