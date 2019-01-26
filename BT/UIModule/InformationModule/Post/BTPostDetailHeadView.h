//
//  BTPostDetailHeadView.h
//  BT
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "BTPostMainListModel.h"

@protocol BTPostDetailHeadViewDelegate <NSObject>

@optional
-(void)BTPostDetailHeadViewHeight:(CGFloat)height;
@end
typedef void(^BTPostDetailHeadViewForwardingBlock)(BTPostMainListModel *model);//转发
typedef void(^BTPostDetailHeadViewLikeBlock)(BTPostMainListModel *model);//点赞
typedef void(^BTPostDetailHeadViewFocusBlock)(BTPostMainListModel *model);//关注
@interface BTPostDetailHeadView : BTView

@property (nonatomic, weak) id <BTPostDetailHeadViewDelegate> delegate;

@property (nonatomic, copy) BTPostDetailHeadViewLikeBlock likeBlock;

@property (nonatomic, copy) BTPostDetailHeadViewForwardingBlock forwardingBlock;

@property (nonatomic, copy) BTPostDetailHeadViewFocusBlock focusBlock;

@property (nonatomic ,strong) BTPostMainListModel *model;

- (CGFloat)getHeadViewHeight;

- (void)configWithDiscussModel:(BTPostMainListModel *)model;

@end
