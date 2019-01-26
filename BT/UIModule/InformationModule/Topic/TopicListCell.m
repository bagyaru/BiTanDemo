//
//  TopicListCell.m
//  BT
//
//  Created by admin on 2018/4/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TopicListCell.h"

@implementation TopicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.buttonlHotRecommend, 10);
    // Initialization code
}
-(void)setModel:(FastInfomationObj *)model {
    self.buttonlHotRecommend.hidden = !model.hotRecommend;
    if (!model.hotRecommend) {
        self.buttonHotRecommendW.constant = 0;
        self.left.constant = 0;
    }
    //[self.imageIV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    [self.imageIV setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
    ViewRadius(self.imageIV, 3);
    self.titleL.text =  model.title;
    
    if ([[BTSearchService sharedService] readSheQuHistoryReadWithInfoID:model.infoID type:model.type]) {
        
        self.titleL.textColor = ThirdColor;
    }else {
        
        self.titleL.textColor = FirstColor;
    }
    
    self.numberL.text = [NSString stringWithFormat:@"%@%@·%@%@",[[DigitalHelperService transformWith:model.viewCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:model.viewCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:model.viewCount],[APPLanguageService wyhSearchContentWith:@"renliulan"],[[DigitalHelperService transformWith:model.commentCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:model.commentCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:model.commentCount],[APPLanguageService wyhSearchContentWith:@"huida"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
