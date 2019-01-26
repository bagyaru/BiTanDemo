//
//  ConceptAllTableViewCell.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConceptAllTableViewCell.h"

@interface ConceptAllTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *rateL;

@property (weak, nonatomic) IBOutlet UILabel *countL;

@property (weak, nonatomic) IBOutlet UILabel *greatL;
@property (weak, nonatomic) IBOutlet UILabel *worstL;
@property (weak, nonatomic) IBOutlet UILabel *maxKindL;

@property (weak, nonatomic) IBOutlet UILabel *minKindL;

@end

@implementation ConceptAllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CurrencyConceptModel *)model{
    _model = model;
    if(model){
        self.nameL.text = model.conceptClassifyName;
        if (model.averageRose <  0) {
            self.rateL.textColor =CRedColor;
            self.rateL.text =[NSString stringWithFormat:@"-%@%%",@(-model.averageRose).p2fString];
        }else{
            self.rateL.textColor =CGreenColor;
            self.rateL.text =[NSString stringWithFormat:@"+%@%%",@(model.averageRose).p2fString];
            
            if (model.averageRose == 0) {
                self.rateL.textColor = CBlackColor;
            
            }
        }
        
        self.countL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"huobishuliang"],@(model.kindCount)];
        self.maxKindL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"zuijia"],model.maxKind];//
        self.minKindL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"zuicha"],model.minKind];
        if(model.maxRose <0){
            self.greatL.textColor =CRedColor;
            self.greatL.text =[NSString stringWithFormat:@"%@%%",@(-model.maxRose).p2fString];
        }else{
            self.greatL.textColor =CGreenColor;
            self.greatL.text =[NSString stringWithFormat:@"%@%%",@(model.maxRose).p2fString];
            if (model.maxRose == 0) {
                self.greatL.textColor = CBlackColor;
                
            }
        }
        if(model.minRose <0){
            self.worstL.textColor =CRedColor;
            self.worstL.text =[NSString stringWithFormat:@"%@%%",@(-model.minRose).p2fString];
        }else{
            self.worstL.textColor =CGreenColor;
            self.worstL.text =[NSString stringWithFormat:@"%@%%",@(model.minRose).p2fString];
            if (model.minRose == 0) {
                self.worstL.textColor = CBlackColor;
                
            }
        }
    }
}

@end
