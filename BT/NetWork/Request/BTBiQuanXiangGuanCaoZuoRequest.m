//
//  BTBiQuanXiangGuanCaoZuoRequest.m
//  BT
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBiQuanXiangGuanCaoZuoRequest.h"

@implementation BTBiQuanXiangGuanCaoZuoRequest{
   
    NSInteger _articleId;
    NSInteger _articleInfoType;
   
}

- (instancetype)initWithArticleId:(NSInteger)articleId articleInfoType:(NSInteger)articleInfoType{
    self = [super init];
    if (self) {
        _articleId = articleId;
        _articleInfoType = articleInfoType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return RecordArticleInfoUrl;
}

- (id)requestArgument{
    NSDictionary *dic =  @{@"articleInfoType":@(_articleInfoType),@"articleId":@(_articleId)};
    return dic;
}
@end
