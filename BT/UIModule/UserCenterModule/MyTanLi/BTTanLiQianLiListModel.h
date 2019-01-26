//
//  BTTanLiQianLiListModel.h
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTTanLiQianLiListModel : BTBaseObject
/**签到的第几天*/
@property (nonatomic,assign)NSInteger day;
/**额外奖励数值 */
@property (nonatomic,assign)NSInteger extraReward;
/**签到奖励数值*/
@property (nonatomic,assign)NSInteger reward;
@end
