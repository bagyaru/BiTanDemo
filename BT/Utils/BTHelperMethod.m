//
//  BTHelperMethod.m
//  BT
//
//  Created by apple on 2018/4/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHelperMethod.h"

@implementation BTHelperMethod

+ (NSString*)signStr{
    if(kIsCNY){
        return @"¥";
    }
    return @"$";
}

+ (NSString*)unitOfCoin:(NSString *)coinTypeStr{
    return @"";
}

+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}
@end
