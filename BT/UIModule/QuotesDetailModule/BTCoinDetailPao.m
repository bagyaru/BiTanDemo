//
//  BTCoinDetailPao.m
//  BT
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinDetailPao.h"

@interface BTCoinDetailPao()

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet BTLabel *labelUpAndDown;
@property (weak, nonatomic) IBOutlet BTLabel *labelUpAndDownRate;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, assign) BOOL isShizhi;

@end

@implementation BTCoinDetailPao


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setCryModel:(CurrencyModel *)cryModel{
    _cryModel = cryModel;
    NSString *kindCode = cryModel.kindCode;
    NSString *kind;
    if([SAFESTRING(kindCode) containsString:@"/"]){
        kind = [[kindCode componentsSeparatedByString:@"/"] firstObject];
    }else{
        kind = SAFESTRING(kindCode);
    }
    if(self.isPriceWarning){
        if ([kindCode containsString:@"/"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:kindCode];
            NSRange ran = [kindCode rangeOfString:@"/"];
            [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, kindCode.length - ran.location)];
            self.labelPriceTwo.attributedText = attributedString;
        }else{
            self.labelPriceTwo.text = kindCode;
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@%@_%@",PhotoImageURL,@"coin",kind.lowercaseString];
    [self.imageV setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"default_coin"]];
    [self setHeader];
}

- (void)setHeader{
    self.isShizhi  = ![self.cryModel.kindCode containsString:@"/"];
    if (self.cryModel == nil) {
        return;
    }
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    
    NSInteger type = 0;
    if (self.isShizhi) {
        type = [self compareShizhiPrice];
    }else{
        type = [self comparePrice];
    }
    
    switch (type) {
        case 0:
            self.labelUpAndDown.textColor = CBlackColor;
            self.labelUpAndDownRate.textColor = CBlackColor;
            self.labelPrice.textColor = CBlackColor;
            break;
        case 1:
            self.labelUpAndDown.textColor = CGreenColor;
            self.labelUpAndDownRate.textColor = CGreenColor;
            self.labelPrice.textColor = CGreenColor;
            break;
        case 2:
            self.labelUpAndDown.textColor = CRedColor;
            self.labelUpAndDownRate.textColor = CRedColor;
            self.labelPrice.textColor = CRedColor;
            
            break;
            
        default:
            break;
    }
    if (self.cryModel.rose > 0) {
        self.labelUpAndDownRate.text = [NSString stringWithFormat:@"+%@%%",@(self.cryModel.rose).p2fString];
    }else{
        self.labelUpAndDownRate.text = [NSString stringWithFormat:@"%@%%",@(self.cryModel.rose).p2fString];
    }
    if ([self.cryModel.kindCode containsString:@"/"]) {
        [self haveRelationSet];
    }else{
        [self noHaveRelationSet];
    }
}

//交易对
- (void)haveRelationSet{
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
//    if(self.isPriceWarning){
        self.labelPrice.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isTransformWithDouble:self.cryModel.price]];
//    }
//    else{
//        if (kIsCNY) {
//            self.labelPrice.text = [NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY]];
//        }else{
//            self.labelPrice.text =[NSString stringWithFormat:@"%@%@",str, [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD]];
//        }
//    }
   
    
    if (self.isShizhi) {
        NSString *str = @"";
        if (kIsCNY) {
            str = @"¥";
        }else{
            str = @"$";
        }
    }else{
        if (self.cryModel.rose > 0){
            if (kIsCNY) {
                self.labelUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
            }else{
                
                self.labelUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
            }
            
        }else{
            if (self.cryModel.rose == -100) {
                self.labelUpAndDown.text = @"0";
                return;
            }
            if (kIsCNY) {
                self.labelUpAndDown.text = [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
            }else{
                
                self.labelUpAndDown.text = [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
            }
        }
    }
}

//市值
- (void)noHaveRelationSet{
    NSString *str =@"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    if (kIsCNY) {
        self.labelPrice.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]]];
        if (self.cryModel.rose > 0){
            
            self.labelUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
        }else{
            if (self.cryModel.rose == - 100) {
                self.labelUpAndDown.text = @"0";
                return;
            }
            
            self.labelUpAndDown.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
        }
    }else{
        
        self.labelPrice.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue]]] ;
        if (self.cryModel.rose > 0) {
            
            self.labelUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0]];
        }else{
            self.labelUpAndDown.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0];
        }
    }
}

- (NSInteger)comparePrice{
    if (kIsCNY) {
        if (self.cryModel.legalTendeCNY > self.priCryModel.legalTendeCNY ) {
            return 1;
        }else if (self.cryModel.legalTendeCNY  == self.priCryModel.legalTendeCNY){
            return 0;
        }else{
            return 2;
        }
    }else{
        if (self.cryModel.legalTendeUSD  > self.priCryModel.legalTendeUSD) {
            return 1;
        }else if (self.cryModel.legalTendeUSD  == self.priCryModel.legalTendeUSD){
            return 0;
        }else{
            return 2;
        }
    }
}

- (NSInteger)compareShizhiPrice{
    if (self.priCryModel == nil) {
        return 1;
    }
    if (kIsCNY) {
        if ([self.cryModel.priceCNY doubleValue] > [self.priCryModel.priceCNY doubleValue]) {
            return 1;
        }else if ([self.cryModel.priceCNY doubleValue] == [self.priCryModel.priceCNY doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }else{
        if ([self.cryModel.priceUSD doubleValue] > [self.priCryModel.priceUSD doubleValue]) {
            return 1;
        }else if ([self.cryModel.priceUSD doubleValue] == [self.priCryModel.priceUSD doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }
}


@end
