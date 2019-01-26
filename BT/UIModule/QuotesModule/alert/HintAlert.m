//
//  HintAlert.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HintAlert.h"

@interface HintAlert()

@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation HintAlert

+ (void)showHint:(NSString *)hint{
    HintAlert *alert = [[HintAlert alloc] initWithFrame:[self frameOfAlert]];
    alert.infoLabel.text = hint;
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert __hide];
        
    });
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 310, 106);
}

- (void)createView{
    _infoLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:16.0f] textColor:kHEXCOLOR(0xFFFFFF)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    [self addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.layer.cornerRadius = 1.0f;
    self.layer.masksToBounds = YES;
    UIColor *color = kHEXCOLOR(0x000000);
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    self.viewControl.backgroundColor = [UIColor clearColor];
}

@end
