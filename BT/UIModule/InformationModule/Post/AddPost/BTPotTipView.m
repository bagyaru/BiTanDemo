//
//  BTExceptionalCeilingView.m
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPotTipView.h"
@interface BTPotTipView()
@property (weak, nonatomic) IBOutlet BTLabel *contentL;
@property (nonatomic, copy) BTPotTipViewCompletionBlock block;
@end
@implementation BTPotTipView

+ (void)showBTPotTipView:(NSString *)content completion:(nonnull BTPotTipViewCompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTPotTipView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.block = block;
    alertView.layer.cornerRadius = 4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.contentL.text = content;
    [alertView show];
}
+ (CGRect)frameOfAlert{
    CGFloat width = 300;
    return CGRectMake(0, 0, width, 120);
}
- (IBAction)zhidaolBtnClick:(BTButton *)sender {
    [self __hide];
    if(self.block){
        self.block(0);
    }
}
- (void)controlPressed{
    
}

@end
