//
//  BTExceptionalCeilingView.m
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExceptionalCeilingView.h"

@implementation BTExceptionalCeilingView

+(void)showExceptionalCeilingView {
    
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTExceptionalCeilingView *alertView;
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
- (IBAction)zhidaolBtnClick:(BTButton *)sender {
    [self __hide];
}


@end
