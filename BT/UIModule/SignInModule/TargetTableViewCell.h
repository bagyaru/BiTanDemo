//
//  TargetTableViewCell.h
//  BT
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetModel.h"

typedef void(^TargetBtnClickBlock)(UIButton *btn);
@interface TargetTableViewCell : UITableViewCell

-(void)parseData:(TargetModel*)model row:(NSInteger)row btnClick:(TargetBtnClickBlock)btnBlock;

@end
