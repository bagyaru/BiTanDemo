//
//  BTFocusRecommendCell.m
//  BT
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTFocusRecommendCell.h"

@implementation BTFocusRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.imageViewIcon, 20);
    // Initialization code
}
-(void)setModel:(BTFocusRecommendModel *)model {
    
    if (model) {
        _model = model;
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        if (model.authStatus == 2) {
        
            self.imageViewV.hidden = NO;
            if (model.authType != 0) {
                
                self.imageViewV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_%@",model.authType,@"中"]];
            }
        }else {
            
            self.imageViewV.hidden = YES;
        }
        
        self.labelNikeName.text = model.nickName;
        self.labelIntroduction.text = ISNSStringValid(SAFESTRING(model.introductions)) ? model.introductions : [APPLanguageService wyhSearchContentWith:@"morenintroductions"];
        self.labelFans.text = [NSString stringWithFormat:@"%ld 粉丝  %ld 原创",model.fansNum,model.articleNum];
        if (model.followed) {
            
            self.buttonFocus.localTitle = @"jiaquxiaoguanzhu";
            [self.buttonFocus setTitleColor:ThirdColor forState:UIControlStateNormal];
            ViewBorderRadius(self.buttonFocus, 4, 1, SeparateColor);
        }else {
            
            self.buttonFocus.localTitle = @"jiaguanzhu";
            [self.buttonFocus setTitleColor:MainBg_Color forState:UIControlStateNormal];
            ViewBorderRadius(self.buttonFocus, 4, 1, MainBg_Color);
        }
        
    }
}

- (IBAction)focusBtnClick:(BTButton *)sender {
    
    [MobClick event:@"guanzhu_tuijian_follow"];
    if (self.focusBlock) {
        self.focusBlock(self.model);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
