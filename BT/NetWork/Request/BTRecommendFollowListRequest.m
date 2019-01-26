//
//  BTRecommendFollowListRequest.m
//  BT
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTRecommendFollowListRequest.h"

@implementation BTRecommendFollowListRequest
{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithCurrentPage:(NSInteger)currentPage {
    
    self = [super init];
    if (self) {
        
        _pageSize    = 5;
        _currentPage = currentPage;
    }
    return self;
}
- (NSString *)requestUrl {
    return @"oauth/oauth-rest/recommendFollowList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}

@end
