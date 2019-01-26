//
//  DiscussModel.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussModel : NSObject<YYModel>

@property (nonatomic, strong) NSString *commentId;//评论编号

@property (nonatomic, strong) NSString *content;//评论内容

@property (nonatomic, strong) NSDate *createTime;//创建时间

@property (nonatomic, assign) NSInteger likeCount;//点赞数量

@property (nonatomic, assign) BOOL liked;//是否点过赞

@property (nonatomic, strong) NSString *refId;//关联编号

@property (nonatomic, assign) NSInteger refType;//关联类型

@property (nonatomic, strong) NSString *userAvatar;//用户头像

@property (nonatomic, assign) NSInteger userId;//用户编号

@property (nonatomic, strong) NSString *userName;//用户昵称

@property (nonatomic, strong) NSString *timeFormat;//

@property (nonatomic, strong) NSMutableArray *commentsArray;//被回复的数组

@property (nonatomic, assign) BOOL isOrNo;//

@property (nonatomic, assign) CGFloat cellHeight;//cell高度

@property (nonatomic,assign)BOOL IsOrNoLookDetail;//是否查看详情

@property (nonatomic, assign) NSInteger replyCount;//回复数

@property (nonatomic, strong) NSString *refContent;//引用者内容

@property (nonatomic, strong) NSString *refUserName;//引用者昵称

@property (nonatomic, strong) NSDictionary *sourceInfo;//来源信息

@property (nonatomic,assign)  BOOL isLocalModel;//新的点赞或新的评论详情记录到本地的标记

@property (nonatomic,assign)BOOL isAddOneLine;//是否查看详情

@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消

@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end
