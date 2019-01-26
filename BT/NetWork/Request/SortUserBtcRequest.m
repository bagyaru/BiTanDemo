//
//  SortUserBtcRequest.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SortUserBtcRequest.h"

@implementation SortUserBtcRequest{
    NSArray *_userCurrencyVOList;
}

- (id)initWithUserCurrencyVOList:(NSArray *)userCurrencyVOList{
    self = [super init];
    if (self) {
        _userCurrencyVOList = userCurrencyVOList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return SORTUSERBTC_URL;
}

- (id)requestArgument{
    return @{@"userCurrencyVOList":_userCurrencyVOList};
}

- (NSURLRequest *)buildCustomUrlRequest{
   return [self bodyRequestWithDic:@{@"userCurrencyVOList":_userCurrencyVOList}];
}
@end
