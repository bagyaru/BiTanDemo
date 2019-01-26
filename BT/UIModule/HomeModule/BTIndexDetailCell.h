//
//  BTIndexDetailCell.h
//  BT
//
//  Created by admin on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBitaneIndexDetailModel.h"
@interface BTIndexDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *bottomPriceL;
@property (weak, nonatomic) IBOutlet UILabel *hslL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLeftConstant;
@property (nonatomic, strong)BTBitaneIndexDetailModel *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *exchangeCode;
@end
