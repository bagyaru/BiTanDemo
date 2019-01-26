//
//  ZanAndReplayListModel.h
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZanAndReplayListModel : NSObject<YYModel>
@property (nonatomic, strong) NSString *currCommentId;//评论编号
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *likeId;//点赞读取用这个
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *myContent;
@property (nonatomic, strong) NSString *timeFormat;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, assign) NSInteger articleId;//文章id
@property (nonatomic, assign) NSInteger postId;//帖子id
@property (nonatomic, assign) NSInteger type;//1评论2帖子3探报
@property (nonatomic, assign) BOOL isOrNo;
@property (nonatomic, assign) BOOL unread;
@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消
@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end
