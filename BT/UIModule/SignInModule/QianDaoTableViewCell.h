//
//  QianDaoTableViewCell.h
//  BT
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QianDaoModel.h"

@interface QianDaoTableViewCell : UITableViewCell

-(NSString *)parseData:(QianDaoModel*)model;

@end
