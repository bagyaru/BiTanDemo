//
//  MyCoinDetailHeader.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCoinDetailHeader.h"

@implementation MyCoinDetailHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.tsL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.tsL addGestureRecognizer:tap];
}

//提升探力
- (void)tap:(UIGestureRecognizer*)gesture{
      [BTCMInstance pushViewControllerWithName:@"InviteFriendVC" andParams:nil];
}

@end
