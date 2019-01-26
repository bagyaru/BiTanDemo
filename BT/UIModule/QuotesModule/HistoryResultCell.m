//
//  HistoryResultCell.m
//  BT
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistoryResultCell.h"


@interface HistoryResultCell ()

@property (weak, nonatomic) IBOutlet BTLabel *labelNameFirst;

@property (weak, nonatomic) IBOutlet BTLabel *labelNameSecond;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentcyFirst;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentcySecond;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *priceL;


@end

@implementation HistoryResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelName.textColor = CGrayColor;
    self.labelCurrentcyFirst.textColor = CBlackColor;
    self.labelCurrentcySecond.textColor = CGrayColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [AppHelper addLeftLineWithParentView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(CurrentcyModel *)model{
    if (model) {
        if (kIszh_hans) {
            
            if (model.currencyChineseName.length > 0) {
                self.labelName.text = [NSString stringWithFormat:@"(%@%@)",model.currencyChineseName,(ISNSStringValid(model.currencyEnglishName)&&!ISStringEqualToString(model.currencyChineseName, model.currencyEnglishName))?[NSString stringWithFormat:@", %@",model.currencyEnglishName]:@""];
                if (model.currencyChineseNameRelation.length > 0) {
                     self.labelName.text = [NSString stringWithFormat:@"(%@/%@)",model.currencyChineseName,model.currencyChineseNameRelation];
                }
            }else{
                if (model.currencyChineseNameRelation.length > 0) {
                    self.labelName.text = [NSString stringWithFormat:@"(%@)",model.currencyChineseNameRelation];
                }else{
                    self.labelName.text = @"";
                }
            }
            
        }else{
            if (model.currencyEnglishName.length > 0) {
                self.labelName.text = [NSString stringWithFormat:@"(%@)",model.currencyEnglishName];
                if (model.currencyEnglishNameRelation.length > 0) {
                    self.labelName.text = [NSString stringWithFormat:@"(%@/%@)",model.currencyEnglishName,model.currencyEnglishNameRelation];
                }
            }else{
                if (model.currencyEnglishNameRelation.length > 0) {
                    self.labelName.text = [NSString stringWithFormat:@"(%@)",model.currencyEnglishNameRelation];
                }else{
                    self.labelName.text = @"";
                }
            }
        }
        
        model.icon = SAFESTRING(model.icon);
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",model.icon,str];
        NSString *imageUrl = [model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
        [self.imageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_coin"]];
        
        self.labelCurrentcyFirst.text = model.currencySimpleName;
        if (model.currencySimpleNameRelation.length > 0) {
            if (model.currencySimpleName.length > 0) {
              self.labelCurrentcySecond.text = [NSString stringWithFormat:@"/%@",model.currencySimpleNameRelation];
            }else{
              self.labelCurrentcySecond.text = model.currencySimpleNameRelation;
            }
            
        }else{
            self.labelCurrentcySecond.text = @"";
        }
        if(kIsCNY){
            self.priceL.text =[NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService isTransformWithDouble:model.legalTendeCNY]] ;
        }else{
             self.priceL.text =[NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService isTransformWithDouble:model.legalTendeUSD]];
        }
    }
}

@end
