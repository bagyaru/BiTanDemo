//
//  updatePhotoToServiceRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "updatePhotoToServiceRequest.h"

@implementation updatePhotoToServiceRequest{
    
    NSString *_avatarKey;
}
- (id)initWithUsername:(NSString *)avatarKey {
    
    self = [super init];
    if (self) {
        _avatarKey = avatarKey;
       
    }
    return self;
}
-(NSString *)requestUrl {
    return updatePhotoToServiceUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{
             @"avatarKey":_avatarKey
             };
}
@end
