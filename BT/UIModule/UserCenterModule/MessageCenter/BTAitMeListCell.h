//
//  BTAitMeListCell.h
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTAitMeCommentModel.h"
#import "ZJUnFoldView.h"
#import "ZJUnFoldView+Untils.h"
@protocol BTAitMeListCellDelegate <NSObject>

@optional
-(void)BTAitMeListCellCopyLableWithDiscussModel:(BTAitMeCommentModel *)model indexRow:(NSInteger)index;
@end
typedef void(^BTAitMeListLookAllBlock)(NSInteger index,BOOL isAddLine);
typedef void(^BTAitMeListSourceLookAllBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface BTAitMeListCell : UITableViewCell

@property (nonatomic, copy) BTAitMeListLookAllBlock lookAllBlock;

@property (nonatomic, copy) BTAitMeListSourceLookAllBlock sourceLookAllBlock;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat heightCell;

@property (nonatomic, weak) id <BTAitMeListCellDelegate> delegate;

@property (nonatomic ,strong) ZJUnFoldView *unFoldView;

@property (nonatomic ,strong) ZJUnFoldView *sourcePostUnFoldView;

@property (nonatomic ,strong) BTAitMeCommentModel *model;

+ (instancetype)shareInstance;

+ (CGFloat)cellHeightWithDiscussModel:(BTAitMeCommentModel *)model;

- (void)configWithDiscussModel:(BTAitMeCommentModel *)model;
@end

NS_ASSUME_NONNULL_END
