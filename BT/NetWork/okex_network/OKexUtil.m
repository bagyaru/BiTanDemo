//
//  OKexUtil.m
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OKexUtil.h"

@implementation OKexUtil


+ (NSString *)getGetUrlWithUrl:(NSString *)url params:(NSDictionary *)params{
    NSDictionary *dic = params;
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:url];
    
    for(int i=0; i<dic.allKeys.count; i++){
        NSString *key = dic.allKeys[i];
        if(i == 0){
            [string appendFormat:@"?%@=%@",key,dic[key]];
        }else{
            [string appendFormat:@"&%@=%@",key,dic[key]];
        }
    }
    
    return string;
}

+ (NSString*)md532Upper:(NSString *)str{
    return [[str md5String] uppercaseString];
}
@end
