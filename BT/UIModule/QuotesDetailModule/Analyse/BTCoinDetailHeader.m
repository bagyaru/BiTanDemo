//
//  BTCoinDetailHeader.m
//  BT
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinDetailHeader.h"

@interface BTCoinDetailHeader()
@property (weak, nonatomic) IBOutlet UILabel *mairuIndic;
@property (weak, nonatomic) IBOutlet UILabel *maichuIndic;


@end

@implementation BTCoinDetailHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.mairuIndic.layer.cornerRadius = 5.0f;
    self.maichuIndic.layer.cornerRadius = 5.0f;
    self.mairuIndic.layer.masksToBounds = YES;
    self.maichuIndic.layer.masksToBounds = YES;
}

@end
