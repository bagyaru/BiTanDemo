//
//  BTAitMeListModel.h
//  BT
//
//  Created by admin on 2018/10/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"
#import "BTPostMainListModel.h"
#import "BTAitMeCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTAitMeListModel : BTBaseObject
@property (nonatomic,assign)NSInteger messageId;
@property (nonatomic,assign)BOOL unread;
@property (nonatomic,strong)BTPostMainListModel *postModel;
@property (nonatomic,strong)BTAitMeCommentModel *commentModel;
@end

NS_ASSUME_NONNULL_END
