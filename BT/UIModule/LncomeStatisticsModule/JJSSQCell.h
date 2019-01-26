//
//  JJSSQCell.h
//  BT
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSSQCell : UITableViewCell

@property (nonatomic,strong) NSString *exchangeName;
@property (weak, nonatomic) IBOutlet UILabel *jjsNameL;

@property (weak, nonatomic) IBOutlet BTButton *sqBtn;

@end
