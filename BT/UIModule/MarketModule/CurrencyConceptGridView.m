//
//  CurrencyConceptGridView.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CurrencyConceptGridView.h"
@interface CurrencyConceptGridView()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *rateL;

@property (weak, nonatomic) IBOutlet UILabel *maxKindL;

@property (weak, nonatomic) IBOutlet UILabel *greatL;

@end
@implementation CurrencyConceptGridView

- (void)setModel:(CurrencyConceptModel *)model{
    _model = model;
    if(model){
        self.nameL.text = model.conceptClassifyName;
        if (model.averageRose <  0) {
            self.rateL.textColor =CRedColor;
            self.rateL.text =[NSString stringWithFormat:@"%@%%",@(-model.averageRose).p2fString];
        }else{
            self.rateL.textColor =CGreenColor;
            self.rateL.text =[NSString stringWithFormat:@"%@%%",@(model.averageRose).p2fString];
            
            if (model.averageRose == 0) {
                self.rateL.textColor = CBlackColor;
                
            }
        }
        
        self.maxKindL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"zuijia"],model.maxKind];
        
        if(model.maxRose <0){
            self.greatL.textColor =CRedColor;
            self.greatL.text =[NSString stringWithFormat:@"%@%%",@(model.maxRose).p2fString];
        }else{
            self.greatL.textColor =CGreenColor;
            self.greatL.text =[NSString stringWithFormat:@"%@%%",@(model.maxRose).p2fString];
            if (model.maxRose == 0) {
                self.greatL.textColor = CBlackColor;
            }
        }
    }
    
    
}

@end
