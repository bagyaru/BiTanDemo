//
//  NewsRequest.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsRequest.h"

@implementation NewsRequest{
    NSInteger _type;
    NSString *_keyword;
    BOOL _excludeBanner;
    NSInteger _currentPage;
    NSInteger _pageSize;
}

- (instancetype)initWithType:(NSInteger)type keyword:(NSString *)keyword excludeBanner:(BOOL)excludeBanner currentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize{
    self = [super init];
    if (self) {
        _type = type;
        _keyword = keyword;
        _excludeBanner = excludeBanner;
        _currentPage = currentPage;
        _pageSize = pageSize;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return NEWS_URL;
}

- (id)requestArgument{
    return @{@"type":@(_type),@"keyword":_keyword,@"excludeBanner":@(_excludeBanner),@"lang":@"",@"currentPage":@(_currentPage),@"pageSize":@(_pageSize)};
}

@end
