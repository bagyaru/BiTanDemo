//
//  BTOkexTrendApi.h
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTOkexTrendApi : BTBaseRequest

- (instancetype)initWithCode:(NSString*)code type:(NSInteger)type;

@end
