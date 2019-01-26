//
//  DiscussCell.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussModel.h"
#import "ZanAndReplayListModel.h"
typedef void(^LikeBlock)(DiscussModel *model);

@interface DiscussCell : UITableViewCell

@property (nonatomic, copy) LikeBlock likeBlock;

+ (instancetype)shareInstance;

- (void)configWithDiscussModel:(DiscussModel *)model;

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model;

- (void)configWithZanAndReplayListModel:(ZanAndReplayListModel *)model;

+ (CGFloat)cellHeightWithZanAndReplayListModel:(ZanAndReplayListModel *)model;

@end
