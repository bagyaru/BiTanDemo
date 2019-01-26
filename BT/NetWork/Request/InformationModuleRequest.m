//
//  InformationModuleRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InformationModuleRequest.h"

@implementation InformationModuleRequest{
    NSString *_type;
    NSString *_keyword;
    NSInteger _pageSize;
    NSInteger _currentPage;
    NSInteger _subType;
}
-(id)initWithType:(NSString *)type keyword:(NSString *)keyword pageIndex:(NSInteger)pageIndex subType:(NSInteger)subType{
    
    self = [super init];
    if (self) {
        _type        = type;
        _keyword     = keyword;
        _pageSize    = BTPagesize;
        _currentPage = pageIndex;
        _subType     = subType;
    }
    return self;
}
- (NSString *)requestUrl {
    return InformationModuleUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSDictionary *dict = @{
                           @"type": _type,
                           @"keyword": _keyword,
                           @"pageSize": @(_pageSize),
                           @"currentPage": @(_currentPage),
                           @"subType":@(_subType)
                           };
    NSLog(@"%@",dict);
    return dict;
}

@end
