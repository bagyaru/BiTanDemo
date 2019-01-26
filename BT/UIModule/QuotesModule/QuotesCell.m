//
//  MainCell.m
//  TestHH
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuotesCell.h"

@interface  QuotesCell ()

@property (weak, nonatomic) IBOutlet UILabel *lableTitle;

@end

@implementation QuotesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = CViewBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title{
    self.lableTitle.text = title;
}

@end
