//
//  IndomationDetailCommentListRequest.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface IndomationDetailCommentListRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId pageIndex:(NSInteger)pageIndex;
@end