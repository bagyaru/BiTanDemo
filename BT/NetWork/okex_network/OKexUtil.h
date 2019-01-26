//
//  OKexUtil.h
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKexUtil : NSObject

//
+ (NSString *)getGetUrlWithUrl:(NSString *)url params:(NSDictionary *)params;

//返回32位大写的md5
+ (NSString*)md532Upper:(NSString*)str;


@end
