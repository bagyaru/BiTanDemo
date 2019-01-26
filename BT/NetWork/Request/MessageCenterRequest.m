
//
//  MessageCenterRequest.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageCenterRequest.h"

@implementation MessageCenterRequest{
    
    NSInteger _pageSize;
    NSInteger _currentPage;
}
-(id)initWithMesageCenter:(NSInteger)pageIndex {
    
    self = [super init];
    if (self) {
        
        _pageSize = BTSmallPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return MessagecenterListUrl;
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
