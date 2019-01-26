//
//  HomeHeadView.h
//  BT
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "BTZFFFModel.h"
@interface HomeHeadView : BTView

@property (weak, nonatomic) IBOutlet BTLabel *zs1_title1L;
@property (weak, nonatomic) IBOutlet UILabel *zs1_title2L;
@property (weak, nonatomic) IBOutlet UILabel *zs1_title3L;
@property (weak, nonatomic) IBOutlet BTLabel *zs2_title1L;
@property (weak, nonatomic) IBOutlet UILabel *zs2_title2L;
@property (weak, nonatomic) IBOutlet UILabel *zs2_title3L;
@property (weak, nonatomic) IBOutlet BTLabel *zs3_title1L;
@property (weak, nonatomic) IBOutlet UILabel *zs3_title2L;
@property (weak, nonatomic) IBOutlet UILabel *zs3_title3L;
@property (weak, nonatomic) IBOutlet BTLabel *ZFFB_TYPE1;
@property (weak, nonatomic) IBOutlet BTLabel *ZFFB_TYPE2;
@property (weak, nonatomic) IBOutlet UIView *ZFFB_VIEW;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewH;
@property (weak, nonatomic) IBOutlet UIView *noticeView;



@property (nonatomic,strong) NSDictionary *ZFFB_DICT;
@property (nonatomic,strong) NSMutableArray *array;

@end
