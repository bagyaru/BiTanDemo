//
//  JianjieContentCell.m
//  BT
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JianjieContentCell.h"

@interface JianjieContentCell()
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end

@implementation JianjieContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [AppHelper addBottomLineWithParentView:self];
}

- (void)setModel:(BTJianjieModel *)model{
    if(model){
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:wordStyle};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:model.content  attributes:wordDic];
        _contentL.attributedText = wordLabelAttStr;
        
    }
}

@end
