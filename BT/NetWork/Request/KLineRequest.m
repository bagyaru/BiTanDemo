//
//  KLineRequest.m
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "KLineRequest.h"

@implementation KLineRequest{
    NSString *_kind;
    NSInteger _klineType;
    NSString *_exchangeCode;
}

- (instancetype)initWithKind:(NSString *)kind klineType:(NSInteger)klineType exchangeCode:(NSString *)exchangeCode{
    self = [super init];
    if (self) {
        _kind = kind;
        _klineType = klineType;
        _exchangeCode = exchangeCode;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return KLINE_URL;
}

//- (NSInteger)cacheTimeInSeconds{
//    return 300.0f;
//}
- (id)requestArgument{
    
    if([_exchangeCode isEqualToString:k_Net_Code]){
        NSDictionary *d = @{@"kind":_kind,@"klineType":@(_klineType)};
        NSLog(@"%@",d);
        return @{@"kind":_kind,@"klineType":@(_klineType)};
    }else{
        
        NSDictionary *d = @{@"kind":_kind,@"klineType":@(_klineType),@"exchangeCode":SAFESTRING(_exchangeCode)};
        NSLog(@"%@",d);
        return  @{@"kind":_kind,@"klineType":@(_klineType),@"exchangeCode":SAFESTRING(_exchangeCode)};
    }
}

@end
