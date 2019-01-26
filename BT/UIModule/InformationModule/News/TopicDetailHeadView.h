//
//  TopicDetailHeadView.h
//  BT
//
//  Created by admin on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
typedef void (^DownOrUpBlack)(void);
@interface TopicDetailHeadView : BTView

@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, copy) DownOrUpBlack dOuBlack;
@property (nonatomic, strong) NSString *dOuStr;
@property (weak, nonatomic) IBOutlet UIButton *dOuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topIV;
@property (weak, nonatomic) IBOutlet BTLabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstrainat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstrainat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dOuBtnConstrainat;

@property (weak, nonatomic) IBOutlet BTButton *buttonlHotRecommend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHotRecommendW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;

-(CGFloat)getHeadViewHeight;
@end
