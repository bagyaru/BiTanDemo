//
//  BTBaseRequest.h
//  BT
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//
#import <YTKNetwork/YTKNetwork.h>

@class BTBaseRequest;

typedef void(^BTRequestCompletionBlock)(__kindof BTBaseRequest *request);


@interface BTBaseRequest : YTKRequest

- (NSURLRequest *)bodyRequestWithDic:(id)dic;
//自定义属性值
@property(nonatomic,assign)BOOL isSuccess;//是否成功
@property (nonatomic, strong) NSString *ServerTime;
@property (nonatomic, assign) long code;
@property (nonatomic,copy) NSString * resultMsg;//服务器返回的信息
@property (nonatomic,copy) id data;//服务器返回的数据 已解密
@property(nonatomic,assign)BOOL hasNext;//是否有下一页
@property(nonatomic,assign)NSInteger totalPage;//总共几页



@property (nonatomic,assign) BOOL isShowMessage;

- (void)requestWithCompletionBlockWithSuccess:(BTRequestCompletionBlock)success failure:(BTRequestCompletionBlock)failure;
@end

