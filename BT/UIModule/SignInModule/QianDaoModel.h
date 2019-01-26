//
//  QianDaoModel.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QianDaoModel : NSObject

/**签到的第几天*/
@property (nonatomic,assign) NSInteger day;
/**签到的额外奖励*/
@property (nonatomic,assign) NSInteger num;
/**当天签到的奖励数值*/
@property (nonatomic,assign) NSInteger signNum;

@end
