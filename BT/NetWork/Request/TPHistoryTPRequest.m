//
//  TPHistoryTPRequest.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TPHistoryTPRequest.h"

@implementation TPHistoryTPRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTPagesize;
        _currentPage = index;
    }
    return self;
}
- (NSString *)requestUrl {
    return TP_HISTORYGETTP;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}


@end
