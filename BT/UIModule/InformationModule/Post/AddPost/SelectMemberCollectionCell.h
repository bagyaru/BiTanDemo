//
//  SelectMemberCollectionCell.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConatctModel.h"
@interface SelectMemberCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memberHeadImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, strong) ConatctModel *model;


@end
