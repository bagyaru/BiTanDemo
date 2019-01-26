//
//  BTTPRewardCell.m
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTPRewardCell.h"

@interface BTTPRewardCell()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *tpCountL;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingCons;

@end

@implementation BTTPRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatar.layer.cornerRadius = 18.0f;
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.userInteractionEnabled = YES;
    self.nameL.userInteractionEnabled = YES;
    _contentImageV.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageV.clipsToBounds = YES;
    
    [self.userAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.nameL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    if(_model.articleType == 1 ||_model.articleType == 4){
        
    }else{
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(_model.userName)}];
    }
}
- (void)setModel:(BTTPRewardModel *)model{
    _model = model;
    if(model){
        //[_userAvatar setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.imageUrl) hasPrefix:@"http"]?model.imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.imageUrl]] placeholder:[UIImage imageNamed:@"morentouxiang"]];
        
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.imageUrl andImageView:self.userAvatar andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
        
        _nameL.text = model.userName;
        _tpCountL.text = [NSString stringWithFormat:@"%@TP",@(model.num)];
        NSString *content = [SAFESTRING(model.articleTitle) stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        content = [SAFESTRING(content) stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.titleL.text = content;
         [getUserCenter postNikeNameChangeUILabelRangeColor:self.titleL and:SAFESTRING(content) color:MainBg_Color font:14];//model.articleTitle;
        
        _dateL.text = [NSString stringWithFormat:@"%@",[getUserCenter NewTimePresentationStringWithTimeStamp:model.datetime]];
        self.titleL.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if(SAFESTRING(model.articlePic).length >0){
            //            self.contentImageV.hidden = NO;
            //            self.titleLeadingCons.constant = 45;
            NSString *imageStr = SAFESTRING(model.articlePic);
            NSString *imageUrl = [NSString stringWithFormat:@"%@",([imageStr hasPrefix:@"http"]||[imageStr hasPrefix:@"https"])?imageStr:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageStr]];
            [self.contentImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
        }else{
            if(model.isDeleted){
                self.contentImageV.image = [UIImage imageNamed:@"通知-文章帖子删除"];
                //                self.contentImageV.hidden = NO;
                //                self.titleLeadingCons.constant = 45;
            }else{
                //                self.contentImageV.hidden = YES;
                //                self.titleLeadingCons.constant = 15;
                //                self.contentImageV.hidden = NO;
                //                self.titleLeadingCons.constant = 45;
                self.contentImageV.image =  [UIImage imageNamed:@"Mask_list"];
            }
            
        }
        
    }
}
                       
@end
