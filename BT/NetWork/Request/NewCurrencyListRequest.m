//
//  NewCurrencyListRequest.m
//  BT
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewCurrencyListRequest.h"

@implementation NewCurrencyListRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithNewCurrencyList:(NSInteger)pageIndex {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return CONCEPT_NEW_CURRENCY;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
}

@end
