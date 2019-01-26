//
//  BTICOListModel.h
//  BT
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTICOListModel : BTBaseObject

@property (nonatomic, copy) NSString * collectEndTime;
@property (nonatomic, copy) NSString * collectProgress;
@property (nonatomic, copy) NSString * icoCode;
@property (nonatomic, copy) NSString * icoIcon;
@property (nonatomic, copy) NSString *icoSignboard;
@property (nonatomic, copy) NSString * icoSignboardEn;
@property (nonatomic, copy) NSString * needIcoSignboard;
@property (nonatomic, strong) NSNumber *mID;



@end
