//
//  NewsHeadView.h
//  BT
//
//  Created by admin on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "FastInfomationObj.h"
typedef void (^GoDetailBlack)(NSString *detailID);
@interface NewsHeadView : BTView

@property (nonatomic,copy)GoDetailBlack goDetailBlack;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewH;

@end
