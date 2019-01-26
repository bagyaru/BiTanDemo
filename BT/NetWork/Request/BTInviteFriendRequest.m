//
//  BTInviteFriendRequest.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTInviteFriendRequest.h"

@implementation BTInviteFriendRequest

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return MyInviteFriendUrl;
}

@end
