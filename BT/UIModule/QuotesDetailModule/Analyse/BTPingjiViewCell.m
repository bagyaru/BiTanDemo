//
//  BTPingjiViewCell.m
//  BT
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPingjiViewCell.h"

@implementation BTPingjiViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [AppHelper addLeftLineWithParentView:self];
    [self.tsBtn setImage:[UIImage imageNamed:@"ic_tishi"] forState:UIControlStateNormal];
}
- (IBAction)click:(id)sender {
    [BTCMInstance pushViewControllerWithName:@"BTPingjiViewController" andParams:nil];
    
}


@end
