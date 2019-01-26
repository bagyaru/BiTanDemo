//
//  XianHuoDetailRequest.m
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoDetailRequest.h"

@implementation XianHuoDetailRequest{
    
    NSInteger _exchangeId;
   
}
-(id)initWithExchangeId:(NSInteger)exchangeId {
    
    self = [super init];
    if (self) {
        
        _exchangeId = exchangeId;
        
    }
    return self;
}
- (NSString *)requestUrl {
    return XianHuoDetailUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"exchangeId":@(_exchangeId)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    return @{
             @"searchExchangeParamVO":@{@"exchangeId":@(_exchangeId)}
             };
}

@end
