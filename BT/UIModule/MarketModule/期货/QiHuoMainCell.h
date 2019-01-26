//
//  QiHuoMainCell.h
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiHuoMainObj.h"
@interface QiHuoMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BTLabel *titleL;

@property (weak, nonatomic) IBOutlet BTLabel *heyuemingchengL;

@property (weak, nonatomic) IBOutlet BTLabel *changpingdaimaL;
-(void)creatUIWith:(QiHuoMainObj *)obj;
@end
