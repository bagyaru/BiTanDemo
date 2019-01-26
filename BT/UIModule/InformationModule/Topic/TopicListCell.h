//
//  TopicListCell.h
//  BT
//
//  Created by admin on 2018/4/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface TopicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (nonatomic,strong)FastInfomationObj *model;
@property (weak, nonatomic) IBOutlet BTButton *buttonlHotRecommend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHotRecommendW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;


@end
