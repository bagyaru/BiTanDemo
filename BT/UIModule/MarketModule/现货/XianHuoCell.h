//
//  XianHuoCell.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XianHuoMainObj.h"
#import "XHStarRateView.h"
@interface XianHuoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet BTLabel *contentL;
@property (weak, nonatomic) IBOutlet BTLabel *jiaoyiduiL;
@property (weak, nonatomic) IBOutlet BTLabel *guojiaL;
@property (weak, nonatomic) IBOutlet BTLabel *chengjiaoliangL;
@property (weak, nonatomic) IBOutlet BTLabel *paimingL;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *tagL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *tag1L;
@property (weak, nonatomic) IBOutlet UILabel *tag2L;

@property (weak, nonatomic) IBOutlet UILabel *tag3L;

-(void)creatUIWith:(XianHuoMainObj *)obj;
@end
