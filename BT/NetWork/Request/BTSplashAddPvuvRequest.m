//
//  BTSplashAddPvuvRequest.m
//  BT
//
//  Created by admin on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSplashAddPvuvRequest.h"

@implementation BTSplashAddPvuvRequest{
    
    NSInteger _dataType;
    NSInteger _splashId;
}

-(id)initWithDataType:(NSInteger)dataType splashId:(NSInteger)splashId {
    
    self = [super init];
    if (self) {
        
        _dataType = dataType;
        _splashId = splashId;
    }
    return self;
}
- (NSString *)requestUrl {
    return SPLASH_ADD_PVUV;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"dataType":@(_dataType),@"splashId":@(_splashId)};
    return [self bodyRequestWithDic:dic];
}


@end
