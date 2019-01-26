//
//  ChangeNikeNameRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChangeNikeNameRequest.h"

@implementation ChangeNikeNameRequest{
    NSString *_nikeNmae;
    NSString *_introduces;
    NSString *_pageKey;
    
}
- (id)initWithNikeName:(NSString *)nikeName introduces:(NSString*)introduces homePage:(NSString *)pageKey {
    
    self = [super init];
    if (self) {
        _nikeNmae = nikeName;
        _introduces = introduces;
        _pageKey = pageKey;
    }
    return self;
}
- (NSString *)requestUrl {
    return changeNikeNameUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic;
    if(_nikeNmae.length >0){
        dic =  @{@"userName": SAFESTRING(_nikeNmae)};
    }else if(_introduces.length >0){
        dic =  @{@"introductions":SAFESTRING(_introduces)};
    }else if(_pageKey.length >0){
        dic =  @{@"homePageImg":SAFESTRING(_pageKey)};
        
    }
    
    return [self bodyRequestWithDic:dic];
}


@end
