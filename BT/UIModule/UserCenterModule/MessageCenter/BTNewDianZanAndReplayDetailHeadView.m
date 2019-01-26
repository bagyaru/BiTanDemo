//
//  BTNewDianZanAndReplayDetailHeadView.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewDianZanAndReplayDetailHeadView.h"

@implementation BTNewDianZanAndReplayDetailHeadView
-(void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.imageViewIcon, 18);
    self.labelName.userInteractionEnabled = YES;
    self.imageViewIcon.userInteractionEnabled = YES;
    [self.imageViewIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    if (ISNSStringValid(SAFESTRING(self.model.userName))) {
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(self.model.userName)}];
    }
}
//点赞
- (IBAction)likeBtnClick:(UIButton *)sender {
    if (self.likeBlock) {
        self.likeBlock(_model);
    }
}
- (IBAction)goToSourceDetailBtnClcik:(UIButton *)sender {
    
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 12 || [_model.sourceInfo[@"jumpType"] integerValue] == 15) {//要闻 攻略
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":_model.sourceInfo[@"refId"]}];
    }
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 5) {//币圈
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":_model.sourceInfo[@"refId"],@"bigType":@(6)}];
    }
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 16) {//话题
        
        [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":_model.sourceInfo[@"refId"]}];
    }
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 2) {//论币
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if ([_model.sourceInfo[@"refId"] containsString:@"/"]) {//交易对
            [dict setObject:[_model.sourceInfo[@"refId"] componentsSeparatedByString:@"/"][0] forKey:@"currencyCode"];
            [dict setObject:[_model.sourceInfo[@"refId"] componentsSeparatedByString:@"/"][1] forKey:@"currencyCodeRelation"];
        }else {//币种
            
           [dict setObject:_model.sourceInfo[@"refId"] forKey:@"kindCode"];
        }
        if (dict.count > 0) {
            [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dict];
        }
    }
    
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 4) {//期货
       
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSArray *arr = [_model.sourceInfo[@"refId"] componentsSeparatedByString:@"@"];
        [dict setObject:arr[0] forKey:@"exchangeCode"];
        [dict setObject:arr[1] forKey:@"kindCode"];
        [dict setObject:_model.sourceInfo[@"title"] forKey:@"kindName"];
        [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dict];
    }
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 6) {//帖子
        if (_model.sourceInfo[@"title"] == nil) {
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"yuantieyishanchu"] wait:YES];
        }else {
            
            [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":_model.sourceInfo[@"refId"]} completion:^(id obj) {
                
            }];
        }
    }
}

-(void)setModel:(DiscussModel *)model {
    
    if (model) {
        _model = model;
        self.labelName.text = model.userName;
        //[self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.userAvatar andImageView:self.imageViewIcon andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self];
        
        self.labelLike.text = [NSString stringWithFormat:@"%ld",(long)model.likeCount];
        model.likeCount > 0 ? (self.labelLike.textColor = MainBg_Color) : (self.labelLike.textColor = CFontColor8);
        if (!model.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"xin-nor"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"xin-sel"];
        }
        
        self.labelContent.text = model.content;
        //变色
        [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelContent and:model.content color:MainBg_Color font:16.0f];
        //[getUserCenter setLabelSpace:self.labelContent withValue:model.content withFont:SYSTEMFONT(16) withHJJ:7.0 withZJJ:0.0];
        //来源信息
        if ([model.sourceInfo[@"jumpType"] integerValue] == 6) {//帖子
            if (model.sourceInfo[@"title"] == nil) {
               self.labelSource.text  = [APPLanguageService wyhSearchContentWith:@"yuantieyishanchu"];
            }else {
                
                self.labelSource.text  = [model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelSource and:[model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""] color:MainBg_Color font:12.0f];
            }
        }else {
            self.labelSource.text  = [model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelSource and:[model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""] color:MainBg_Color font:12.0f];
        }
        
        [self.imageViewSource sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.sourceInfo[@"imgUrl"]) hasPrefix:@"http"]?SAFESTRING(model.sourceInfo[@"imgUrl"]):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(model.sourceInfo[@"imgUrl"])]] placeholderImage:[UIImage imageNamed:@"评论默认"]];
        
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[model.createTime timeIntervalSince1970]*1000]];
        
    }
    
    self.labelSource.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
