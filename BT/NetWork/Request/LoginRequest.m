//
//  LoginRequest.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginRequest.h"

#import "BTConfig.h"
@implementation LoginRequest{
    NSString *_mobile;
    NSString *_captcha;
    NSString *_inviteCode;
    NSString *_countryCode;
}

- (id)initWithUsername:(NSString *)mobile password:(NSString *)captcha inviteCode:(NSString *)inviteCode CountryCode:(NSString *)countryCode{
    self = [super init];
    if (self) {
        _mobile     = mobile;
        _captcha    = captcha;
        _inviteCode = inviteCode;
        _countryCode= countryCode;
    }
    return self;
}
- (NSString *)requestUrl {
    return LoginUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"mobile":SAFESTRING(_mobile),@"captcha":SAFESTRING(_captcha),@"countryCode":SAFESTRING(_countryCode),@"inviterCode":SAFESTRING(_inviteCode)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    
     NSDictionary *dic =  @{@"mobile":SAFESTRING(_mobile),@"captcha":SAFESTRING(_captcha),@"countryCode":SAFESTRING(_countryCode),@"inviterCode":SAFESTRING(_inviteCode)};
    return @{
             @"loginNoPwdRequest":dic
             };
}

@end
