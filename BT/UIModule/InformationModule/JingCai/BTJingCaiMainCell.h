//
//  BTJingCaiMainCell.h
//  BT
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTjingcaiMainModel.h"
typedef void (^BTJingcaiBlock)(NSInteger type,BTjingcaiMainModel *model);
@interface BTJingCaiMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *JCZ_View;
@property (weak, nonatomic) IBOutlet UIView *YKJ_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *JCZ_View_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YKJ_View_Height;
@property (nonatomic,strong)BTjingcaiMainModel *model;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic,strong) BTJingcaiBlock JCBlock;
@end
