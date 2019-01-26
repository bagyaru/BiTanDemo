//
//  BTUserPermissonModel.h
//  BT
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTUserPermissonModel : BTBaseObject
@property (nonatomic, assign) BOOL banned;
@property (nonatomic, assign) BOOL fenHao;
@property (nonatomic, assign) BOOL postLimit;
@property (nonatomic, assign) NSInteger postLimitNum;

@end
