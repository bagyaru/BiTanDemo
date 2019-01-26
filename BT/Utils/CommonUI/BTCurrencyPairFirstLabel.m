//
//  BTCurrencyPairFirstLabel.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCurrencyPairFirstLabel.h"

@implementation BTCurrencyPairFirstLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        self.font = MediumFont;
        self.textColor = CBlackColor;
    }
    return self;
}



@end
