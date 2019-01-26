//
//  GetCaptchaRequest.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GetCaptchaRequest.h"

@implementation GetCaptchaRequest{
    NSString *_countryCode;
    NSString *_account;
    NSString *_sendType;
    NSString *_messageType;
}
-(id)initWithCountryCode:(NSString *)countryCode account:(NSString *)account sendType:(NSString *)sendType messageType:(NSString *)messageType {
    
    self = [super init];
    if (self) {
        _countryCode = countryCode;
        _account = account;
        _sendType = sendType;
        _messageType = messageType;
    }
    return self;
}
- (NSString *)requestUrl {
    return GetYZM;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"countryCode": _countryCode,
             @"account": _account,
             @"sendType": _sendType,
             @"messageType": _messageType
             };
}
@end
