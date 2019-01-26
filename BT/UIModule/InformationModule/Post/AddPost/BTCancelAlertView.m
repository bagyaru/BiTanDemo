//
//  BTCancelAlertView.m
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCancelAlertView.h"
@interface BTCancelAlertView()
@property (nonatomic, copy) DeleteRecoCompletionBlock block;

@end
@implementation BTCancelAlertView

+ (void)showWithTitle:(NSString *)title completion:(DeleteRecoCompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTCancelAlertView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius = 4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.block = block;
    [alertView show];
}

+ (CGRect)frameOfAlert{
    CGFloat width = 305;
    return CGRectMake(0, 0, width, 172);
}

- (IBAction)cancel:(id)sender {
    [self __hide];
    if(self.block){
        self.block(@"");
    }
}

- (IBAction)confirm:(id)sender {
    [self __hide];
    if(self.block){
        self.block(@"confirm");
    }
}

- (void)controlPressed{
    [super controlPressed];
    if(self.block){
        self.block(@"");
    }
}

@end
