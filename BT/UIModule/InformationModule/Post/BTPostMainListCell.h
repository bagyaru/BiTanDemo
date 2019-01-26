//
//  BTPostMainListCell.h
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPostMainListModel.h"

typedef void(^LikeBlock)(BTPostMainListModel *model);//点赞
typedef void(^CommentsBlock)(BTPostMainListModel *model);//评论
typedef void(^ForwardingBlock)(BTPostMainListModel *model);//转发
typedef void(^DeletPostBlock)(BTPostMainListModel *model);//转发
typedef void(^SendPostAgainBlock)(BTPostMainListModel *model);//重发失败帖子
typedef void(^LookAllBlock)(BTPostMainListModel *model);//查看详情
typedef void(^FocusPostUserBlock)(BTPostMainListModel *model);//重发失败帖子
@interface BTPostMainListCell : UITableViewCell

@property (nonatomic, copy) LookAllBlock lookAllBlock;

@property (nonatomic, copy) LikeBlock likeBlock;

@property (nonatomic, copy) CommentsBlock commentsBlock;

@property (nonatomic, copy) ForwardingBlock forwardingBlock;

@property (nonatomic, copy) DeletPostBlock deletPostBlock;

@property (nonatomic, copy) SendPostAgainBlock sendPostAgainBlock;

@property (nonatomic, copy) FocusPostUserBlock focusPostUserBlock;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat heightCell;

@property (nonatomic, assign) BOOL IsShowDeletBtn;
@property (nonatomic, assign) BOOL isCollcetDelete;

+ (instancetype)shareInstance;

+ (CGFloat)cellHeightWithDiscussModel:(BTPostMainListModel *)model;

- (void)configWithDiscussModel:(BTPostMainListModel *)model;
@end
