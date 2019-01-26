//
//  NewsCell.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet UILabel *lableTitle;


@property (weak, nonatomic) IBOutlet UILabel *labelSource;

@property (weak, nonatomic) IBOutlet UILabel *labelViewCount;

@property (weak, nonatomic) IBOutlet BTLabel *labelViewCountInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet BTLabel *labelSourceInfo;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.viewBg.backgroundColor = CGraySecionColor;
    self.labelSource.textColor = CGrayColor;
    self.labelViewCount.textColor = CGrayColor;
    self.labelTime.textColor = CGrayColor;
    self.labelViewCountInfo.textColor = CGrayColor;
    self.labelSourceInfo.textColor = CGrayColor;
//    [AppHelper addLineWithParentView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NewsModel *)model{
    if (model) {
        self.lableTitle.text = model.title;
        NSString *str = @"";
        if (model.imgUrl.length > 0) {
            if (![model.imgUrl containsString:@"http"]) {
                str = [NSString stringWithFormat:@"%@%@",PhotoImageURL,model.imgUrl];
            }else{
                str = model.imgUrl;
            }
        }
        [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:str]];
        self.labelSource.text = model.source;
        self.labelTime.text = model.timeFormat;
        self.labelViewCount.text = [NSString stringWithFormat:@"%ld",model.viewCount];
    }
}

@end
