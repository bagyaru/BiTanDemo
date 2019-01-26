//
//  BTJingCaiMainView.h
//  BT
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTJingCaiMainView : BTView
@property (weak, nonatomic) IBOutlet UIButton *zfBtn;
@property (weak, nonatomic) IBOutlet UIButton *dfBtn;
@property (weak, nonatomic) IBOutlet UIView *zfIndicator;
@property (weak, nonatomic) IBOutlet UIView *dfIndicator;

- (void)setZfColor;
- (void)setDfColor;
@end
