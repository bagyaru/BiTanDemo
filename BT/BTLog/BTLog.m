//
//  BTLog.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLog.h"
#import "Preference.h"

@implementation BTLog


+ (void)writeLog:(NSString*)str
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"logs"];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%03ld.txt" ,(long)[[Preference sharedInstance] readLaunchedTime]]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        
        NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        strVersion = [NSString stringWithFormat:lang_version_build, strVersion, build];
        
        str = [NSString stringWithFormat:@"%@\n%@", strVersion, str];
        //        [self writeLog:strVersion];
    }
    
    NSFileHandle  *outFile;
    NSData *buffer;
    outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    //读取inFile并且将其内容写到outFile中
    
    NSDate *thatDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy年MM月dd日HH:mm:ss.SSS";
    NSString* strDate = [dateFormat stringFromDate:thatDate];
    
    NSString *bs = [NSString stringWithFormat:@"%@:%@\n", strDate, str];
    buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile writeData:buffer];
    
    //关闭读写文件
    [outFile closeFile];
}

+ (BOOL)removeLogFile
{

    return YES;
}
@end
