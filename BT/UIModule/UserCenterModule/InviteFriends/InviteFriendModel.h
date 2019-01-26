//
//  InviteFriendModel.h
//  BT
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendModel : NSObject

/**邀请码*/
@property (nonatomic,copy) NSString *code;
/**用户邀请人数*/
@property (nonatomic,assign) NSInteger inviteNum;
/**当天释放探力值*/
@property (nonatomic,assign) NSInteger totalCount;
/**当前用户人数*/
@property (nonatomic,assign) NSInteger userNum;
/**用户id*/
@property (nonatomic,assign) NSInteger userId;

@end
