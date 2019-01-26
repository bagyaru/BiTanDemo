//
//  BTHelpCenterListApi.m
//  BT
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTHelpCenterListApi.h"

@implementation BTHelpCenterListApi{
    
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
    return @"oauth/oauth-rest/helpCenter-list";
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
