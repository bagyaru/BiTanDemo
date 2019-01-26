//
//  BTFocusUserRequest.m
//  BT
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFocusUserRequest.h"

@implementation BTFocusUserRequest{
    
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
    return Posts_FocusUser_Url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"refId":@(_refId)};
}
@end
