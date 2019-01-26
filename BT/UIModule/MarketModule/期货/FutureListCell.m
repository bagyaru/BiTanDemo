//
//  MarketCell.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureListCell.h"
#import "BTCurrencyPairSecondLabel.h"
#import "BTHelperMethod.h"
@interface FutureListCell ()

@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrencyPairfirst;

@property (weak, nonatomic) IBOutlet UILabel *labelUpAndDown;

@property (weak, nonatomic) IBOutlet BTLabel *labelCurrentPriceInfo;

@property (weak, nonatomic) IBOutlet BTCurrencyPairSecondLabel *labelCount;

//价格显示
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPriceSec;



@property (weak, nonatomic) IBOutlet UIButton *btnDownAndUp;

@property (nonatomic, strong) NSString *strLiang;

@property (nonatomic, strong) NSString *strE;

@property (nonatomic, strong) NSString *shizhijing;

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (strong, nonatomic) UIImageView *imageViewGradient;




@end

@implementation FutureListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.strLiang = [APPLanguageService sjhSearchContentWith:@"liang"];
    self.strE = [APPLanguageService sjhSearchContentWith:@"e"];
    self.shizhijing = [APPLanguageService sjhSearchContentWith:@"shizhi#"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelCurrencyPairfirst.textColor = CBlackColor;
    self.labelCount.font = LastSmallFont;
    self.labelCount.textColor = SecondTextColor;
    self.labelName.font = LastSmallFont;
    self.labelName.textColor = SecondTextColor;
    self.labelUpAndDown.textColor = SecondTextColor;
    self.labelCurrentPriceInfo.textColor = CBlackColor;
    self.labelCurrentPrice.textColor = CBlackColor;
    [self.btnDownAndUp setTitleColor:CWhiteColor forState:UIControlStateNormal];
    self.btnDownAndUp.enabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnDownAndUp.titleLabel.adjustsFontSizeToFitWidth =YES;
    ViewRadius(self.btnDownAndUp, 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.labelCurrencyPairfirst.text = title;
}

- (void)setIsCNY:(BOOL)isCNY{
    _isCNY = isCNY;
    [DigitalHelper shareInstance].isCNY = _isCNY;
}

- (void)setModel:(MarketModel *)model{
    if (model) {
        //        [self gradientMoveAnimationWith:model.type];
        //市值具体数据显示
        NSString *capital;
        if(kIsCNY){
            capital = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:model.capitalization]] ;
            if(model.capitalization == 0){
                capital = @"--";
            }
        }else{
            capital = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:model.capitalizationUSD]];
            if(model.capitalizationUSD == 0){
                capital = @"--";
            }
        }
        NSString *liang =[DigitalHelperService transformWith:model.volume];
        if(model.volume == 0){
            liang = @"--";
        }
        NSString *turnover;
        if(kIsCNY){
            turnover = [DigitalHelperService transformWith:model.turnoverCNY];
            if(model.turnoverCNY == 0){
                turnover = @"--";
            }
        }else{
            turnover = [DigitalHelperService transformWith:model.turnoverUSD];
            if(model.turnoverUSD == 0){
                turnover = @"--";
            }
        }
        
        self.labelName.text = [NSString stringWithFormat:@"%@%ld,%@,%@",self.shizhijing,model.capitalizationSort,capital,model.kindName];
        self.labelCurrencyPairfirst.text = model.kindName;
        if (kIsCNY) {//人民币 上面显示人民币 下面显示美元
            self.labelCurrentPriceInfo.text = @"¥";
            if ([model.priceCNY doubleValue] > 1) {
                self.labelCurrentPrice.text = @([model.priceCNY doubleValue]).p2fString;
            }else if([model.priceCNY doubleValue] < 1){
                self.labelCurrentPrice.text = @([model.priceCNY doubleValue]).p8fString;
            }else{
                self.labelCurrentPrice.text = model.priceCNY;
            }
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang ,self.strE,liang,turnover];
            NSString *unit =@"$";
            self.labelCurrentPriceSec.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceUSD doubleValue]]];
            
        }else{//美元 上面显示美元 下面显示人民币
            self.labelCurrentPriceInfo.text = @"$";
            if ([model.priceUSD doubleValue] > 1) {
                self.labelCurrentPrice.text = @([model.priceUSD doubleValue]).p2fString;
            }else if([model.priceUSD doubleValue] < 1){
                self.labelCurrentPrice.text = @([model.priceUSD doubleValue]).p8fString;
            }else{
                self.labelCurrentPrice.text = model.priceUSD;
            }
            self.labelCount.text = [NSString stringWithFormat:@"%@/%@%@/%@",self.strLiang ,self.strE,liang,turnover];
            
            NSString *unit =@"¥";
            self.labelCurrentPriceSec.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:[model.priceCNY doubleValue]]];
            
        }
        switch (model.type) {
            case 0:
                self.labelCurrentPriceInfo.textColor = CBlackColor;
                self.labelCurrentPrice.textColor = CBlackColor;
                break;
            case 1:
                self.labelCurrentPriceInfo.textColor = CGreenColor;
                self.labelCurrentPrice.textColor = CGreenColor;
                break;
            case 2:
                self.labelCurrentPriceInfo.textColor = CRedColor;
                self.labelCurrentPrice.textColor = CRedColor;
                break;
            default:
                break;
        }
       
        if (model.rose <  0) {
             [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
            //[self.btnDownAndUp setTitleColor:CRedColor forState:UIControlStateNormal];
//            self.btnDownAndUp.backgroundColor = CRedColor;
            //[self.btnDownAndUp setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
             self.btnDownAndUp.backgroundColor =CRedColor;
        }else{
             [self.btnDownAndUp setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
//            self.btnDownAndUp.backgroundColor = CGreenColor;
//            [self.btnDownAndUp setTitleColor:CGreenColor forState:UIControlStateNormal];
            self.btnDownAndUp.backgroundColor = CGreenColor;
            
              //[self.btnDownAndUp setImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
            if (model.rose == 0) {
                [self.btnDownAndUp setTitleColor:CWhiteColor forState:UIControlStateNormal];
                 self.btnDownAndUp.backgroundColor = CNoChangeColor;
               // [self.btnDownAndUp setImage:nil forState:UIControlStateNormal];
            }
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
