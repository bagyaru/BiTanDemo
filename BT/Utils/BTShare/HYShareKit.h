//
//  HYShareKit.h
//  shareSDKDemo
//
//  Created by haiyun on 16/6/5.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYShareInfo;
@interface HYShareKit : NSObject


+(void)registerShareApp;
+ (void)shareInfoWith:(HYShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion;

/**
 *  分享图片到微信好友,图片
 *
 *  @param shareInfo  分享内容
 *  @param  Images 必须存在
 *  @param completion 结果
 */
+ (void)shareImageWeChat:(HYShareInfo *)shareInfo completion:(void (^)(NSString *errorMsg))completion;

//+ (void)shareInfoWithMessage:(NSString *)mesage type:(NSInteger )types completion:(void (^)(NSString *errorMsg))completion;
@end
