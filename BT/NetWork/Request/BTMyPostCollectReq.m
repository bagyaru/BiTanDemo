//
//  BTMyPostCollectReq.m
//  BT
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostCollectReq.h"

@implementation BTMyPostCollectReq{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithCurrentPage:(NSInteger)currentPage {
    
    self = [super init];
    if (self) {
        
        _pageSize    = BTPagesize;
        _currentPage = currentPage;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"knowledge/posts/myFavorPostList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"currentPage":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}


@end
