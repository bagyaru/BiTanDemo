//
//  ChangeNikeNameRequest.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface ChangeNikeNameRequest : BTBaseRequest
- (id)initWithNikeName:(NSString *)nikeName introduces:(NSString*)introduces homePage:(NSString*)pageKey;
@end
