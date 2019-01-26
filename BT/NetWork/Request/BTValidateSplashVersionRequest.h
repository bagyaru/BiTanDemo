//
//  BTValidateSplashVersionRequest.h
//  BT
//
//  Created by admin on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTValidateSplashVersionRequest : BTBaseRequest
- (instancetype)initWithSplashVersion:(NSInteger)splashVersion splashId:(NSInteger)splashId;
@end
