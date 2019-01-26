//
//  InfomationDetailRequest.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InfomationDetailRequest.h"

@implementation InfomationDetailRequest{
    
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
    return NewInfoDetail;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    if (self.bigType == 6) {
       
        return @{
                 @"id": _detailID,
                 @"type": @(6)
                 };
    }else {
    return @{
             @"id": _detailID
             };
    }
}


@end
