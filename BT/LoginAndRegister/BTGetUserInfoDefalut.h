//
//  BTGetUserInfoDefalut.h
//  BT
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTUserInfo.h"

@interface BTGetUserInfoDefalut : NSObject

@property (nonatomic,strong)BTUserInfo  *userInfo;
+ (instancetype)sharedManager;

@property (nonatomic, strong) NSMutableArray *posts;

- (void)removePostWithId:(NSString*)postUUidType;


@end
