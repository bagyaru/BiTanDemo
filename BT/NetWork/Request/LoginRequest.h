//
//  LoginRequest.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface LoginRequest : BTBaseRequest

- (id)initWithUsername:(NSString *)mobile password:(NSString *)captcha inviteCode:(NSString *)inviteCode CountryCode:(NSString *)countryCode;

@end
