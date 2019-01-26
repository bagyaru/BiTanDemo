//
//  InformationModuleRequest.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface InformationModuleRequest : BTBaseRequest
- (id)initWithType:(NSString *)type keyword:(NSString *)keyword pageIndex:(NSInteger)pageIndex subType:(NSInteger)subType;
@end
