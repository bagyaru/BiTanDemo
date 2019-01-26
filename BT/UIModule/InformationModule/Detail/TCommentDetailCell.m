//
//  TCommentDetailCell.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TCommentDetailCell.h"

@implementation TCommentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.iconIV, 20);
    // Initialization code
}
-(void)creatUIWith:(CommentDetailObj *)obj {
    
     //[self.iconIV sd_setImageWithURL:[NSURL URLWithString:[obj.userAvatar hasPrefix:@"http"]?obj.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    
    [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:obj.userAvatar andImageView:self.iconIV andAuthStatus:2 andAuthType:1 addSuperView:self.contentView];
    
    self.nameL.text = obj.userName;
    self.contentL.text = obj.content;
    [getUserCenter getLabelHight:self.contentL Float:4.0 AddImage:NO];
    NSString *nowTime = [getUserCenter nowTimeWithDate:[NSDate date]];
    NSString *craetTime = [getUserCenter timeWithTimeIntervalString:obj.createTime];
    NSString *mini = [getUserCenter minutestimeWithTimeIntervalString:obj.createTime];
    NSArray *a1 = [nowTime componentsSeparatedByString:@"/"];
    NSArray *a2 = [craetTime componentsSeparatedByString:@"/"];
    NSString *s1 = a1[1];
    NSString *s2 = a2[1];
    if (ISStringEqualToString(craetTime, nowTime)) {//今天
        
        self.timeL.text = [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"jintian"],mini];
    }else if (ISStringEqualToString(a1[0], a2[0])&&(s1.integerValue == (s2.integerValue - 1))) {//昨天
        
        self.timeL.text = [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"zuotian"],mini];
    }else {//其他
        
        self.timeL.text = [NSString stringWithFormat:@"%@ %@",craetTime,mini];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
