//
//  BTFocusRecommendCell.h
//  BT
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTFocusRecommendModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^FocusBlock)(BTFocusRecommendModel *model);//关注
@interface BTFocusRecommendCell : UITableViewCell

@property (nonatomic, copy) FocusBlock focusBlock;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewV;
@property (weak, nonatomic) IBOutlet UILabel *labelNikeName;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduction;
@property (weak, nonatomic) IBOutlet UILabel *labelFans;
@property (weak, nonatomic) IBOutlet BTButton *buttonFocus;

@property (nonatomic, strong) BTFocusRecommendModel * model;
@end

NS_ASSUME_NONNULL_END
