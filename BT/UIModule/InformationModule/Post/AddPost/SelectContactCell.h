//
//  SelectContactCell.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConatctModel.h"
@interface SelectContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contactAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (nonatomic, strong) ConatctModel *model;


@end
