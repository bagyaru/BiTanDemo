//
//  BTPingjiViewCell.h
//  BT
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@interface BTPingjiViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet XHStarRateView *rateView;
@property (weak, nonatomic) IBOutlet UIButton *tsBtn;

@end
