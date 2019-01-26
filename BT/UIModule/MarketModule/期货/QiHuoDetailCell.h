//
//  QiHuoDetailCell.h
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiHuoDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

-(void)creatUIWith:(NSMutableDictionary *)dict;
@end
