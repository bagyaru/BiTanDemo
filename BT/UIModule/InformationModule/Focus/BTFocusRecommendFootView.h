//
//  BTFocusRecommendFootView.h
//  BT
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTView.h"
#import "BTBatchFollowRequest.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^FocusAllBlock)(BOOL isFocusAll);//全部关注/取消
typedef void(^InABatchBlock)(void);//全部关注/取消
@interface BTFocusRecommendFootView : BTView

@property (nonatomic, copy) FocusAllBlock focusAllBlock;
@property (nonatomic, copy) InABatchBlock inABatchBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHYP;
@property (weak, nonatomic) IBOutlet BTLabel *labelHYP;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAllRecommend;
@property (weak, nonatomic) IBOutlet BTLabel *labelAllRecommend;
@property (nonatomic,strong)NSMutableArray *recommendIds;
@property (nonatomic,assign)BOOL isFocusAll;
@end

NS_ASSUME_NONNULL_END
