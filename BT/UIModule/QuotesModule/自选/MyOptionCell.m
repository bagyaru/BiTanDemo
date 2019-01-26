//
//  MyOptionCell.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyOptionCell.h"
#import "BTCurrencyPairFirstLabel.h"
#import "BTCurrencyPairSecondLabel.h"

@interface MyOptionCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrencyPairfirst;

@property (weak, nonatomic) IBOutlet UILabel *lableCurrencyPairSecond;

@property (weak, nonatomic) IBOutlet UILabel *labelUpAndDown;

@property (weak, nonatomic) IBOutlet BTLabel *labelCurrentPriceInfo;


@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPrice;


@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelCount;


@property (weak, nonatomic) IBOutlet UIButton *btnDownAndUp;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCurrentPrice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantVer;

@property (nonatomic, strong) NSString *strLiang;

@property (nonatomic, strong) NSString *strE;

@property (nonatomic, strong) NSString *strQuanwang;

@property (strong, nonatomic)  UIImageView *imageViewGradient;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConst;

@end

@implementation MyOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (kIsCNY) {
        self.isCNY = YES;
    }
    DLog(@"cny:%@",[APPLanguageService readLegalTendeType]);
    self.strLiang = [APPLanguageService sjhSearchContentWith:@"liang"];
    self.strE =  [APPLanguageService sjhSearchContentWith:@"e"];
    
    if([[AppHelper getExchangeCode] isEqualToString:k_Net_Code]){
        self.strQuanwang = [NSString stringWithFormat:@"%@,",[APPLanguageService sjhSearchContentWith:@"quanwang"]] ;
    }else{
        self.strQuanwang = [NSString stringWithFormat:@"%@,",[AppHelper getExchangeName]] ;
    }
    
//    self.viewBg.backgroundColor = CViewBgColor;
    
    self.labelCurrencyPairfirst.textColor = kHEXCOLOR(0x333333);
    self.lableCurrencyPairSecond.textColor = SecondTextColor;
    
    self.labelCount.font = LastSmallFont;
    self.labelCount.textColor = SecondTextColor;
    self.labelName.font = LastSmallFont;
    self.labelName.textColor = kHEXCOLOR(0x999999);
    
    self.labelCount.textColor = SecondTextColor;
    self.labelUpAndDown.textColor = CBlackColor;
    self.labelCurrentPriceInfo.textColor = SecondTextColor;
    
    self.labelCurrentPrice.textColor = SecondTextColor;
    self.labelUpAndDown.adjustsFontSizeToFitWidth = YES;
    [self.btnDownAndUp setTitleColor:CWhiteColor forState:UIControlStateNormal];
    self.btnDownAndUp.enabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnDownAndUp.titleLabel.adjustsFontSizeToFitWidth =YES;
    ViewRadius(self.btnDownAndUp, 2);
    
}

- (void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    if(hideLine){
        
    }
}
- (void)setIsFuture:(BOOL)isFuture{
    _isFuture = isFuture;
    if(!_isFuture){
        [AppHelper addSeparateLineWithParentView:self.contentView];
    }
}
- (void)setIsCNY:(BOOL)isCNY{
    _isCNY = isCNY;
    [DigitalHelper shareInstance].isCNY = _isCNY;
}

