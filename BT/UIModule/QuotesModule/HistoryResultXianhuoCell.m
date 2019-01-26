//
//  HistoryResultXianhuoCell.m
//  BT
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistoryResultXianhuoCell.h"

@interface HistoryResultXianhuoCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation HistoryResultXianhuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [AppHelper addLineWithParentView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name{
    _name = name;
    self.labelTitle.text = _name;
}

@end
