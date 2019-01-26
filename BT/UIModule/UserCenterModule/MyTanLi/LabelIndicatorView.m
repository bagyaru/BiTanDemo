//
//  LabelIndicatorView.m
//  BT
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LabelIndicatorView.h"

@implementation LabelIndicatorView

- (instancetype)initWithFrame:(CGRect)frame invite:(BOOL)isInvite title:(NSString*)title font:(UIFont*)font textColor:(UIColor*)color alpha:(CGFloat)alpha{
    if(self = [super initWithFrame:frame]){
        UILabel *label =[UILabel labelWithFrame:CGRectZero title:title font:font textColor:color];
        UIImageView *imageV =[[UIImageView alloc] initWithFrame:CGRectZero];
        if(isInvite){
            imageV.image =[UIImage imageNamed:@"invite_down"];
        }else{
            imageV.image =[UIImage imageNamed:@"tanli_more"];
        }
        imageV.userInteractionEnabled = YES;
        [self addSubview:label];
        [self addSubview:imageV];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(9);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageV.mas_centerY);
            make.right.equalTo(imageV.mas_left).offset(-6.0f);
        }];
    }
    return self;
}




@end
