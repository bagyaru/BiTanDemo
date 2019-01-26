//
//  BTExceptionalTPRequest.h
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTExceptionalTPRequest : BTBaseRequest
-(id)initWithPostId:(NSInteger)postId type:(NSInteger)type num:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
