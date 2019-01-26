//
//  BTMyTPModel.h
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTMyTPModel : BTBaseObject
/**今日币力*/
@property (nonatomic,assign)NSInteger todayCoin;
/**用户总币力*/
@property (nonatomic,assign)NSInteger totalCoin;
@end
