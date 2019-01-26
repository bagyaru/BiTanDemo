//
//  BTSheQuFocusListRequest.m
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSheQuFocusListRequest.h"

@implementation BTSheQuFocusListRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}

-(id)initWithCurrentPage:(NSInteger)currentPage {
    
    self = [super init];
    if (self) {
        
        _pageSize    = BTSmallPagesize;
        _currentPage = currentPage;
    }
    return self;
}
- (NSString *)requestUrl {
    return SheQu_FocusList_Url;
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