- (void)setModel:(CurrencyModel *)model{
    if (model) {
        model.icon = SAFESTRING(model.icon);
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",model.icon,str];
        NSString *imageUrl = [model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
        [self.coinImageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_coin"]];
        
        [self gradientMoveAnimationWith:model.type];
        if (self.isZiXuan) {
            
            NSString *exchangeName = [NSString stringWithFormat:@"%@,",SAFESTRING(model.exchangeName)];
            
            if ([model.kind containsString:@"/"]) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.kind];
                NSRange ran = [model.kind rangeOfString:@"/"];
                [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12.0f],NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, model.kind.length - ran.location)];
                self.labelCurrencyPairfirst.attributedText = attributedString;
                self.labelName.text = [NSString stringWithFormat:@"%@%@",exchangeName,model.kindName];
                
                if (self.isCNY) {
                    self.labelCurrentPriceInfo.text = @"¥";
                    if (model.legalTendeCNY > 1) {
                        self.labelCurrentPrice.text = @(model.legalTendeCNY).p2fString;
                    }else if (model.legalTendeCNY < 1) {
                        self.labelCurrentPrice.text = @(model.legalTendeCNY).p8fString;
                    }else{
                        self.labelCurrentPrice.text = @(model.legalTendeCNY).stringValue;
                    }
                    
                }else{
                    self.labelCurrentPriceInfo.text = @"$";
                    if (model.legalTendeUSD > 1) {
                        self.labelCurrentPrice.text = @(model.legalTendeUSD).p2fString;
                    }else if(model.legalTendeUSD < 1){
                        self.labelCurrentPrice.text = @(model.legalTendeUSD).p8fString;
                    }else{
                        self.labelCurrentPrice.text = @(model.legalTendeUSD).stringValue;
                    }
                    
                }
                switch (model.type) {
//                    case 0:
//                        self.labelCurrentPriceInfo.textColor = SecondTextColor;
//                        self.labelUpAndDown.textColor = CBlackColor;
//                        self.labelCurrentPrice.textColor = SecondTextColor;
//                        break;
                    case 1:
                        self.labelCurrentPriceInfo.textColor = CGreenColor;
                        self.labelUpAndDown.textColor = CGreenColor;
                        self.labelCurrentPrice.textColor = CGreenColor;
                        break;
                    case 2:
                        self.labelCurrentPriceInfo.textColor = CRedColor;
                        self.labelUpAndDown.textColor = CRedColor;
                        self.labelCurrentPrice.textColor = CRedColor;
                        break;
                    default:
                        break;
                }
                self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];//,self.strE [DigitalHelperService transformWith:model.turnover]
                if (model.price > 1) {
                    self.labelUpAndDown.text = @(model.price).p2fString;
                }else if(model.price < 1){
                    self.labelUpAndDown.text = @(model.price).p8fString;
                }else{
                    self.labelUpAndDown.text = @(model.price).stringValue;
                }
                
                if (model.rose <=  0) {
                    [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                    self.btnDownAndUp.backgroundColor = CRedColor;
                    if (model.rose == 0) {
                        self.btnDownAndUp.backgroundColor = CNoChangeColor;
                    }
                }else{
                    [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                     self.btnDownAndUp.backgroundColor = CGreenColor;
                }
                self.labelUpAndDown.hidden = NO;
                self.constriantVer.active = NO;
                self.constraintCurrentPrice.active = YES;
                self.labelCurrentPrice.font = FONTOFSIZE(10.0f);
                self.labelCurrentPriceInfo.font = FONTOFSIZE(10.0f);
                
            }else{//市值
                
                //                self.labelCurrentPrice.font = FONTOFSIZE(14.0f);
                //                self.labelCurrentPriceInfo.font = FONTOFSIZE(14.0f);
                self.labelName.text = [NSString stringWithFormat:@"%@%@",exchangeName,model.kindName];;
                //self.constriantVer.active = YES;
                //self.constraintCurrentPrice.active = NO;
                
                if (model.rose <=  0) {
                    [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                    self.btnDownAndUp.backgroundColor = CRedColor;
                    if (model.rose == 0) {
                        self.btnDownAndUp.backgroundColor =CNoChangeColor;
                    }
                    
                }else{
                    [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
                    self.btnDownAndUp.backgroundColor = CGreenColor;
                }
                //self.labelUpAndDown.hidden = YES;
                self.labelCurrencyPairfirst.text = model.kind;
                if (self.isCNY) {
                    
                    NSString *unit =@"¥";
                    self.labelUpAndDown.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceCNY doubleValue]]];
                    
                    
                    self.labelCurrentPriceInfo.text = @"$";
                    self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isTransformWithDouble:[model.priceUSD doubleValue]]];
                    
//                    if ([model.priceCNY doubleValue]> 1) {
//                        self.labelCurrentPrice.text = @([model.priceCNY doubleValue]).p2fString;
//                    }else if ([model.priceCNY doubleValue] < 1) {
//                        self.labelCurrentPrice.text = @([model.priceCNY doubleValue]).p8fString;
//                    }else{
//                        self.labelCurrentPrice.text = model.priceCNY;
//                    }
                    
                    
                    self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverCNY]];
                    switch (model.type) {
//                        case 0:
//                            self.labelCurrentPriceInfo.textColor = CBlackColor;
//                            self.labelCurrentPrice.textColor = CBlackColor;
//                            self.labelUpAndDown.textColor = CBlackColor;
//                            break;
                        case 1:
                            self.labelCurrentPriceInfo.textColor = CGreenColor;
                            self.labelCurrentPrice.textColor = CGreenColor;
                            self.labelUpAndDown.textColor = CGreenColor;
                            break;
                        case 2:
                            self.labelCurrentPriceInfo.textColor = CRedColor;
                            self.labelUpAndDown.textColor = CRedColor;
                            self.labelCurrentPrice.textColor = CRedColor;
                            break;
                        default:
                            break;
                    }
                }else{
                    
                    NSString *unit =@"$";
                    self.labelUpAndDown.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceUSD doubleValue]]];
                    
                    
                    //                    self.labelCurrentPriceInfo.text = @"$";
                    //                    self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceCNY doubleValue]]];
                    
                    
                    self.labelCurrentPriceInfo.text = @"¥";
                    self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isTransformWithDouble:[model.priceCNY doubleValue]]];
                    
                    //                    if ([model.priceUSD doubleValue] > 1) {
                    //                        self.labelCurrentPrice.text = @([model.priceUSD doubleValue]).p2fString;
                    //                    }else if(model.legalTendeUSD < 1){
                    //                        self.labelCurrentPrice.text = @([model.priceUSD doubleValue]).p8fString;
                    //                    }else{
                    //                        self.labelCurrentPrice.text = @([model.priceUSD doubleValue]).stringValue;
                    //                    }
                    self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverUSD]];
                    switch (model.type) {
//                        case 0:
//                            self.labelCurrentPriceInfo.textColor = SecondTextColor;
//                            self.labelCurrentPrice.textColor = SecondTextColor;
//                            self.labelUpAndDown.textColor = CBlackColor;
//                                break;
                        case 1:
                            self.labelCurrentPriceInfo.textColor = CGreenColor;
                            self.labelCurrentPrice.textColor = CGreenColor;
                            self.labelUpAndDown.textColor = CGreenColor;
                            
                            break;
                        case 2:
                            self.labelCurrentPriceInfo.textColor = CRedColor;
                            self.labelUpAndDown.textColor = CRedColor;
                            self.labelCurrentPrice.textColor = CRedColor;
                            break;
                        default:
                            break;
                    }
                }
               
            }
            
            return;
        }
        
        NSString *exchangeName = SAFESTRING(model.exchangeName);
        if(exchangeName.length == 0){
            exchangeName = self.strQuanwang;
        }
        self.labelName.text = [NSString stringWithFormat:@"%@%@",exchangeName,model.kindName];
        if ([model.kind containsString:@"/"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.kind];
            NSRange ran = [model.kind rangeOfString:@"/"];
            [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, model.kind.length - ran.location)];
            self.labelCurrencyPairfirst.attributedText = attributedString;
        }else{
            self.labelCurrencyPairfirst.text = model.kind;
        }
        if (self.isCNY) {
            self.labelCurrentPriceInfo.text = @"¥";
            if (model.legalTendeCNY > 1) {
                  self.labelCurrentPrice.text = @(model.legalTendeCNY).p2fString;
            }else if (model.legalTendeCNY < 1) {
                 self.labelCurrentPrice.text = @(model.legalTendeCNY).p8fString;
            }else{
                 self.labelCurrentPrice.text = @(model.legalTendeCNY).stringValue;
            }
            
        }else{
            self.labelCurrentPriceInfo.text = @"$";
            if (model.legalTendeUSD > 1) {
                self.labelCurrentPrice.text = @(model.legalTendeUSD).p2fString;
            }else if(model.legalTendeUSD < 1){
                self.labelCurrentPrice.text = @(model.legalTendeUSD).p8fString;
            }else{
                self.labelCurrentPrice.text = @(model.legalTendeUSD).stringValue;
            }
            
        }
        switch (model.type) {
//            case 0:
//                self.labelCurrentPriceInfo.textColor = SecondTextColor;
//                self.labelUpAndDown.textColor = CBlackColor;
//                self.labelCurrentPrice.textColor = SecondTextColor;
//                break;
            case 1:
                self.labelCurrentPriceInfo.textColor = CGreenColor;
                self.labelUpAndDown.textColor = CGreenColor;
                self.labelCurrentPrice.textColor = CGreenColor;
                break;
            case 2:
                self.labelCurrentPriceInfo.textColor = CRedColor;
                self.labelCurrentPrice.textColor = CRedColor;
                self.labelUpAndDown.textColor = CRedColor;
                break;
            default:
                break;
        }
        self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];//[DigitalHelperService transformWith:model.turnover] ,self.strE
        if (model.price > 1) {
            self.labelUpAndDown.text = @(model.price).p2fString;
        }else if(model.price < 1){
            self.labelUpAndDown.text = @(model.price).p8fString;
        }else{
            self.labelUpAndDown.text = @(model.price).stringValue;
        }
        
        if (model.rose <=  0) {
            [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CRedColor;
            if (model.rose == 0) {
                self.btnDownAndUp.backgroundColor =CNoChangeColor;
            }
            //            self.btnDownAndUp.backgroundColor = CRedColor;
        }else{
            [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CGreenColor;
        }
        
    }
}

