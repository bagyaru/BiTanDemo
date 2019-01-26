//
//  BTColleageDetailReq.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageDetailReq.h"

@implementation BTColleageDetailReq{
    NSString *_type;
    NSInteger _pageSize;
    NSInteger _currentPage;
    NSInteger _guideType;
}

- (instancetype)initWithType:(NSString *)type pageIndex:(NSInteger)pageIndex guideType:(NSInteger)guideType{
    
    self = [super init];
    if (self) {
        _type        = type;
        _pageSize    = BTPagesize;
        _currentPage = pageIndex;
        _guideType     = guideType;
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
                           @"pageSize": @(_pageSize),
                           @"currentPage": @(_currentPage),
                           @"guideType":@(_guideType)
                           };
    NSLog(@"%@",dict);
    return dict;
}


@end
