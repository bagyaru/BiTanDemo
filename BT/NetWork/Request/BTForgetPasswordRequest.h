//
//  BTForgetPasswordRequest.h
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTForgetPasswordRequest : BTBaseRequest
- (id)initWithAccount:(NSString *)account password:(NSString *)password captcha:(NSString *)captcha;
@end
