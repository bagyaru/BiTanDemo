//
//  CommentDetailObj.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface CommentDetailObj : BTBaseObject
@property (nonatomic,strong)NSString *commentId;
@property (nonatomic,strong)NSString *content;//留言内容
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *refId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userAvatar;
@end
