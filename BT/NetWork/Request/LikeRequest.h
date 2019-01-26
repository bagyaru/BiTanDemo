//
//  LikeRequest.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface LikeRequest : BTBaseRequest

- (instancetype)initWithLikeRefId:(NSString *)likeRefId likeRefType:(NSInteger)likeRefType likeStatus:(NSInteger)likeStatus likedUserId:(NSInteger)likedUserId;

@end
