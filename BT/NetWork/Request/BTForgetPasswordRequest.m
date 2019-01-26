//
//  BTForgetPasswordRequest.m
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTForgetPasswordRequest.h"

@implementation BTForgetPasswordRequest{
    
     NSString *_account;
     NSString *_password;
     NSString *_captcha;
}
- (id)initWithAccount:(NSString *)account password:(NSString *)password captcha:(NSString *)captcha {
    
    self = [super init];
    if (self) {
        _account  = account;
        _password = password;
        _captcha  = captcha;
    }
    return self;
}
-(NSString *)requestUrl {
    return FORGOT_PASSWPRD_URL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{
             @"account":_account,
             @"password":_password,
             @"captcha":_captcha
             };
}

@end
