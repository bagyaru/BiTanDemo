
#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

//获取程序的 document 带文件夹的路径
+(NSString*)getDocumentFileDirectoryPath:(NSString*)fileName;
//获取程序的Home目录路径
+(NSString *)getHomeDirectoryPath;
//获取document目录路径
+(NSString *)getDocumentPath;
//获取Cache目录路径
+(NSString *)getCachePath:(NSString*)filePath;
//获取Library目录路径
+(NSString *)getLibraryPath;
//获取Tmp目录路径
+(NSString *)getTmpPath;

//获得路径函数
//fileName:文件名
+(NSString*)getDocumentFilePath:(NSString*)fileName;
//获得路径函数
//fileName:文件名
//type:	文件类型
+(NSString *)findBundleFilePath:(NSString *)fileName ofType:(NSString *)type;
//获得路径函数
//fileName:文件名
+(NSString *)getBundleFilePath:(NSString *)fileName;
//获得路径函数

//fileName:文件名
+(BOOL)isFileExist:(NSString *)filePath;
//删除文件
+(void)deletefile:(NSString *)filepath;

+(void)createFileAtPath:(NSString*)path;





@end
