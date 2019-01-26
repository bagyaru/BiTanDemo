//
//  BTRemindShutRequest.m
//  BT
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRemindShutRequest.h"

@implementation BTRemindShutRequest{
    BTRemindModel *_model;
}

- (instancetype)initWithRemind:(BTRemindModel*)model{
    if(self =[super init]){
        _model = model;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return USER_REMIND_SHUT;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSString *price =[NSString stringWithFormat:@"%.2f",[SAFESTRING(_model.remindPrice) floatValue]];
    NSDictionary *dic = @{@"isReminded":@([_model.isReminded integerValue]),
                          @"kind":SAFESTRING(_model.kind),
                          @"legalType":@([SAFESTRING(_model.legalType) integerValue]),
                          @"remindPrice":price,
                          @"userRemindId":SAFESTRING(_model.userRemindId),
                          @"remindType":@([SAFESTRING(_model.remindType) integerValue])
                          };
    
    //   ,
    return  [self bodyRequestWithDic:dic];
}

@end