- (void)setMarketModel:(QutoesDetailMarket *)marketModel{
    if (marketModel) {
        if(marketModel.isNoImage){
            self.coinImageV.hidden = YES;
            self.nameLeftConst.constant = 15.0f;
        }else{
            NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
            NSString *url =[NSString stringWithFormat:@"%@?%@",[marketModel.icon hasPrefix:@"http"]?marketModel.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,marketModel.icon],str];
            [self.coinImageV setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"default_coin"]];
        }
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",[marketModel.icon hasPrefix:@"http"]?marketModel.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,marketModel.icon],str];
        [self.coinImageV setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"default_coin"]];
        //        self.labelName.text = [NSString stringWithFormat:@"%@%@",self.strQuanwang,marketModel.exchangeName];
        self.labelName.text = self.isShiChang ? (ISNSStringValid(marketModel.kindName)?marketModel.kindName:@"  ") : marketModel.exchangeName;
        if ([marketModel.kind containsString:@"/"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:marketModel.kind];
            NSRange ran = [marketModel.kind rangeOfString:@"/"];
            [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, marketModel.kind.length - ran.location)];
            self.labelCurrencyPairfirst.attributedText = attributedString;
        }else{
            self.labelCurrencyPairfirst.text = marketModel.kind;
        }
        if (marketModel.price > 1) {
            self.labelUpAndDown.text = @(marketModel.price).p2fString;
        }else if (marketModel.price < 1){
            self.labelUpAndDown.text = @(marketModel.price).p8fString;
        }else{
            self.labelUpAndDown.text = @(marketModel.price).stringValue;
        }
        ///////////////////////
        NSString *indicatorStr = self.strLiang;
        double newValue;
        if(self.isShiZhi){
//            if(marketModel.price != 0){
//                newValue = marketModel.volume / marketModel.price;
//            }else{
                newValue = marketModel.volume;
//            }
            
            self.labelCount.text = [NSString stringWithFormat:@"%@%@",indicatorStr,[DigitalHelperService transformWith:newValue]];
        }else{
//            NSArray *kinds =[marketModel.kind componentsSeparatedByString:@"/"];
            //            NSString *unitKey =[kinds lastObject];
            newValue = marketModel.volume;
            self.labelCount.text = [NSString stringWithFormat:@"%@%@",indicatorStr,[DigitalHelperService transformWith:newValue]];
            //            self.labelCount.text = [NSString stringWithFormat:@"%@%@%@",indicatorStr,[DigitalHelperService transformWith:newValue],unitKey];
        }
        
        if (self.isCNY) {
            self.labelCurrentPriceInfo.text = @"¥";
            self.labelCurrentPrice.text = @(marketModel.legalTendeCNY).p2fString;
        }else{
            self.labelCurrentPriceInfo.text = @"$";
            self.labelCurrentPrice.text = @(marketModel.legalTendeUSD).p2fString;
            
        }
        
        
        [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(marketModel.rose).p2fString] forState:UIControlStateNormal];
        if (marketModel.rose <= 0) {
             [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(marketModel.rose).p2fString] forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CRedColor;
            if (marketModel.rose == 0) {
                self.btnDownAndUp.backgroundColor =CNoChangeColor;
            }
        }else{
            [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(marketModel.rose).p2fString] forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor =CGreenColor;
           
        }
        
    }
}

- (void)gradientMoveAnimationWith:(NSInteger)type{
    switch (type) {
        case 1:{
            self.imageViewGradient.image = CGreenBackgroundImage;
            [UIView animateWithDuration:1.0f animations:^{
                self.imageViewGradient.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            } completion:^(BOOL finished) {
                self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, self.frame.size.height);
            }];
        }
            break;
        case 2:{
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

- (UIImageView *)imageViewGradient{
    if (!_imageViewGradient) {
        _imageViewGradient = [[UIImageView alloc] initWithFrame:CGRectMake(- ScreenWidth, 0, ScreenWidth, self.frame.size.height)];
        [self addSubview:_imageViewGradient];
    }
    return _imageViewGradient;
}
@end
