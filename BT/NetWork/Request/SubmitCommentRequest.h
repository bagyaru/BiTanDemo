//
//  SubmitCommentRequest.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface SubmitCommentRequest : BTBaseRequest

- (instancetype)initWithRefId:(NSString *)refId refType:(NSInteger)refType refUserId:(NSInteger)refUserId content:(NSString *)content;

@end
