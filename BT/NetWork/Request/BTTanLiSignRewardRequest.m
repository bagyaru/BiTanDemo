//
//  BTTanLiSignRewardRequest.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTanLiSignRewardRequest.h"

@implementation BTTanLiSignRewardRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return TP_SIGNREWARD;
}
@end
