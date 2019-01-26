//
//  BTRecommendFollowListRequest.h
//  BT
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTRecommendFollowListRequest : BTBaseRequest
-(id)initWithCurrentPage:(NSInteger)currentPage;
@end

NS_ASSUME_NONNULL_END
