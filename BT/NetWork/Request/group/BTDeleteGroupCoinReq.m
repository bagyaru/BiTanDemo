//
//  BTDeleteGroupCoinReq.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeleteGroupCoinReq.h"

@implementation BTDeleteGroupCoinReq{
    BOOL _allDelete;
    NSArray *_list;
    NSString *_groupName;
}

///market-rest/del-user-extend-group

- (instancetype)initWithAllDelete:(BOOL)allDelete list:(NSArray*)list groupName:(NSString*)groupName{
    if(self = [super init]){
        _allDelete = allDelete;
        _list  = list;
        _groupName = groupName;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/del-user-extend-group";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"allDel":@(_allDelete),@"dtoList":_list,@"groupName":SAFESTRING(_groupName)};
    return [self bodyRequestWithDic:dic];
    
}


@end
