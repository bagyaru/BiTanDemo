//
//  BTViewControllerSetting.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTViewController <NSObject>

+ (id)createWithParams: (NSDictionary *)params;

+ (void)popWithParams:(NSDictionary *)params;

@end

NSDictionary *BTViewControllerMap(void);

//全局通用定义
#define BTHomeCtrl @"main"


@interface BTViewControllerSetting : NSObject


@end
