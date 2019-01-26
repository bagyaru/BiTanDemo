//
//  BTShareHeaderView.m
//  BT
//
//  Created by apple on 2018/5/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTShareHeaderView.h"

@implementation BTShareHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSDate *date = [NSDate date];
    NSString *dateFormatter = @"EEEE yyyy-MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeL.text = dateStr;
}

@end
