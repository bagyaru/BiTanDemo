//
//  InfomationCollectionRequest.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InfomationCollectionRequest.h"

@implementation InfomationCollectionRequest{
    NSInteger _refType;
    NSString *_refId;
    BOOL      _favor;
}

- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId favor:(BOOL)favor{
    self = [super init];
    if (self) {
        _refType = refType;
        _refId   = refId;
        _favor   = favor;
    }
    return self;
}
- (NSString *)requestUrl {
    return InfomationCollectionUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"refType":@(_refType),@"refId":_refId,@"favor":@(_favor)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    return @{
             @"userFavorsRequest":@{@"refType":@(_refType),
                                    @"refId":_refId,
                                    @"favor":@(_favor)}
             };
}


@end
