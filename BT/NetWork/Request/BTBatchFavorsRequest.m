//
//  BTBatchFavorsRequest.m
//  BT
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBatchFavorsRequest.h"

@implementation BTBatchFavorsRequest{
    NSMutableArray *_dict;
}

- (instancetype)initWithDict:(NSMutableArray *)dict{
    if(self = [super init]){
        _dict = dict;
    }
    return self;
}

- (NSString *)requestUrl {//批量收藏/取消收藏
    return @"oauth/oauth-rest/batchFavors";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSMutableArray *dic = _dict ;
    return [self bodyRequestWithDic:dic];
}


@end
