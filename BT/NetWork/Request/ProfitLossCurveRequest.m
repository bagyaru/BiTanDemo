//
//  ProfitLossCurveRequest.m
//  BT
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProfitLossCurveRequest.h"

@interface ProfitLossCurveRequest(){
    NSInteger _currentPage;
    NSInteger _pageSize;
}
@end
@implementation ProfitLossCurveRequest

- (instancetype)initWithCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize{
    if(self =[super init]){
        _currentPage =currentPage;
        _pageSize = pageSize;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return PTOFIT_LOSS_CURVE;
}
- (id)requestArgument{
    return @{@"pageIndex":@(_currentPage),@"pageSize":@(_pageSize)};
}
@end
