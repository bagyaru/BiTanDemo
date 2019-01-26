//
//  BTAddGroupCoinReq.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAddGroupCoinReq.h"

@implementation BTAddGroupCoinReq{
    
    BOOL _allDelete;
    NSArray *_list;
    NSString *_groupName;
}

- (instancetype)initWithAllDelete:(BOOL)allDelete list:(NSArray*)list groupName:(NSString*)groupName{
    if(self = [super init]){
        _allDelete = allDelete;
        _list  = list;
        _groupName = groupName;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/save-user-extend-group";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"dtoList":_list,@"groupName":SAFESTRING(_groupName),@"allDel":@(0)};
    return [self bodyRequestWithDic:dic];
}

@end
