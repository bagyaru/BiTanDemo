//
//  LikeRequest.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LikeRequest.h"

@implementation LikeRequest{
    NSString *_likeRefId;
    NSInteger _likeRefType;
    NSInteger _likeStatus;
    NSInteger _likedUserId;
}


- (instancetype)initWithLikeRefId:(NSString *)likeRefId likeRefType:(NSInteger)likeRefType likeStatus:(NSInteger)likeStatus likedUserId:(NSInteger)likedUserId{
    self = [super init];
    if (self) {
        _likeRefId = likeRefId;
        _likeRefType = likeRefType;
        _likeStatus = likeStatus;
        _likedUserId = likedUserId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return LIKE_URL;
}

- (id)requestArgument{
    return @{@"likeRefId":_likeRefId,@"likeRefType":@(_likeRefType),@"likeStatus":@(_likeStatus),@"likedUserId":@(_likedUserId)};
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"likeRefId":_likeRefId,@"likeRefType":@(_likeRefType),@"likeStatus":@(_likeStatus),@"likedUserId":@(_likedUserId)};
   return  [self bodyRequestWithDic:dic];
}

@end
