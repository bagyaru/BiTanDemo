//
//  MessageCenterCell.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCenterObj.h"
@interface MessageCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BTLabel *timeL;
@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet BTLabel *contentL;
@property (weak, nonatomic) IBOutlet BTButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedBackView;
@property (weak, nonatomic) IBOutlet UILabel *feedBackTitleL;
@property (weak, nonatomic) IBOutlet UILabel *feedBackContentL;
@property (weak, nonatomic) IBOutlet UIView *viewBQ;
@property (weak, nonatomic) IBOutlet UILabel *labelBQ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSource;
@property (weak, nonatomic) IBOutlet UILabel *labelSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSource;
@property (weak, nonatomic) IBOutlet UILabel *labelUnread;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewSourceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewSourceW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;




-(void)creatUIWith:(MessageCenterObj *)obj;

@end
