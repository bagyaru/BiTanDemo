//
//  BTPostMainListRequest.m
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostMainListRequest.h"

@implementation BTPostMainListRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTSmallPagesize;
        _currentPage = index;
    }
    return self;
}
- (NSString *)requestUrl {
    return Posts_List_Url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    
    NSDictionary *dic;
    if (self.type == 1) {
        
        dic =  @{@"pageSize":@(_pageSize),@"currentPage":@(_currentPage)};
    }else {
        
        dic =  @{@"pageSize":@(_pageSize),@"currentPage":@(_currentPage),@"original":@(self.original)};
    }
    return [self bodyRequestWithDic:dic];
}

@end
