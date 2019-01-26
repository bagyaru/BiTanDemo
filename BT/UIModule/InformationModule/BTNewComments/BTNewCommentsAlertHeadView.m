//
//  BTNewCommentsAlertHeadView.m
//  BT
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewCommentsAlertHeadView.h"

@implementation BTNewCommentsAlertHeadView
-(void)awakeFromNib {
    [super awakeFromNib];
    [self.closeBtn setImage:IMAGE_NAMED(@"评论关闭") forState:UIControlStateNormal];
}
-(void)setNumber:(NSInteger)number {
    
    if (number > 0) {
      self.numberL.text = [NSString stringWithFormat:@"%ld%@",number,[APPLanguageService wyhSearchContentWith:@"tiaohuifu"]];
    }else {
        
        self.numberL.text = [APPLanguageService wyhSearchContentWith:@"zanwuhuifu"];
    }
}
- (IBAction)closeBtnCLick:(UIButton *)sender {
    if (self.isSearch) {
        
        [BTCMInstance popViewController:nil];
    }else {
        
        [BTCMInstance dismissViewController];
    }
}

@end
