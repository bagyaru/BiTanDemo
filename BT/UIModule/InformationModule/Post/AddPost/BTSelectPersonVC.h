//
//  BTSelectPersonVC.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void(^SelectUserBlock)(NSString *name);

@interface BTSelectPersonVC : RootViewController

@property (nonatomic, copy) SelectUserBlock selectBlock;

@end
