

#import "FileUtil.h"

@implementation FileUtil

#pragma mark aboutPath


+(NSString*)getHomeDirectoryPath
{
    return NSHomeDirectory();
}

+(NSString*)getDocumentPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}

+(NSString*)getCachePath:(NSString *)filePath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:filePath];
    
    return path;
}

+(NSString *)getLibraryPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

+(NSString *)getTmpPath{
    return NSTemporaryDirectory();
}

+(NSString*)getDocumentFileDirectoryPath:(NSString*)fileName{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc_dir=[paths objectAtIndex:0];
    doc_dir= [doc_dir stringByAppendingPathComponent:@"attachments"];
    if(![self isFileExist:doc_dir])
    {
       //创建文件目录
       [file_manager createDirectoryAtPath:doc_dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [doc_dir stringByAppendingPathComponent:fileName];
}

+(NSString*)getDocumentFilePath:(NSString*)fileName{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc_dir=[paths objectAtIndex:0];
    NSString *path=[doc_dir stringByAppendingPathComponent:fileName];
    return path;
    
}


+(NSString *)findBundleFilePath:(NSString *)fileName ofType:(NSString *)type{
	return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

+(NSString *)getBundleFilePath:(NSString *)fileName
{
	return [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:fileName];
}

+(BOOL)isFileExist:(NSString *)filePath{
	
	NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:filePath];
}
//删除文件
+(void)deletefile:(NSString *)filepath{
    if([self isFileExist:filepath]){
        
        BOOL ret=[[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        
        if(ret){
            NSLog(@"删除成功");
        }
       else{
            NSLog(@"删除失败");
        }
    }else{
        NSLog(@"文件不存在");
    }

}


+(void)createFileAtPath:(NSString *)path{
    if(path){
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
}
@end
