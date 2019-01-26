//
//  BTExceptionalTPRequest.m
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExceptionalTPRequest.h"

@implementation BTExceptionalTPRequest {
    
    NSInteger _postId;
    NSInteger _type;
    NSInteger _num;
}
-(id)initWithPostId:(NSInteger)postId type:(NSInteger)type num:(NSInteger)num {
    
    self = [super init];
    if (self) {
        
        _postId = postId;
        _type   = type;
        _num    = num;
    }
    return self;
}
- (NSString *)requestUrl {
    return Exceotional_TP_Url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    NSDictionary *dict = @{@"postId":@(_postId),@"type":@(_type),@"num":@(_num)};
    NSLog(@"%@",dict);
    return dict;
}
@end
