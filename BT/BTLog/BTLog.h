//
//  BTLog.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); [BTLog writeLog:[NSString stringWithFormat:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]];
#define DEBUG_LOG_TO_FILE
#else
#   define DLog(...)
#endif

@interface BTLog : NSObject

+ (void)writeLog:(NSString*)str;

+ (BOOL)removeLogFile;

@end
