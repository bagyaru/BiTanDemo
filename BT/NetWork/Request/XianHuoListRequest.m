//
//  XianHuoListRequest.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoListRequest.h"

@implementation XianHuoListRequest{
    
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
    return XianHuoListUrl;
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
             @"exchangePageParamVO":@{@"pageSize":@(_pageSize),
                                     @"pageIndex":@(_currentPage)}
             };
}
@end
