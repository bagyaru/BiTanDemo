//
//  InfomationCollectionRequest.h
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface InfomationCollectionRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId favor:(BOOL)favor;
@end
