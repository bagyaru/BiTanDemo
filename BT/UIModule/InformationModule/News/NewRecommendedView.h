//
//  NewRecommendedView.h
//  BT
//
//  Created by admin on 2018/4/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "FastInfomationObj.h"
@interface NewRecommendedView : BTView
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UILabel *viewCountL;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *goDetailBtn;

@property (nonatomic,strong)FastInfomationObj *model;
-(CGFloat)getHeadViewHeight;

@end
