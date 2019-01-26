//
//  BTDeletePostAlertView.m
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeletePostAlertView.h"
@interface BTDeletePostAlertView()
@property (nonatomic, copy) DeleteRecoCompletionBlock block;
@property (nonatomic, strong)BTPostMainListModel *model;

@end
@implementation BTDeletePostAlertView

+ (void)showWithRecordModel:(BTPostMainListModel *)model completion:(DeleteRecoCompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTDeletePostAlertView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.block = block;
    alertView.model = model;
    [alertView show];
}

+ (CGRect)frameOfAlert{
    CGFloat width = 305;
    return CGRectMake(0, 0, width, 192);
}
- (IBAction)cancel:(id)sender {
    [self __hide];
}
- (IBAction)confirm:(id)sender {
    [self __hide];
    if(self.block){
        self.block(self.model);
    }
}
@end
