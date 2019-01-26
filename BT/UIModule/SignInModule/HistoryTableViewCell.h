//
//  HistoryTableViewCell.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface HistoryTableViewCell : UITableViewCell

-(void)parseData:(HistoryModel*)model;

@property (nonatomic, assign) BOOL isIncome;


@end
