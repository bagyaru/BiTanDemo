//
//  XianHuoDetailHangQingRequest.m
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoDetailHangQingRequest.h"

@implementation XianHuoDetailHangQingRequest{
    
    NSString *_exchangeCode;
}
-(id)initWithExchangeCode:(NSString *)exchangeCode {
    
    self = [super init];
    if (self) {
        
        _exchangeCode = exchangeCode;
       
    }
    return self;
}

- (NSString *)requestUrl {
    return XianHuoDetailHangQingUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"exchangeCode": _exchangeCode
             };
}

@end
