//
//  MyOptionViewController.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void(^OptionBlock)(void);

@interface MyOptionViewController : RootViewController

@property (nonatomic, copy) OptionBlock optionBlock;

- (void)startTimer;

- (void)stopTimer;

@end
