//
//  BTICODetailApi.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICODetailApi.h"

@implementation BTICODetailApi{
    NSString *_mID;
}

- (instancetype)initWithId:(NSString *)mId{
    if(self = [super init]){
        _mID = mId;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"market/market-rest/select-ico-detail";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"id":SAFESTRING(_mID)};
}

@end
