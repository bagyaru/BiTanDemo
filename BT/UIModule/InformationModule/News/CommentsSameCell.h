//
//  CommentsSameCell.h
//  BT
//
//  Created by admin on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussModel.h"
#import "ZanAndReplayListModel.h"
@protocol CommentsSameCellDelegate <NSObject>
//cell高度
//-(void)CommentsSameCellWith:(NSIndexPath *)indexPath withCellHeight:(CGFloat)height;

@optional
- (void)CommentsSameCellCopyLableWith:(NSString *)commentID userName:(NSString *)name;
@end

typedef void(^LikeBlock)(DiscussModel *model);

@interface CommentsSameCell : UITableViewCell

@property (nonatomic, copy) LikeBlock likeBlock;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isShowLike;

@property (nonatomic, weak) id <CommentsSameCellDelegate> delegate;

+ (instancetype)shareInstance;

- (void)configWithDiscussModel:(DiscussModel *)model;

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model;

- (void)configWithZanAndReplayListModel:(ZanAndReplayListModel *)model;

+ (CGFloat)cellHeightWithZanAndReplayListModel:(ZanAndReplayListModel *)model;
@end
