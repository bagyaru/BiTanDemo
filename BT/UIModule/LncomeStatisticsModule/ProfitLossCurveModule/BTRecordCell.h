//
//  BTRecordCell.h
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRecordModel.h"
@interface BTRecordCell : UITableViewCell

@property (nonatomic, strong)BTRecordModel *model;
@property (nonatomic, strong) NSString *kind;

@end
