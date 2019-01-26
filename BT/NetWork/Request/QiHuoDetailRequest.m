//
//  QiHuoDetailRequest.m
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoDetailRequest.h"

@implementation QiHuoDetailRequest{
    
    NSString *_FuturesId;
    
}
-(id)initWithFuturesId:(NSString *)FuturesId {
    
    self = [super init];
    if (self) {
        
        _FuturesId = FuturesId;
        
    }
    return self;
}
- (NSString *)requestUrl {
    return QiHuoDetailUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"FuturesId":_FuturesId};
}

@end
