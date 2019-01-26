//
//  OptionSearchCell.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OptionSearchCell.h"
#import "BTCurrencyPairFirstLabel.h"
#import "BTCurrencyPairSecondLabel.h"

@interface OptionSearchCell ()

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
@property (weak, nonatomic) IBOutlet UIImageView *coinImageV;

@end

@implementation OptionSearchCell

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
    
    self.viewBg.backgroundColor = CViewBgColor;
    
    self.labelCurrencyPairfirst.textColor = CBlackColor;
    self.lableCurrencyPairSecond.textColor = SecondTextColor;
    self.labelCount.font = LastSmallFont;
    self.labelCount.textColor = SecondTextColor;
    self.labelName.font = LastSmallFont;
    self.labelName.textColor = SecondTextColor;
    self.labelCount.textColor = SecondTextColor;
    self.labelUpAndDown.textColor = CBlackColor;
    self.labelCurrentPriceInfo.textColor = CGrayColor;
    self.labelCurrentPrice.textColor = SecondTextColor;
    self.labelUpAndDown.adjustsFontSizeToFitWidth = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [AppHelper addSeparateLineWithParentView:self.contentView];
    
    //防止多次重复点击
    self.btnDownAndUp.ts_acceptEventInterval = 3.0f;
}

- (void)setIsCNY:(BOOL)isCNY{
    _isCNY = isCNY;
    [DigitalHelper shareInstance].isCNY = _isCNY;
}

- (void)setModel:(CurrentcyModel *)model{
    if (model) {
        _model = model;
        model.icon = SAFESTRING(model.icon);
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",model.icon,str];
        NSString *imageUrl = [model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
        [self.coinImageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_coin"]];
        NSString *kindCode;
        if (model.currencyCode.length >0) {
            kindCode = model.currencyCode;
            if (model.currencyCodeRelation.length > 0) {
                kindCode = [NSString stringWithFormat:@"%@/%@",kindCode,model.currencyCodeRelation];
            }
        }
        NSString *name;
        if(kIszh_hans){
            name = model.currencyChineseName;
        }else{
            name = model.currencyEnglishName;
        }
        
        //是否已经添加自选了
        if(model.isExist == 1){
            [self.btnDownAndUp setImage:[UIImage imageNamed:@"ic_zixuan-xuanzhong"] forState:UIControlStateNormal];
        }else{
            [self.btnDownAndUp setImage:[UIImage imageNamed:@"ic_zixuan"] forState:UIControlStateNormal];
        }
        
        if (self.isZiXuan) {
            
            NSString *exchangeName = [NSString stringWithFormat:@"%@,",[APPLanguageService sjhSearchContentWith:@"quanwang"]];
            
            if ([kindCode containsString:@"/"]) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:kindCode];
                NSRange ran = [kindCode rangeOfString:@"/"];
                [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:SecondTextColor} range:NSMakeRange(ran.location, kindCode.length - ran.location)];
                self.labelCurrencyPairfirst.attributedText = attributedString;
                self.labelName.text = [NSString stringWithFormat:@"%@%@",exchangeName,name];
                
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
         
                self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];//,self.strE [DigitalHelperService transformWith:model.turnover]
                if (model.price > 1) {
                    self.labelUpAndDown.text = @(model.price).p2fString;
                }else if(model.price < 1){
                    self.labelUpAndDown.text = @(model.price).p8fString;
                }else{
                    self.labelUpAndDown.text = @(model.price).stringValue;
                }
                
                self.labelUpAndDown.hidden = NO;
                self.constriantVer.active = NO;
                self.constraintCurrentPrice.active = YES;
                self.labelCurrentPrice.font = FONTOFSIZE(10.0f);
                self.labelCurrentPriceInfo.font = FONTOFSIZE(10.0f);
                
            }else{//市值
                self.labelName.text = [NSString stringWithFormat:@"%@%@",exchangeName,name];
                self.labelCurrencyPairfirst.text = model.currencyCode;
                if (self.isCNY) {
                    
                    NSString *unit =@"¥";
                    self.labelUpAndDown.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:model.legalTendeCNY]];
                    self.labelCurrentPriceInfo.text = @"$";
                    self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isTransformWithDouble:model.legalTendeUSD]];

//                    self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverCNY]];
                    self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];

                    //self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverCNY]];


                     self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];
                    
                }else{
                    
                    NSString *unit =@"$";
                    self.labelUpAndDown.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:model.legalTendeUSD]];
                    
                    self.labelCurrentPriceInfo.text = @"¥";
                    self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isTransformWithDouble:model.legalTendeCNY]];
//                    self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverUSD]];
                    self.labelCount.text = [NSString stringWithFormat:@"%@%@",self.strLiang,[DigitalHelperService transformWith:model.volume]];
                }
            }
            
            
        }
        
        
    }
}



- (IBAction)btnClick:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickWithModel:)]){
        [self.delegate clickWithModel:self.model];
    }
}



@end
