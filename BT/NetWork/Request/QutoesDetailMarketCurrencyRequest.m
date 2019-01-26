//
//  QutoesDetailMarketCurrencyRequest.m
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QutoesDetailMarketCurrencyRequest.h"

@implementation QutoesDetailMarketCurrencyRequest{
    NSString *_kind;
}

- (instancetype)initWithkind:(NSString *)kind{
    self = [super init];
    if (self) {
        _kind = kind;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return QUTOEXDETAILMARKETCURRENCY_URL;
}

- (id)requestArgument{
    return @{@"kind":_kind};
}
@end
