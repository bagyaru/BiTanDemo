//
//  BTConceptDetailRequest.h
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTConceptDetailRequest : BTBaseRequest

- (instancetype)initWithId:(NSString*)conceptId sortType:(NSInteger)type;
@end
