//
//  BTDiscoveryMainCell.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDiscoveryMainCell.h"

@interface BTDiscoveryMainCell()

@property (weak, nonatomic) IBOutlet UILabel *sortL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortLW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLLeft;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *nameDetailL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLeftConstant;
@property (weak, nonatomic) IBOutlet UILabel *bottomPriceL;
@property (weak, nonatomic) IBOutlet UILabel *hslL;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGradient;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (nonatomic, strong) NSString *strLiang;
@property (nonatomic, strong) NSString *strE;
@end
@implementation BTDiscoveryMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.sortL.layer.cornerRadius = 1.0f;
//    self.sortL.layer.masksToBounds = YES;
//    self.sortL.backgroundColor = CRiseColor;
    self.countL.hidden = YES;
    ViewRadius(self.rateBtn, 1);
    ViewRadius(self.sortL, 1);
    self.rateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.rateBtn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
    self.priceL.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    self.priceLeftConstant.constant = RELATIVE_WIDTH(168);
    self.rateBtn.backgroundColor = CRiseColor;
    [self.rateBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
    self.strLiang = [APPLanguageService sjhSearchContentWith:@"liang"];
    self.strE = [APPLanguageService sjhSearchContentWith:@"e"];
    self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, self.frame.size.height);
    
}

- (void)setModel:(QutoesDetailMarket *)model{
    if(model){
        _model = model;
        [self gradientMoveAnimationWith:model.type];
        self.sortL.text = SAFESTRING(@(self.index+1));
        //self.sortL.backgroundColor = self.selectedIndex == 1 ? CRiseColor : CFallColor;
        self.nameL.text = model.kind;
        model.icon = SAFESTRING(model.icon);
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.icon]] placeholderImage:[UIImage imageNamed:@"default_coin"]];
        NSString *unit = @"";
        if(kIsCNY){
            unit =@"¥";
            self.priceL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[SAFESTRING(model.priceCNY) doubleValue]]];
            self.bottomPriceL.text=[NSString stringWithFormat:@"%@%@",@"$",[DigitalHelperService isTransformWithDouble:[SAFESTRING(model.priceUSD) doubleValue]]];
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang ,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverCNY]];
        }else{
            unit =@"$";
            self.priceL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[SAFESTRING(model.priceUSD) doubleValue]]];
            self.bottomPriceL.text=[NSString stringWithFormat:@"%@%@",@"¥",[DigitalHelperService isTransformWithDouble:[SAFESTRING(model.priceCNY) doubleValue]]];
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang ,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverUSD]];
        }
        
        //数量
        //self.countL.text = [NSString stringWithFormat:@"24H量 %@",[DigitalHelperService transformWith:model.volume]];
        
        if (self.selectedIndex == 3 || self.selectedIndex == 4) {//换手率榜
            self.hslL.hidden    = NO;
            self.rateBtn.hidden = YES;
            if (self.selectedIndex == 3) {//成交额榜
                
                if(kIsCNY){
                    
                    self.hslL.text      = [NSString stringWithFormat:@"%@",[DigitalHelperService transformWith:model.turnoverCNY]];
                }else {
                    
                    self.hslL.text      = [NSString stringWithFormat:@"%@",[DigitalHelperService transformWith:model.turnoverUSD]];
                }
            }else {
                
                self.hslL.text      = [NSString stringWithFormat:@"%@%%",@(model.rose).p2fString];
            }
        }else if (self.selectedIndex == 10) {//涨幅分布详情
            
            self.hslL.hidden        = YES;
            self.rateBtn.hidden     = NO;
            self.sortLW.constant    = 0;
            self.nameLLeft.constant = 0;
            if (model.rose <  0) {
                [self.rateBtn setTitle:[NSString stringWithFormat:@"-%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
                self.rateBtn.backgroundColor = CFallColor;
                
            }else{
                [self.rateBtn setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                self.rateBtn.backgroundColor = CRiseColor;
                if (model.rose < 0.01) {
                    self.rateBtn.backgroundColor = CNoChangeColor;
                    [self.rateBtn setTitle:[NSString stringWithFormat:@"%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
                }
            }
            
            
        }else {//涨幅榜 跌幅榜
            //涨跌幅
            self.hslL.hidden    = YES;
            self.rateBtn.hidden = NO;
            if (model.rose <  0) {
                [self.rateBtn setTitle:[NSString stringWithFormat:@"-%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
                self.rateBtn.backgroundColor = CFallColor;

            }else{
                [self.rateBtn setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                self.rateBtn.backgroundColor = CRiseColor;
                if (model.rose < 0.01) {
                    self.rateBtn.backgroundColor = CNoChangeColor;
                    [self.rateBtn setTitle:[NSString stringWithFormat:@"%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
                }
            }
        }
        //设置变动颜色
        switch (model.type) {
//            case D_UpAndDownTypeNoUpAndDown:
//                //self.coinPriceL.textColor = CBlackColor;
//                self.priceL.textColor = CBlackColor;
//                self.bottomPriceL.textColor = ThirdDayColor;
//                
//                break;
            case D_UpAndDownTypeUp:
                //self.coinPriceL.textColor = CGreenColor;
                self.priceL.textColor = CGreenColor;
                self.bottomPriceL.textColor = CGreenColor;
                break;
            case D_UpAndDownTypeDown:
                //self.coinPriceL.textColor = CRedColor;
                self.priceL.textColor = CRedColor;
                self.bottomPriceL.textColor = CRedColor;
                break;
                
            default:
                break;
        }
    }
    
}
- (void)gradientMoveAnimationWith:(NSInteger)type{
    switch (type) {
        case D_UpAndDownTypeUp:{
            self.imageViewGradient.image = CGreenBackgroundImage;
            [UIView animateWithDuration:1.0f animations:^{
                self.imageViewGradient.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            } completion:^(BOOL finished) {
                self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            }];
        }
            break;
        case D_UpAndDownTypeDown:{
            self.imageViewGradient.image = CRedBackgroundImage;
            [UIView animateWithDuration:1.0f animations:^{
                self.imageViewGradient.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            } completion:^(BOOL finished) {
                self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            }];
        }
            
        default:
            break;
    }
}


-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}


@end
