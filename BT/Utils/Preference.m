//
//  Preference.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Preference.h"

@implementation Preference

+ (Preference *)sharedInstance{
    static Preference *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[Preference alloc] init];
    });
    
    return instance;
}

- (void)initDefaultPreference{
    [self writeFirstInstalled:NO];
}

- (BOOL)readIsAppFirstInstalled{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger first = [userDefaults integerForKey:kFirstInstalled];
    if (first != 1024)
        return YES;
    else
        return NO;
}

- (void)writeFirstInstalled:(BOOL)b{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (b)
        [userDefaults setInteger:1 forKey:kFirstInstalled];
    else
        [userDefaults setInteger:1024 forKey:kFirstInstalled];
}

- (NSInteger)readLaunchedTime {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kLaunchedTimes];
}

- (void)writeLaunchedTime:(NSInteger)launchTime {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:launchTime forKey:kLaunchedTimes];
}

@end
