//
//  EditOptionCell.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "EditOptionCell.h"
#import "BTCurrencyPairFirstLabel.h"

@interface EditOptionCell ()

@property (weak, nonatomic) IBOutlet BTCurrencyPairFirstLabel *labelCurrentcyFirst;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIButton *btnSelected;

@property (weak, nonatomic) IBOutlet UIButton *zhiidingBtn;

@end


@implementation EditOptionCell

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed: @"bt_sorting"];
                        if(isNightMode){
                            subview.frame =CGRectMake(0, 0, 16, 18);
                        }else{
                            subview.frame =CGRectMake(0, 0, 12, 10);
                        }
                    }
                }
            }
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelName.textColor = SecondTextColor;
    [self.btnSelected setImage:[UIImage imageNamed:@"choose-nor"] forState:UIControlStateNormal];
    [self.btnSelected setImage:[UIImage imageNamed:@"choose-sel"] forState:UIControlStateSelected];
    [self.zhiidingBtn setImage:[UIImage imageNamed:@"group_top"] forState:UIControlStateNormal];
    
}

- (void)setItemModel:(ItemModel *)itemModel{
    if (itemModel) {
        _itemModel = itemModel;
        //加上交易所信息
        if (kIszh_hans) {
            self.labelName.text = [NSString stringWithFormat:@"%@,%@",itemModel.exchangeName,itemModel.currencyChineseName] ;
        }else{
            self.labelName.text =[NSString stringWithFormat:@"%@,%@",itemModel.exchangeName,itemModel.currencyEnglishName];
        }
        if (itemModel.currencyCodeRelation.length > 0) {
            NSString *strCode = [NSString stringWithFormat:@"%@/%@",itemModel.currencyCode,itemModel.currencyCodeRelation];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strCode];
            NSRange ran = [strCode rangeOfString:@"/"];
            [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, strCode.length - ran.location)];
            self.labelCurrentcyFirst.attributedText = attributedString;
//            self.labelCurrentcyFirst.text = [NSString stringWithFormat:@"%@/%@",itemModel.currencyCode,itemModel.currencyCodeRelation];
        }else{
            self.labelCurrentcyFirst.text = itemModel.currencyCode;
        }
        
        self.btnSelected.selected = itemModel.isSelected;
        
        
    }
}


- (IBAction)clickSelected:(id)sender {
    self.btnSelected.selected = !self.btnSelected.isSelected;
    self.itemModel.isSelected = self.btnSelected.selected;
    if (self.selectHandle) {
        self.selectHandle();
    }
}

- (IBAction)clickedBtnTop:(id)sender {
    if (self.topHandle) {
        self.topHandle();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
