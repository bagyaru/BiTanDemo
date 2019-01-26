//
//  DiscussViewController.h
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SGCenterChildBaseVC.h"

@interface DiscussViewController : SGCenterChildBaseVC

@property (nonatomic, strong) NSString *kindCode;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isSearch;
@end
