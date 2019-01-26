//
//  GetCaptchaRequest.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface GetCaptchaRequest : BTBaseRequest

- (id)initWithCountryCode:(NSString *)countryCode account:(NSString *)account sendType:(NSString *)sendType messageType:(NSString *)messageType;
@end
