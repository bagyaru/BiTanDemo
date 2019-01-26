//
//  BTRemindModel.h
//  BT
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTRemindModel : BTBaseObject

@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * kind;//种类
@property (nonatomic, copy) NSString * isReminded;//是否已提醒 0未提醒 1已提醒 ,
@property (nonatomic, copy) NSString * legalType;//法币类型 0虚拟货币 1CNY 2USD ,
@property (nonatomic, copy) NSString * remindPrice;//提醒价格
@property (nonatomic, copy) NSString * remindType;//提醒类型 0止盈 1止损 ,
@property (nonatomic, copy) NSString * userRemindId;//
@property (nonatomic, copy) NSString * shiZhi;

@end
