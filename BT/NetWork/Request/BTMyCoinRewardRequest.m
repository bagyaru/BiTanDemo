//
//  BTMyCoinRewardRequest.m
//  BT
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyCoinRewardRequest.h"

@implementation BTMyCoinRewardRequest{
    NSInteger _type;
    NSInteger _userid;
}

- (instancetype)initWithType:(NSInteger)type userId:(NSInteger)userId{
    if(self =[super init]){
        _type =type;
        _userid = userId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString*)requestUrl{
    return myCoinRewardUrl;
}


- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"type":@(_type),@"userId":@(_userid)};
    return  [self bodyRequestWithDic:dic];
}

@end
