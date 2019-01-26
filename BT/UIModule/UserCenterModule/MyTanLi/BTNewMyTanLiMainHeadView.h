//
//  BTNewMyTanLiMainHeadView.h
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "QianDaoModel.h"
#import "BTMyTPModel.h"
#import "BTTanLiQianLiListModel.h"

@interface BTNewMyTanLiMainHeadView : BTView
@property (weak, nonatomic) IBOutlet UILabel *labelTotalTP;
@property (weak, nonatomic) IBOutlet UILabel *labelTodayGetTP;
@property (weak, nonatomic) IBOutlet UILabel *labelQiaoDaoProgress;
@property (weak, nonatomic) IBOutlet UIView *viewTPJiangLiList;
@property (weak, nonatomic) IBOutlet UIButton *buttonQianDao;

@property (nonatomic, strong) NSMutableArray *TPJiangLiListArray;
/**签到图数组*/
@property (nonatomic,strong) NSMutableArray *imgBgViewArr;
@property (nonatomic,strong) QianDaoModel *model;
@property (nonatomic,strong) BTMyTPModel  *myTPModel;
@end
