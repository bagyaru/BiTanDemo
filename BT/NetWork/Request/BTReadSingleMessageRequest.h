//
//  BTReadSingleMessageRequest.h
//  BT
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTReadSingleMessageRequest : BTBaseRequest
- (instancetype)initWithType:(NSInteger)type messageId:(NSInteger)messageId;
@end

NS_ASSUME_NONNULL_END
