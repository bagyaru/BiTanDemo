//
//  HInviteCodeShare.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HInviteCodeShare.h"
#import "ShareCodeToFriend.h"
@interface HInviteCodeShare()

@property (nonatomic, strong) HYShareActivityView *shareView;

@end

@implementation HInviteCodeShare

SINGLETON_FOR_CLASS(HInviteCodeShare);

- (void)shareWithContent:(NSString *)content reward:(NSInteger)reward{
    
    UIImage *image = [UIImage imageNamed:@"inviteShare"];
    UIFont *headerFont =nil;
    if(IOS_VERSION>=9.0){
        headerFont =[UIFont fontWithName:@"PingFangSC-Medium" size:36];
    }else{
        headerFont =[UIFont systemFontOfSize:36.0f];
    }
    
    CGFloat leftMargin = 49.0/2;
    CGFloat w = ScreenWidth-49.0f;
    CGFloat h = 580.0/326*w;
    NSLog(@"宽====%.0f 高===%.0f",w,h);
    CGFloat y = (ScreenHeight - h)/2;
    
    CGFloat ratio = h/580.0f;
    
    //合成图片
//    UIImage *originImage = [HImageUtility imageWithText:content font:headerFont textColor:kHEXCOLOR(0xFFCF00) image:image imageFrame:CGRectMake(leftMargin, y, w, h) textFrame:CGRectMake((w-120)/2, 258*ratio, 120, 50)];
    
    UIImage *originImage = [ShareCodeToFriend getImageFromViewWithCode:content reward:reward];
    if (!_shareView) {
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)]
                                                   shareTypeBlock:^(HYSharePlatformType type)
                      {
                          
                          [self shareActiveType:type image:originImage];
                      }];
        
        [_shareView show];
    }else {
        
        [_shareView show];
    }
}

- (void)shareActiveType:(NSUInteger)type image:(UIImage*)image{
    HYShareInfo *info = [[HYShareInfo alloc] init];
    info.content = @"分享邀请码";
    info.images = image;
    info.type = (HYPlatformType)type;
    info.shareType    = HYShareDKContentTypeImage;
    [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
     {
         if ( ISNSStringValid(errorMsg) )
         {
             [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             [_shareView hide];
         }
     }];
    
}


@end
