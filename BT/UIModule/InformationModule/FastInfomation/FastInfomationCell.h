//
//  FastInfomationCell.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface FastInfomationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet BTButton *detailBtn;
@property (weak, nonatomic) IBOutlet BTButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *blackRoundL;
@property (weak, nonatomic) IBOutlet UIView *backV;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewRound;

-(void)creatUIWith:(FastInfomationObj *)obj;
@end
