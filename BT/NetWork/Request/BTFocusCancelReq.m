//
//  BTFocusCancelReq.m
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFocusCancelReq.h"

@implementation BTFocusCancelReq{
    
    NSInteger _refId;
}

-(id)initWithRefId:(NSInteger)refId {
    
    self = [super init];
    if (self) {
        
        _refId    = refId;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"oauth/oauth-rest/unFollow";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"refId":@(_refId)};
}
@end
