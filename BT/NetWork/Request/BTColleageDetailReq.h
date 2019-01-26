//
//  BTColleageDetailReq.h
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTColleageDetailReq : BTBaseRequest
- (id)initWithType:(NSString *)type  pageIndex:(NSInteger)pageIndex guideType:(NSInteger)guideType;
@end

NS_ASSUME_NONNULL_END
