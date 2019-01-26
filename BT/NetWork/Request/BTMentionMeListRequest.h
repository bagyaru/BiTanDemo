//
//  BTMentionMeListRequest.h
//  BT
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTMentionMeListRequest : BTBaseRequest
-(id)initWithCurrentPage:(NSInteger)currentPage;
@end

NS_ASSUME_NONNULL_END
