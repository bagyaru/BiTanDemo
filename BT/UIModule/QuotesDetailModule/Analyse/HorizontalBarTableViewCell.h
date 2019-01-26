//
//  HorizontalBarTableViewCell.h
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalBarModel.h"

@interface HorizontalBarTableViewCell : UITableViewCell

-(void)parseData:(HorizontalBarModel*)model row:(NSInteger)row;


@end
