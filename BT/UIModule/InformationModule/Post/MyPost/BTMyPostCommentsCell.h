//
//  BTMyPostCommentsCell.h
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussModel.h"

@protocol BTMyPostCommentsCellDelegate <NSObject>

@optional
-(void)BTMyPostCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model;
@end
typedef void(^LikeBlock)(DiscussModel *model);
typedef void(^LookAllBlock)(NSInteger index,BOOL isAddLine);
typedef void(^DeletBlock)(DiscussModel *model);
@interface BTMyPostCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelLike;

@property (weak, nonatomic) IBOutlet UIView *commentsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSource;

@property (weak, nonatomic) IBOutlet UILabel *labelSource;

@property (nonatomic, copy) LikeBlock likeBlock;

@property (nonatomic, copy) LookAllBlock lookAllBlock;

@property (nonatomic, copy) DeletBlock deletBlock;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat heightCell;

@property (nonatomic, weak) id <BTMyPostCommentsCellDelegate> delegate;

+ (instancetype)shareInstance;

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model;

- (void)configWithDiscussModel:(DiscussModel *)model;
@end
