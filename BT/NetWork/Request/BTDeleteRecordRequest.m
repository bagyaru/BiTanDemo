//
//  BTDeleteRecordRequest.m
//  BT
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeleteRecordRequest.h"

@implementation BTDeleteRecordRequest{
    BTRecordModel *_model;
}

- (instancetype)initWithRecord:(BTRecordModel *)model{
    if(self =[super init]){
        _model = model;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return DELETE_RECORF_URL;
}
- (id)requestArgument{
    return @{
             @"bookkeepingId":SAFESTRING(_model.bookkeepingId)
             };
}
@end
