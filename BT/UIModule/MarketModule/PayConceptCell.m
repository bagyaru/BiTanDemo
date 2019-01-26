//
//  MyOptionCell.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PayConceptCell.h"
#import "BTCurrencyPairSecondLabel.h"

@interface PayConceptCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrencyPairfirst;

//@property (weak, nonatomic) IBOutlet UILabel *labelUpAndDown;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnDownAndUp;
@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelCount;


@property (nonatomic, strong) NSString *strLiang;

@property (nonatomic, strong) NSString *strE;

@property (nonatomic, strong) NSString *strQuanwang;

@property (nonatomic, assign) BOOL isCNY;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;


@end

@implementation PayConceptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.strLiang = [APPLanguageService sjhSearchContentWith:@"liang"];
    self.strE =  [APPLanguageService sjhSearchContentWith:@"e"];
    self.strQuanwang = [APPLanguageService sjhSearchContentWith:@"quanwang"];
    self.viewBg.backgroundColor = CViewBgColor;
    [AppHelper addLineWithParentView:self.contentView];
    self.labelCurrencyPairfirst.textColor = CBlackColor;
    self.labelCount.font = LastSmallFont;
    self.labelCount.textColor = CGrayColor;
    self.labelName.font = LastSmallFont;
    self.labelName.textColor = CGrayColor;
    self.labelCount.textColor = CGrayColor;
    //self.labelUpAndDown.textColor = CBlackColor;
    self.labelCurrentPrice.textColor = CGrayColor;
    //self.labelUpAndDown.adjustsFontSizeToFitWidth = YES;
    [self.btnDownAndUp setTitleColor:CWhiteColor forState:UIControlStateNormal];
    self.btnDownAndUp.backgroundColor = CRiseColor;
    ViewRadius(self.btnDownAndUp, 1);
    self.btnDownAndUp.enabled = NO;
}

- (void)setModel:(CurrencyModel *)model{
    if(model){
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",model.icon,str];
        [self.imageV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url]] placeholder:[UIImage imageNamed:@"default_coin"]];
        _model =model;
        self.labelName.text = [NSString stringWithFormat:@"%@%@",self.strQuanwang,SAFESTRING(model.kindName)];
        NSString *unit =[BTHelperMethod signStr];
        if(kIsCNY){
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverCNY]];
            self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceCNY doubleValue]]];
        }else{
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang,self.strE,[DigitalHelperService transformWith:model.volume],[DigitalHelperService transformWith:model.turnoverUSD]];
            self.labelCurrentPrice.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceUSD doubleValue]]];
        }
        if ([model.kind containsString:@"/"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.kind];
            NSRange ran = [model.kind rangeOfString:@"/"];
            [attributedString addAttributes:@{NSFontAttributeName:SmallFont,NSForegroundColorAttributeName:CGrayColor} range:NSMakeRange(ran.location, model.kind.length - ran.location)];
            self.labelCurrencyPairfirst.attributedText = attributedString;
        }else{
            self.labelCurrencyPairfirst.text =model.kind;
        }
        
        //
        //self.labelUpAndDown.text = SAFESTRING(@(model.price)).length>0? [DigitalHelperService isTransformWithDouble:model.price]:@"";
        
        //右边涨跌幅
        if (model.rose <=  0) {
            [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"-%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
//            [self.btnDownAndUp setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
//            [self.btnDownAndUp setTitleColor:CRedColor forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CFallColor;
            if (model.rose == 0) {
//                [self.btnDownAndUp setTitleColor:CBlackColor forState:UIControlStateNormal];
//                [self.btnDownAndUp setImage:nil forState:UIControlStateNormal];
            }
            
        }else{
            [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
//            [self.btnDownAndUp setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
//            [self.btnDownAndUp setTitleColor:CGreenColor forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CRiseColor;
            
        }
        
        //设置变动颜色
        switch (model.type) {
//            case UpAndDownTypeNoUpAndDown:
//                //self.labelUpAndDown.textColor = CBlackColor;
//                self.labelCurrentPrice.textColor = CBlackColor;
//                
//                break;
            case UpAndDownTypeUp:
                //self.labelUpAndDown.textColor = CGreenColor;
                self.labelCurrentPrice.textColor = CGreenColor;
                break;
            case UpAndDownTypeDown:
                //self.labelUpAndDown.textColor = CRedColor;
                self.labelCurrentPrice.textColor = CRedColor;
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
}


@end
