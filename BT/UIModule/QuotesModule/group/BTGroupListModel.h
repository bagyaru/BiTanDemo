//
//  BTGroupListModel.h
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTGroupListModel : BTBaseObject

@property (nonatomic, copy) NSString * groupName;
@property (nonatomic, assign) NSInteger rank;//排序
@property (nonatomic, assign) NSInteger userGroupId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger isDeleted;
@property (nonatomic, assign) NSInteger updateUserId;
@property (nonatomic, assign) BOOL isSelected;



@end
