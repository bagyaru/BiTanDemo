//
//  LCNetworking.h
//  LCNetworking
//
//  Created by lichao on 2017/3/3.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define lang_Language_Zh_Hans  @"zh-Hans"

#define ApplicationId @"applicationId"

#define ApplicationIdValue @"2"

#define ApplicationClientType @"applicationClientType"

#define ApplicationClientTypeValue @"2"

#define langLanguageType  @"lang"

#define legalTendeType    @"legalTende"

#define UserFrom @"userFrom"

#define UserFromValue @"APPSTORE"

#define UserFromValueOther @"APPQIYE"

#define AppVersion @"appVersion"

#define BuildVersion @"buildVersion"

#define AppVersionValue [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);


@interface LCNetworking : NSObject

//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
