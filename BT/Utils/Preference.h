//
//  Preference.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kFirstInstalled            @"firstinstalled"

// 启动次数
#define kLaunchedTimes             @"Preference10"

@interface Preference : NSObject

+ (Preference *)sharedInstance;

- (void)initDefaultPreference;

- (BOOL)readIsAppFirstInstalled;

- (void)writeFirstInstalled:(BOOL)b;

- (NSInteger)readLaunchedTime;

- (void)writeLaunchedTime:(NSInteger)launchTime;
@end
