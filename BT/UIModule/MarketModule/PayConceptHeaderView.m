//
//  PayConceptHeaderView.m
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PayConceptHeaderView.h"

@interface PayConceptHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *rateL;
@property (weak, nonatomic) IBOutlet UILabel *upL;

@property (weak, nonatomic) IBOutlet UILabel *downL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;

@property (weak, nonatomic) IBOutlet UILabel *upLCount;
@property (weak, nonatomic) IBOutlet UILabel *downLCount;

@property (weak, nonatomic) IBOutlet UILabel *totalLCount;


@property (weak, nonatomic) IBOutlet UILabel *greatL;
@property (weak, nonatomic) IBOutlet UILabel *worstL;
@property (weak, nonatomic) IBOutlet UILabel *maxKindL;
@property (weak, nonatomic) IBOutlet UILabel *minKindL;

@end
@implementation PayConceptHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.greatL.layer.cornerRadius = 2.0f;
    self.worstL.layer.cornerRadius = 2.0f;
    self.greatL.layer.masksToBounds = YES;
    self.worstL.layer.masksToBounds = YES;
    
    self.greatL.textColor = [UIColor whiteColor];
    self.worstL.textColor = [UIColor whiteColor];
    self.greatL.adjustsFontSizeToFitWidth = YES;
    self.worstL.adjustsFontSizeToFitWidth = YES;
    self.upLCount.textColor = CGreenColor;
    self.downLCount.textColor = CRedColor;
}

- (void)setModel:(PayConceptModel *)model{
    _model = model;
    self.nameL.text = model.conceptClassifyName;
    if(model.averageRose>=0){
        self.rateL.text = [NSString stringWithFormat:@"+%@%%",@(model.averageRose).p2fString];
        self.rateL.textColor = CGreenColor;
        
    }else{
        self.rateL.text = [NSString stringWithFormat:@"%@%%",@(model.averageRose).p2fString];
        self.rateL.textColor = CRedColor;
    }
    self.upL.text =[NSString stringWithFormat:@"%@",[APPLanguageService wyhSearchContentWith:@"shangzhangjiashu"]];
    self.downL.text =[NSString stringWithFormat:@"%@",[APPLanguageService wyhSearchContentWith:@"xiajiangjiashu"]];
    self.totalL.text=[NSString stringWithFormat:@"%@",[APPLanguageService wyhSearchContentWith:@"huobizongshu"]];
    self.upLCount.text = SAFESTRING(@(model.riseCount));
    self.downLCount.text = SAFESTRING(@(model.dropCount));
    self.totalLCount.text = SAFESTRING(@(model.kindCount));
    
    
    self.maxKindL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"zuijia"],model.maxKind];
    self.minKindL.text = [NSString stringWithFormat:@"%@: %@",[APPLanguageService wyhSearchContentWith:@"zuicha"],model.minKind];
    
    if(model.maxRose <0){
        self.greatL.text =[NSString stringWithFormat:@"%@%%",@(model.maxRose).p2fString];
        self.greatL.backgroundColor = CRedColor;
    }else{
        self.greatL.backgroundColor = CGreenColor;
        self.greatL.text =[NSString stringWithFormat:@"+%@%%",@(model.maxRose).p2fString];
        if (model.maxRose == 0) {
            self.greatL.backgroundColor = CBlackColor;
        }
    }
    if(model.minRose <0){
        self.worstL.backgroundColor = CRedColor;
        self.worstL.text =[NSString stringWithFormat:@"%@%%",@(model.minRose).p2fString];
    }else{
        self.worstL.backgroundColor =CGreenColor;
        self.worstL.text =[NSString stringWithFormat:@"+%@%%",@(model.minRose).p2fString];
        if (model.minRose == 0) {
            self.worstL.backgroundColor = CBlackColor;
        }
    }
}

@end
