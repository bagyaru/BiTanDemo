//
//  HYShareInfo.m
//  shareSDKDemo
//
//  Created by haiyun on 16/6/5.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "HYShareInfo.h"

@implementation HYShareInfo

- (void)processUrl;
{
    NSDictionary *p = @{@(HYPlatformTypeSinaWeibo) : @"sinaweibo", @(HYPlatformTypeQQSpace) : @"qqspace",
                        @(HYPlatformTypeWeixiSession) : @"weixin", @(HYPlatformTypeWeixiTimeline) : @"pengyouquan",
                        @(HYPlatformTypeQQ) : @"qq"};
    NSString *param = p[@(self.type)];
    
    NSString *s = @"&";
    if ([self.url rangeOfString:@"?"].location == NSNotFound)
    {
        s = @"?";
    }
    self.url = [self.url stringByAppendingFormat:@"%@utm_medium=%@", s, param];
    
    if (self.type == HYPlatformTypeSinaWeibo && self.url.length > 0)
    {
        NSRange range = [self.content rangeOfString:@"http://"];
        if (range.location == NSNotFound)
        {
            range = [self.content rangeOfString:@"https://"];
        }
        if (range.location == NSNotFound)
        {
            self.content = [self.content stringByAppendingString:self.url];
        }
    }
}




@end
