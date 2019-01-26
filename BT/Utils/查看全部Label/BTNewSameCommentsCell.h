//
//  BTNewSameCommentsCell.h
//  BT
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussModel.h"
#import "ZanAndReplayListModel.h"

@protocol BTNewSameCommentsCellDelegate <NSObject>

@optional
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model;
@end
typedef void(^LikeBlock)(DiscussModel *model);
typedef void(^LookAllBlock)(NSInteger index,BOOL isAddLine);
typedef void(^DeletBlock)(DiscussModel *model);
@interface BTNewSameCommentsCell : UITableViewCell

@property (nonatomic, copy) LikeBlock likeBlock;

@property (nonatomic, copy) LookAllBlock lookAllBlock;

@property (nonatomic, copy) DeletBlock deletBlock;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isShowLike;

@property (nonatomic, assign) BOOL isCommentsNumber;

@property (nonatomic, assign) CGFloat heightCell;

@property (nonatomic, weak) id <BTNewSameCommentsCellDelegate> delegate;

+ (instancetype)shareInstance;

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model;

- (void)configWithDiscussModel:(DiscussModel *)model;

@end
