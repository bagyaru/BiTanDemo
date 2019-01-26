//
//  BTSaveErrorLogRequest.m
//  BT
//
//  Created by admin on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSaveErrorLogRequest.h"
#import "BTConfig.h"
@implementation BTSaveErrorLogRequest{
    NSString *_apiUrl;
    NSString *_errorMsg;
}

-(id)initWithApiUrl:(NSString *)apiUrl errorMsg:(NSString *)errorMsg{
    self = [super init];
    if (self) {
        _apiUrl = apiUrl;
        _errorMsg = errorMsg;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
- (NSString *)baseUrl {
    
    return BTDomainDev;
}

- (id)requestArgument{
    
//    return @{@"apiUrl":_apiUrl,@"errorMsg":ISNSStringValid(_errorMsg)?_errorMsg:@""};
    if (_errorMsg == nil || [_errorMsg  isKindOfClass:[NSNull class]]) {
        _errorMsg = @"";
    }
    return @{@"apiUrl":_apiUrl,@"errorMsg":_errorMsg};
}

- (NSString *)requestUrl{
    return SavaErrorLogUrl;
}

@end
