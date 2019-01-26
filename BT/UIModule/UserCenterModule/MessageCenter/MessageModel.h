//
//  MessageModel.h
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger comment;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, assign) NSInteger message;
@property (nonatomic, assign) NSInteger mention;
@end
