//
//  changePhotoRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "changePhotoRequest.h"

@implementation changePhotoRequest
{
    NSData *_file;
    NSString *_uploadType;
}

- (id)initWithUsername:(NSData *)file uploadType:(NSString *)uploadType;{
    self = [super init];
    if (self) {
        _file = file;
        _uploadType = uploadType;
        
    }
    return self;
}
- (NSString *)requestUrl {
    return changePhotoUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{@"file":_file,
             @"uploadType":_uploadType
             };
}
-(AFConstructingBlock)constructingBodyBlock {
    
    return ^(id<AFMultipartFormData> formData) {
        
        // 可以在上传时使用当前的系统时间作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        NSString *formKey = @"file";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:_file name:formKey fileName:fileName mimeType:type];
    };
    
}
@end
