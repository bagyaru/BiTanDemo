//
//  BTContactUsModel.h
//  BT
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTContactUsModel : BTBaseObject

@property (nonatomic,assign) NSInteger opType;

@property (nonatomic,copy)   NSString *nameCN;

@property (nonatomic,copy)   NSString *nameEN;

@property (nonatomic,copy)   NSString *urlHead;

@property (nonatomic,copy)   NSString *value;
@end

NS_ASSUME_NONNULL_END
