//
//  BTExchangeDetailLncomeCell.h
//  BT
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTExchangeDetailLncomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kind;
@property (weak, nonatomic) IBOutlet UILabel *kyL;

@property (weak, nonatomic) IBOutlet UILabel *kyValueL;


@property (weak, nonatomic) IBOutlet UILabel *djL;

@property (weak, nonatomic) IBOutlet UILabel *djValueL;



@property (nonatomic,strong) NSDictionary *dict;
@end
