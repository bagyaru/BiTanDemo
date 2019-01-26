//
//  H5InfomationDetailViewController.h
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

@interface H5InfomationDetailViewController : RootViewController
@property (nonatomic,strong)NSString *urlID;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *shareImageURL;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *whereVC;

@property (nonatomic,assign)NSInteger bigType;

@property (nonatomic,assign)BOOL isFavor;
@end
