//
//  THFVersionObj.h
//  淘海房
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "BTBaseObject.h"

@interface THFVersionObj : BTBaseObject
@property (nonatomic,assign)NSInteger buildVersion;//构建版本号 通过该字段判断是否更新(与本地定义的版本号对比 大于本地的表示有更新)
@property (nonatomic,strong)NSString *createdAt;//
@property (nonatomic,strong)NSString *descriptionStr;//更新内容
@property (nonatomic,strong)NSString *device;//
@property (nonatomic,strong)NSString *downloadUrl;//apk下载地址
@property (nonatomic,assign)NSInteger forceUpdate;//1：表示强制更新(前提是buildVersion>本地定义的版本号)
@property (nonatomic,strong)NSString *issueDate;//发布时间
@property (nonatomic,strong)NSString *releaseVersion;//分布版本号

@end
