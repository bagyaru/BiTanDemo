//
//  DeleteUserBtcRequest.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DeleteUserBtcRequest.h"

@implementation DeleteUserBtcRequest{
    NSArray *_delUserCurrencyVOList;
}

- (id)initWithDelUserCurrencyVOList:(NSArray *)delUserCurrencyVOList{
    self = [super init];
    if (self) {
        _delUserCurrencyVOList = delUserCurrencyVOList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return DELETEUSERBTC_URL;
}

- (id)requestArgument{
    return @{@"delUserCurrencyVOList":_delUserCurrencyVOList};
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"delUserCurrencyVOList":_delUserCurrencyVOList};
    return [self bodyRequestWithDic:dic];
}


@end
