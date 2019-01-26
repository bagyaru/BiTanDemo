//
//  BTDeletPostRequest.m
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeletPostRequest.h"

@implementation BTDeletPostRequest{
    NSInteger _commentId;
}

- (id)initWithCommentId:(NSInteger)commentId{
    self = [super init];
    if (self) {
        _commentId = commentId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"postId":@(_commentId)};
}

- (NSString *)requestUrl{
    return Posts_List_Delet_Url;
}


@end
