//
//  LineViewTableViewCell.h
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineViewTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) BOOL isNoDetail;

@end
