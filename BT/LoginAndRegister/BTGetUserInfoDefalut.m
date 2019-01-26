//
//  BTGetUserInfoDefalut.m
//  BT
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGetUserInfoDefalut.h"
#import "BTPostMainListModel.h"

@implementation BTGetUserInfoDefalut
+ (instancetype)sharedManager{
    static BTGetUserInfoDefalut *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
        
    });
    
    return sInstance;
}

- (NSMutableArray*)posts{
    if(!_posts){
        _posts = @[].mutableCopy;
    }
    return _posts;
}

- (BTUserInfo *)userInfo {
    
    if (!_userInfo) {
        
        _userInfo = [BTUserInfo loadFromClassFile];
    }
    return _userInfo;
}

- (void)removePostWithId:(NSString *)postUUidType{
    if(self.posts.count == 0) return;
    for(NSInteger i =0; i < self.posts.count; i++){
        BTPostMainListModel *listModel = self.posts[i];
        if([listModel.uuid isEqualToString:postUUidType]){
            [self.posts removeObject:listModel];
        }
    }
}


@end
