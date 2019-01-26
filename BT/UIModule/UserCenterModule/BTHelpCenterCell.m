//
//  BTHelpCenterCell.m
//  BT
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHelpCenterCell.h"

@interface BTHelpCenterCell ()
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hCons;

@end

@implementation BTHelpCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.indicatorView.layer.cornerRadius = 3.0f;
    self.indicatorView.layer.masksToBounds = YES;
}

- (void)setModel:(BTHelpCenterModel *)model{
    _model = model;
    if(model){
        if(model.isExpand){
            self.footerView.hidden = NO;
            self.wCons.constant = 12;
            self.hCons.constant = 12;
            
            self.rightImageV.image = [UIImage imageNamed:@"help_center_down"];
            
        }else{
            self.wCons.constant = 7;
            self.hCons.constant = 12;
            self.footerView.hidden = YES;
            self.rightImageV.image = [UIImage imageNamed:@"R箭头"];
        }
        NSString *content;
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            _titleL.text = model.title;
            content = SAFESTRING(model.answer);
        }else{
            _titleL.text = model.titleEn;
            content = SAFESTRING(model.answerEn);
        }
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 6.0f;
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:wordStyle};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content attributes:wordDic];
        _contentL.attributedText = wordLabelAttStr;
    }
}

@end
