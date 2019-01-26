//
//  BTMyPostCommentsRequest.h
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTMyPostCommentsRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType pageIndex:(NSInteger)pageIndex;
@end
