//
//  BTDiscoverySelectView.h
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTDiscoverySelectView : UIView

@property (weak, nonatomic) IBOutlet UIButton *zfBtn;
@property (weak, nonatomic) IBOutlet UIButton *dfBtn;
@property (weak, nonatomic) IBOutlet UIView *zfIndicator;
@property (weak, nonatomic) IBOutlet UIView *dfIndicator;

- (void)setZfColor;
- (void)setDfColor;
@end
