//
//  BTOneTPTargetView.h
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "TargetModel.h"
@interface BTOneTPTargetView : BTView
@property (nonatomic, strong)TargetModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBig;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end
