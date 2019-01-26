//
//  MessageCenterCell.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageCenterCell.h"

@implementation MessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.labelUnread, 4);
    //ViewBorderRadius(self.backView, 2, 0.5, [UIColor colorWithHexString:@"e1e1e1"]);
    // Initialization code
}
-(void)creatUIWith:(MessageCenterObj *)obj {
    
    self.feedBackView.constant = 0;
    self.feedBackTitleL.hidden = YES;
    self.feedBackContentL.hidden = YES;
    self.viewBQ.hidden = YES;
    self.titleLeft.constant = 0;
    
    self.imageViewSource.hidden = YES;
    self.labelSource.hidden = YES;
    self.heightSource.constant = 0;
    
    self.labelUnread.hidden = !obj.unread;
    
    self.timeL.text = [getUserCenter NewTimePresentationStringWithTimeStamp:obj.createdAt];
    
    if (ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")||ISStringEqualToString(obj.messageCode, @"INFORMATION_RECOMMEND")) {//1=快讯2要闻3奖励4攻略5讨论
        self.viewBQ.hidden = NO;
        ViewRadius(self.viewBQ, 2);
        if (obj.label == 1) {
            self.viewBQ.backgroundColor = UIColorHex(DDF1FF);
            self.labelBQ.textColor = UIColorHex(108EE9);
            self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"kuaixun"];
        }
        if (obj.label == 2) {
            self.viewBQ.backgroundColor = UIColorHex(DDE1FF);
            self.labelBQ.textColor = UIColorHex(1014E9);
            self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"yaowen"];
        }
        if (obj.label == 3) {
            self.viewBQ.backgroundColor = UIColorHex(FFEDC5);
            self.labelBQ.textColor = UIColorHex(FF7E00);
            self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"jiangli"];
        }
        if (obj.label == 4) {
            self.viewBQ.backgroundColor = UIColorHex(FFE4D9);
            self.labelBQ.textColor = UIColorHex(F36C1F);
            self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"gonglue"];
        }
        if (obj.label == 5) {
            self.viewBQ.backgroundColor = UIColorHex(D5E3FF);
            self.labelBQ.textColor = UIColorHex(105DE9);
            self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"taolun"];
        }
       CGFloat BtnW = [getUserCenter calculateSizeWithFont:12 Text:self.labelBQ.text]+10;
       self.titleLeft.constant = BtnW+8;
        NSLog(@"%.0f",self.titleLeft.constant);
    }
    if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE")) {//探报
        self.viewBQ.hidden = NO;
        ViewRadius(self.viewBQ, 2);
        self.titleLeft.constant = VIEW_BX(self.viewBQ)+8;
        self.viewBQ.backgroundColor = UIColorHex(DDEDFF);
        self.labelBQ.textColor = UIColorHex(108EE9);
        self.labelBQ.text = [APPLanguageService wyhSearchContentWith:@"tanbao"];
    }
    if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//发表文章 帖子奖励 探报奖励
        
        self.imageViewSource.hidden = NO;
        self.labelSource.hidden = NO;
        self.heightSource.constant = 50;
        if ([obj.sourceInfo isKindOfClass:[NSDictionary class]]) {
            self.imageViewSourceH.constant = 30;
            self.imageViewSourceW.constant = 30;
            [self.imageViewSource sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(obj.sourceInfo[@"imgUrl"]) hasPrefix:@"http"]?SAFESTRING(obj.sourceInfo[@"imgUrl"]):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(obj.sourceInfo[@"imgUrl"])]] placeholderImage:IMAGE_NAMED(@"评论默认")];
        }else {
            self.imageViewSourceH.constant = 30;
            self.imageViewSourceW.constant = 30;
            self.imageViewSource.image = IMAGE_NAMED(@"通知-文章帖子删除");
        }
        //来源信息
        if (ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")) {//帖子奖励
            if (![obj.sourceInfo isKindOfClass:[NSDictionary class]]) {
                self.labelSource.text  = [APPLanguageService wyhSearchContentWith:@"gaitiezibucunzai"];
            }else {
                
                self.labelSource.text  = [obj.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelSource and:[obj.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""] color:FirstColor font:14.0f];
            }
        }else {
            
            if (![obj.sourceInfo isKindOfClass:[NSDictionary class]]) {
                self.labelSource.text  = [APPLanguageService wyhSearchContentWith:@"gaiwenzhangbucunzai"];
            }else {
                
                self.labelSource.text  = [obj.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelSource and:[obj.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""] color:FirstColor font:14.0f];
            }
        }
        
    }
    self.labelSource.lineBreakMode = NSLineBreakByTruncatingTail;
    if (ISStringEqualToString(obj.messageCode, @"REPLY_FEEDBACK")) {
        self.feedBackTitleL.hidden = NO;
        self.feedBackContentL.hidden = NO;
        [getUserCenter setLabelSpace:self.feedBackContentL withValue:SAFESTRING(obj.feedBackcontent) withFont:SYSTEMFONT(14) withHJJ:6.0 withZJJ:0.0];
        CGFloat feedBackHeight = [getUserCenter getSpaceLabelHeight:SAFESTRING(obj.feedBackcontent) withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:6.0 withZJJ:0.0]+1;
        self.feedBackView.constant = 50+feedBackHeight;
    }
    
    CGFloat height = 0.0;
    if (ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"USER_BANNED")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//文章被下架 文章被驳回 帖子下线 禁言 发表文章 帖子奖励 探报奖励
        
        //obj.title = obj.content;
        self.titleL.numberOfLines = 0;
        self.titleL.text = obj.content;
        self.contentL.text = @"";
        [getUserCenter setLabelSpace:self.titleL withValue:SAFESTRING(obj.content) withFont:SYSTEMFONT(16) withHJJ:6.0 withZJJ:0.0];
        height = [getUserCenter getSpaceLabelHeight:SAFESTRING(obj.content) withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30-((ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"USER_BANNED")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")) ? 0 : 43) withHJJ:6.0 withZJJ:0.0]+1;
        self.titleH.constant = height;
        
    }else {
         self.titleH.constant = 20;
        self.titleL.numberOfLines = 1;
        self.titleL.text = obj.title;
        self.contentL.text = obj.content;
        [getUserCenter setLabelSpace:self.contentL withValue:SAFESTRING(obj.content) withFont:SYSTEMFONT(14) withHJJ:6.0 withZJJ:0.0];
        height = [getUserCenter getSpaceLabelHeight:SAFESTRING(obj.content) withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:6.0 withZJJ:0.0]+1;
    }
    NSLog(@"%@========%.0f",obj.content,height);
    if (obj.IsOrNoLookDetail) {
        
        self.contentL.numberOfLines = 0;
        self.detailBtn.hidden = NO;
        self.detailBtnH.constant = 40;
        self.detailBtn.localTitle = @"upDetail";
    } else {
        
        self.detailBtn.localTitle = @"downDetail";
        if (height < 65) {
            
            if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE")||ISStringEqualToString(obj.messageCode, @"INFORMATION_RECOMMEND")) {
                
                self.detailBtnH.constant = 40;
                self.detailBtn.hidden = NO;
            }else {
                
                self.detailBtnH.constant = 14;
                self.detailBtn.hidden = YES;
            }
            self.contentL.numberOfLines = 0;
        }else {
            
            if (ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"USER_BANNED")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//文章被下架 文章被驳回 帖子下线 禁言 探报审核通过 帖子奖励 探报奖励
                self.detailBtnH.constant = 14;
                self.detailBtn.hidden = YES;
            }else {
                self.detailBtnH.constant = 40;
                self.detailBtn.hidden = NO;
            }
            self.contentL.numberOfLines = 3;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
