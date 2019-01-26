//
//  PlatformNavagationView.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface PlatformNavagationView : BTView
@property (weak, nonatomic) IBOutlet BTButton *xianhuoBtn;
@property (weak, nonatomic) IBOutlet UILabel *xianhuoL;
@property (weak, nonatomic) IBOutlet UILabel *qihuoL;
@property (weak, nonatomic) IBOutlet BTButton *qihuoBtn;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@end
