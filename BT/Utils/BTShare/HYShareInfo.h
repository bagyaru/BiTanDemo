//
//  HYShareInfo.h
//  shareSDKDemo
//
//  Created by haiyun on 16/6/5.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    /**
     *  平台类型
     */
    HYPlatformTypeSinaWeibo = 2,          /**< 新浪微博 */
    HYPlatformTypeQQSpace = 3,            /**< QQ空间 */
    HYPlatformTypeWeixiSession = 0,      /**< 微信好友 */
    HYPlatformTypeWeixiTimeline = 1,     /**< 微信朋友圈 */
    HYPlatformTypeQQ = 5,                /**< QQ */
    HYPlatformTypeAny = 99                /**< 任意平台 */
}
HYPlatformType;

@interface HYShareInfo : NSObject

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, HYShareDKContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    HYShareDKContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    HYShareDKContentTypeText         = 1,
    
    /**
     *  图片
     */
    HYShareDKContentTypeImage        = 2,
    
    /**
     *  网页
     */
    HYShareDKContentTypeWebPage      = 3,

    
};

/** @brief 分享内容的方式 */
@property (nonatomic, assign) HYShareDKContentType shareType;

/** @brief 分享方式 */
@property (nonatomic, assign) HYPlatformType type;

/**
 @brief 分享的链接
 @discussion QQ、QQ空间、微信需要。(新浪微博可以使用processUrl方法拼接到content中)
 */
@property (nonatomic,copy) NSString *url;

/**
 @brief 分享的内容
 @discussion 都要
 */
@property (nonatomic,copy) NSString *content;

/**
 @brief 需要分享的标题
 @discussion QQ、QQ空间、微信需要。(title不能为空)
 */
@property (nonatomic,copy) NSString *title;

/**
 @brief 需要分享的图片地址
 @discussion 都可以用，可以为空
 */
@property (nonatomic,copy) NSString *image;

@property (nonatomic,strong) UIImage *images;
/**
 @brief 给url增加utm_medium参数，表明是哪个渠道来的。
 同时由于新浪微博不支持url，所以会将url拼到content中(如果content本身有url就不会拼了)。
 @discussion
 对应utm_medium参数值：
 @(HYThirdPartySinaWeibo) : @"sinaweibo",
 @(HYThirdPartyQQSpace) : @"qqspace",
 @(HYThirdPartyWeixiSession) : @"weixin",
 @(HYThirdPartyWeixiTimeline) : @"pengyouquan",
 @(HYThirdPartyQQ) : @"qq"};
 */
- (void)processUrl;


@end
