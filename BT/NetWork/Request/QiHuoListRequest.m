//
//  QiHuoListRequest.m
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoListRequest.h"

@implementation QiHuoListRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}
-(id)initWithXianHuoList:(NSInteger)pageIndex {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return QiHuoListUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"pageSize":@(_pageSize),
                           @"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    return @{
             @"searchFuturesInfoVO":@{@"pageSize":@(_pageSize),
                                      @"pageIndex":@(_currentPage)}
             };
}

@end
