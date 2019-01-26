//
//  BTNewCommentsAlertFootView.m
//  BT
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewCommentsAlertFootView.h"
@interface BTNewCommentsAlertFootView () {
    
    HYShareActivityView            *_shareView;
}
@end
@implementation BTNewCommentsAlertFootView
-(void)awakeFromNib {
    [super awakeFromNib];
    self.shareIV.image = IMAGE_NAMED(@"文章分享");
    self.PLBtn.backgroundColor = ViewBGColor;
}
-(void)setModel:(DiscussModel *)model {
    
    if (model) {
        _model = model;
        if (!model.liked) {
            self.collectionIV.image = [UIImage imageNamed:@"评论点赞-1"];
        }else{
            self.collectionIV.image = [UIImage imageNamed:@"评论点赞-2"];
        }
    }
}
-(void)setIsHaveShare:(BOOL)isHaveShare {
    
    if (isHaveShare) {
        
        self.shareIV.hidden           = YES;
        self.shareViewWeight.constant = 0;
    }
}
- (IBAction)collectionBtnClick:(UIButton *)sender {
    
    if (self.likeBlock) {
        self.likeBlock(_model);
    }
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    //分享
    if ( _shareView == nil ){
        
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)]
                                                   shareTypeBlock:^(HYSharePlatformType type)
                      {
                          
                          [self shareActiveType:type];
                      }];
        [_shareView show];
    }else
    {
        [_shareView show];
    }
}
-(void)shareActiveType:(NSUInteger)type {
    
    NSLog(@"%ld",(unsigned long)type);
//    if (type == 2) {//微博
//        if ([WeiboSDK isWeiboAppInstalled] )
//        {
//            [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//        }
//    }else {//微信
//
//        if ([WXApi isWXAppInstalled] )
//        {
//            [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//        }
//    }
    [getUserCenter shareBuriedPointWithType:type withWhereVc:10];
    HYShareInfo *shareInfo = [[HYShareInfo alloc] init];
    shareInfo.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
    shareInfo.title = self.shareTitle;
    shareInfo.url = self.shareUrl;
    shareInfo.image = self.shareImageURL;
    shareInfo.type = (HYPlatformType)type;
    shareInfo.shareType = HYShareDKContentTypeWebPage;
    [HYShareKit shareInfoWith:shareInfo completion:^(NSString *errorMsg)
     {
         if (ISNSStringValid(errorMsg) )
         {
             
             [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
         }
         [_shareView hide];
     }];
    
    
}
@end
