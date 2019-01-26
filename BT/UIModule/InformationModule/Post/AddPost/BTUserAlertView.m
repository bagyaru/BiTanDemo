//
//  BTDeletePostAlertView.m
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserAlertView.h"
@interface BTUserAlertView()
@property (nonatomic, copy) CompletionBlock block;
@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet BTLabel *contentL;

@end

@implementation BTUserAlertView

+ (void)showWithTitle:(NSString *)title content:(NSString*)content completion:(CompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTUserAlertView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.titleL.text = title;
    alertView.contentL.text = content;
    alertView.block = block;
    [alertView show];
}

+ (CGRect)frameOfAlert{
    CGFloat width = 300;
    return CGRectMake(0, 0, width, 192);
}
- (IBAction)cancel:(id)sender {
    [self __hide];
    if(self.block){
        self.block(0);
    }
}
- (IBAction)confirm:(id)sender {
    [self __hide];
    if(self.block){
        self.block(1);
    }
}
- (void)controlPressed{
    
}
@end
