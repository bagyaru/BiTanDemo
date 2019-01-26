//
//  BTDeteleRecordAlert.m
//  BT
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeteleRecordAlert.h"

@interface BTDeteleRecordAlert()
@property (nonatomic, copy) DeleteRecoCompletionBlock block;
@property (nonatomic, strong)BTRecordModel *model;

@end

@implementation BTDeteleRecordAlert

+ (void)showWithRecordModel:(BTRecordModel *)model completion:(DeleteRecoCompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTDeteleRecordAlert *alertView;
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
    CGFloat width = 300;
    return CGRectMake(0, 0, width, 135);
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
