//
//  DescribeTableViewCell.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DescModel.h"
@interface DescribeTableViewCell : UITableViewCell

-(void)parseData:(DescModel*)model row:(NSInteger)row;

@end
