//
//  BTPostDetailRequest.m
//  BT
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostDetailRequest.h"

@implementation BTPostDetailRequest{
    
    NSString *_detailID;
    
}
-(id)initWithDetailID:(NSString *)detailID {
    
    self = [super init];
    if (self) {
        
        _detailID = detailID;
        
    }
    return self;
}

- (NSString *)requestUrl {
    return Posts_List_Detail_Url;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"postId": _detailID
             };
}


@end
