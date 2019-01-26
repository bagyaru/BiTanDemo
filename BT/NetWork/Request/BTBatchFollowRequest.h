//
//  BTBatchFollowRequest.h
//  BT
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTBatchFollowRequest : BTBaseRequest
- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
