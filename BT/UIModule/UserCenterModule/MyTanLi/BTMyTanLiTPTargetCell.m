//
//  BTMyTanLiTPTargetCell.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyTanLiTPTargetCell.h"
#import "BTOneTPTargetView.h"
#import "TargetModel.h"
@implementation BTMyTanLiTPTargetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}
-(void)setArray:(NSMutableArray *)array {
    
    if (array) {
        [self.scrollView removeAllSubviews];
        self.scrollView.contentSize = CGSizeMake(array.count*200, 0);
        for (int i = 0; i < array.count; i++) {
            TargetModel *model = array[i];
            BTOneTPTargetView *view = [BTOneTPTargetView loadFromXib];
            view.model = model;
            view.frame = CGRectMake(i*200, 0, 200, 90);
            
            if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
                view.labelTitle.text = model.name;
                view.labelContent.text = model.describe;
            }else{
                
                view.labelTitle.text = model.nameEn;
                view.labelContent.text = model.describeEn;
            }
            if (model.type == 3) {//分享资讯
                view.imageViewBig.image = IMAGE_NAMED(@"ic_fenxiang-bg");
                view.imageViewSmall.image = IMAGE_NAMED(@"ic_fenxiang");
            }
            if (model.type == 4) {//邀请好友
                view.imageViewBig.image = IMAGE_NAMED(@"ic_yaoqing-bg");
                view.imageViewSmall.image = IMAGE_NAMED(@"ic_yaoqing");
            }
            if (model.type == 6) {//邀请好友
                view.imageViewBig.image = IMAGE_NAMED(@"ic_fabu-bg");
                view.imageViewSmall.image = IMAGE_NAMED(@"ic_fabu");
            }
            [self.scrollView addSubview:view];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
