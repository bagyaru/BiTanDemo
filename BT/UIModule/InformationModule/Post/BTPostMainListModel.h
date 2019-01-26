//
//  BTPostMainListModel.h
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTPostMainListModel : BTBaseObject
@property (nonatomic,assign)NSInteger commentNum;//评论次数
@property (nonatomic,strong)NSString *content;// 帖子内容
@property (nonatomic,strong)NSString *createdAt;//创建日期(时间戳)
@property (nonatomic,assign)BOOL favor;//是否收藏
@property (nonatomic,assign)NSInteger postId;//帖子id
@property (nonatomic,strong)NSArray *images;//图片地址
@property (nonatomic,strong)NSString *issueDate;//发行时间(时间戳)
@property (nonatomic,strong)NSString *timeFmt;//发行时间(时间已处理)
@property (nonatomic,assign)NSInteger likeNum;//点赞次数
@property (nonatomic,assign)BOOL liked;//是否点赞过
@property (nonatomic,assign)NSInteger shareNum;//分享次数
@property (nonatomic,assign)NSInteger status;//状态：1待发布2已发布4下线 ,
@property (nonatomic,strong)NSString *title;//标题
@property (nonatomic,assign)NSInteger type;//类型 3代表转发  100 代表失败
@property (nonatomic,assign)NSInteger viewCount;//观点数
@property (nonatomic,strong)NSString *avatar;//头像
@property (nonatomic,strong)NSString *nickName;//昵称
@property (nonatomic,assign)NSInteger userId;//用户id

@property (nonatomic,strong)BTPostMainListModel *sourcePostModel;//被分享的第一篇帖子
@property (nonatomic,assign)BOOL IsOrNoLookDetail;//是否查看详情

@property (nonatomic,assign)NSInteger shareCount;//分享次数
@property (nonatomic,assign)NSInteger likeCount;//点赞数

@property (nonatomic,assign)BOOL followed;//是否关注
@property (nonatomic,assign)BOOL firstFollowed;//第一次关注后显示取消关注按钮

@property (nonatomic,assign)BOOL hotRecommend;//是否置顶
@property (nonatomic, strong) NSString *remark;//下线提示

@property (nonatomic,strong)NSString *whereVC;//（帖子列表 我的帖子-全部...）

@property (nonatomic, strong) NSString *uuid;//发送失败 本地唯一标识
@property (nonatomic, assign) NSInteger errorType; //1 发帖 2第一次转发 3二次转发

@property (nonatomic,assign)BOOL unread;//未读

@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消

@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end
