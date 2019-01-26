//
//  MyCollectionRequest.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCollectionRequest.h"

@implementation MyCollectionRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}
-(id)initWithPageIndex:(NSInteger)pageIndex {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}

- (NSString *)requestUrl {
    return MyCollectionlistUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"pageSize": @(_pageSize),
             @"currentPage": @(_currentPage)
             };
}

@end
