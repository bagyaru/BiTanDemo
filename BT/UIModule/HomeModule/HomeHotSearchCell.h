//
//  HomeHotSearchCell.h
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QutoesDetailMarket.h"
#import "XHStarRateView.h"
@interface HomeHotSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) QutoesDetailMarket *model;
@property (weak, nonatomic) IBOutlet UILabel *sortL;


@end
