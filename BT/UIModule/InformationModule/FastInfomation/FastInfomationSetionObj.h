//
//  FastInfomationSetionObj.h
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface FastInfomationSetionObj : BTBaseObject
@property (nonatomic,strong)NSString *jyjr;//几月几日
@property (nonatomic,strong)NSString *xqj;//星期几
@property (nonatomic,strong)NSString *todayAndYesterday;//今天或昨天
@property (nonatomic,strong)NSMutableArray *fastInfoArray;//当天下的数据
@end
