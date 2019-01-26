//
//  BTExchangeTanliReq.m
//  BT
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeTanliReq.h"

@implementation BTExchangeTanliReq{
    NSInteger _userId;
    NSInteger _num;
}

- (instancetype)initWithUserId:(NSInteger)userId exchangeNum:(NSInteger)num{
    if(self = [super init]){
        _userId = userId;
        _num = num;
    }
    return  self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return  @"oauth/oauth-rest/coin-exchange-reward";
    
}

- (id)requestArgument{
    return @{@"userId":@(_userId),@"num":@(_num)};
}


@end
