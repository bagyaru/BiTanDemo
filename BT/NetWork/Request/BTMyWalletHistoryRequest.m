//
//  BTMyWalletHistoryRequest.m
//  BT
//
//  Created by admin on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyWalletHistoryRequest.h"

@implementation BTMyWalletHistoryRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return USER_WALLET_HISTORY;
}
@end
