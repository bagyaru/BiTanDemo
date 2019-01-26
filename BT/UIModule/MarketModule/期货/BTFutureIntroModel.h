//
//  BTFutureIntroModel.h
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTFutureIntroModel : BTBaseObject

@property (nonatomic, strong) NSArray *detailInfo;
@property (nonatomic, copy)NSString *explain;
@property (nonatomic, copy) NSString *explainTitle;
@property (nonatomic, copy) NSString * memo;
@property (nonatomic, copy) NSString * memoTitle;

@end

