//
//  BTCopyLabel.h
//  BT
//
//  Created by admin on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLabel.h"
typedef void (^BTCopyLabelBlock)(NSString *commentID,NSString *userName);
@interface BTCopyLabel : BTLabel <UIGestureRecognizerDelegate>

//回复时 自己的ID
@property (nonatomic,strong) NSString *child_ID;
//回复时 父类的ID
@property (nonatomic,strong) NSString *super_ID;
//回复时 昵称
@property (nonatomic,strong) NSString *userName;

@property (nonatomic,strong) BTCopyLabelBlock copyBlock;

@end
