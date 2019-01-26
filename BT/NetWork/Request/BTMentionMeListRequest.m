//
//  BTMentionMeListRequest.m
//  BT
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMentionMeListRequest.h"

@implementation BTMentionMeListRequest{
    
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
    return MentionMeListUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument{
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return dic;
}

@end
