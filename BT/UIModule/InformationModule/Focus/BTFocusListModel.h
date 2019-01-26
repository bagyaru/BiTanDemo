//
//  BTFocusListModel.h
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"
#import "FastInfomationObj.h"
#import "BTPostMainListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTFocusListModel : BTBaseObject
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)BTPostMainListModel *postModel;
@property (nonatomic,strong)FastInfomationObj   *articleModel;
@end

NS_ASSUME_NONNULL_END
