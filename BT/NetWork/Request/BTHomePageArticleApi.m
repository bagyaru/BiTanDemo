//
//  BTHomePageArticleApi.m
//  BT
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHomePageArticleApi.h"

@implementation BTHomePageArticleApi{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
    BOOL      _original;
    NSInteger _userId;
}

- (id)initWithUserId:(NSInteger)userId currentPage:(NSInteger)currentPage original:(BOOL)original {
    self = [super init];
    if (self) {
        _pageSize    = BTPagesize;
        _currentPage = currentPage;
        _original    = original;
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"knowledge/info/homePageArticleList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic;
    if (!_original) {
        
        dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage),@"userId":@(_userId)};
    }else {
        
        dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage),@"original":@(_original),@"userId":@(_userId)};
    }
    return [self bodyRequestWithDic:dic];
}

@end
