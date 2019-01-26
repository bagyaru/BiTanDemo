//
//  THFInformationAndBaiKeHeadView.h
//  淘海房
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THFInformationAndBaiKeHeadView : BTView

@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *nickeName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;

@property (weak, nonatomic) IBOutlet BTLabel *bqL;
@property (weak, nonatomic) IBOutlet BTLabel *numberL;

@property (weak, nonatomic) IBOutlet UILabel *labelTwo;

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet BTLabel *jiaL;
@property (weak, nonatomic) IBOutlet BTLabel *labelFocus;
@property (weak, nonatomic) IBOutlet UIButton *buttonFocus;

@end
