//
//  BTMyPostRequest.m
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostRequest.h"

@implementation BTMyPostRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
    BOOL      _original;
}

-(id)initWithCurrentPage:(NSInteger)currentPage original:(BOOL)original {
    
    self = [super init];
    if (self) {
        
        _pageSize    = BTPagesize;
        _currentPage = currentPage;
        _original    = original;
    }
    return self;
}
- (NSString *)requestUrl {
    return Posts_MyPosts_List_Url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    
    NSDictionary *dic;
    if (!_original) {
        
        dic =  @{@"pageSize":@(_pageSize),@"currentPage":@(_currentPage)};
    }else {
        
        dic =  @{@"pageSize":@(_pageSize),@"currentPage":@(_currentPage),@"original":@(_original)};
    }
    return [self bodyRequestWithDic:dic];
}


@end
