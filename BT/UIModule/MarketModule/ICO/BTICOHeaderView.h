//
//  BTICOHeaderView.h
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "BTICODetailModel.h"

@interface BTICOHeaderView : BTView

@property (weak, nonatomic) IBOutlet UIView *footbgView;
@property (weak, nonatomic) IBOutlet UIView *icoTimeView;
@property (weak, nonatomic) IBOutlet UIView *icoProcessView;
@property (weak, nonatomic) IBOutlet UIView *icoTipView;

@property (weak, nonatomic) IBOutlet UIView *icoLinkView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdCons;

@property (nonatomic, strong)BTICODetailModel *detailModel;

@end
