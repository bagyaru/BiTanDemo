//
//  BTFuturePaoPaoView.m
//  BT
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFuturePaoPaoView.h"

@implementation BTFuturePaoPaoView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 2.0f;
    self.layer.masksToBounds = YES;
}

@end
