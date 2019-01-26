//
//  BTViewRotationHeader.m
//  BT
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTViewRotationHeader.h"

@interface BTViewRotationHeader()
@property (weak, nonatomic) IBOutlet UILabel *labelRotationName;

@property (weak, nonatomic) IBOutlet UILabel *labelRotationPrice;

@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet UILabel *labelRotationRate;

@property (weak, nonatomic) IBOutlet UILabel *upAndDownL;

@property (weak, nonatomic) IBOutlet UILabel *labelRotationTime;

@property (weak, nonatomic) IBOutlet BTLabel *countL;

@property (weak, nonatomic) IBOutlet UILabel *labelE;

@property (weak, nonatomic) IBOutlet UILabel *highL;

@property (weak, nonatomic) IBOutlet BTLabel *lowL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLeftCons;
@property (weak, nonatomic) IBOutlet UIButton *shupingBtn;



@property (nonatomic, strong)NSTimer *timerOfTime;


@end
@implementation BTViewRotationHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.shupingBtn setImage:[UIImage imageNamed:@"ic_shuping"] forState:UIControlStateNormal];
}

//退出全屏
- (IBAction)exitFullScreen:(id)sender {
    if([self.delegate respondsToSelector:@selector(exitFullScreen )]){
        [self.delegate exitFullScreen];
    }
}
//- (void)setCryModel:(CurrencyModel *)cryModel{
//    _cryModel = cryModel;
//    if (self.cryModel.rose > 0) {
//        self.labelRotationRate.text = [NSString stringWithFormat:@"+%@%%",@(self.cryModel.rose).p2fString];
//    }else{
//        self.labelRotationRate.text = [NSString stringWithFormat:@"%@%%",@(self.cryModel.rose).p2fString];
//    }
//    self.labelRotationName.text =cryModel.kind;
//    NSString *str = @"";
//    NSString *priceStr;
//    if (kIsCNY) {
//        str = @"¥";
//        priceStr =[NSString stringWithFormat:@"%.2f",[self.cryModel.priceCNY floatValue]];
//    }else{
//        str = @"$";
//        priceStr =[NSString stringWithFormat:@"%.2f",[self.cryModel.priceUSD floatValue]];
//    }
//    self.labelRotationPrice.text = [NSString stringWithFormat:@"%@%@",str,priceStr];
//
//    self.labelRotationTime.text = [[NSDate date] stringWithFormat:@"HH:mm:ss"];
//    if (self.cryModel.rose > 0){
////        self.labelRotationUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
//    }else{
//        if (self.cryModel.rose == -100) {
//
////            self.labelRotationUpAndDown.text = @"0";
//
//        }else{
////            self.labelRotationUpAndDown.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
//        }
//    }
//    [self startTimeForTime];
//}

//- (void)startTimeForTime{
//    if (!_timerOfTime) {
//        _timerOfTime = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timerOfTime forMode:NSRunLoopCommonModes];
//    }
//}
//
//- (void)changeTime:(NSTimer *)timeOfTime{
//    self.labelRotationTime.text = [[NSDate date] stringWithFormat:@"HH:mm:ss"];
//
//}
//
//- (void)stopTimeForTime{
//    [_timerOfTime invalidate];
//    _timerOfTime = nil;
//}

- (void)setCryModel:(CurrencyModel *)cryModel{
    
    _cryModel = cryModel;
    BOOL isShizhi  = ![self.cryModel.kindCode containsString:@"/"];
    if (self.cryModel == nil) {
        return;
    }
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    
    self.labelRotationName.text = cryModel.kind;
    if (isShizhi) {
        //    self.labelPrice.hidden = YES;
        
        if (kIsCNY) {
            self.highL.text =[DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceCNY];
            self.lowL.text =[DigitalHelperService isTransformWithDouble:self.cryModel.minPriceCNY];
            if (self.cryModel.maxPriceCNY == 0 && self.cryModel.minPriceCNY == 0) {
                //            [self noQutailsHeader];
            }
        }else{
            self.highL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceUSD];
            self.lowL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPriceUSD];
            if (self.cryModel.maxPriceUSD == 0 && self.cryModel.minPriceUSD == 0) {
                //            [self noQutailsHeader];
            }
        }
        
    }else{
        self.priceL.hidden = NO;
        self.highL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPrice];
        self.lowL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPrice];
        if (self.cryModel.maxPrice == 0 && self.cryModel.minPrice == 0) {
            //        [self noQutailsHeader];
        }
    }
    
    self.highL.text = [NSString stringWithFormat:@"%@%@",str,self.highL.text];
    self.lowL.text =[NSString stringWithFormat:@"%@%@",str,self.lowL.text];
    
    if (self.cryModel.rose > 0) {
        self.labelRotationRate.text = [NSString stringWithFormat:@"+%@%%",@(self.cryModel.rose).p2fString];
    }else{
        self.labelRotationRate.text = [NSString stringWithFormat:@"%@%%",@(self.cryModel.rose).p2fString];
    }
    if ([self.cryModel.kindCode containsString:@"/"]) {
        [self haveRelationSet];
    }else{
        [self noHaveRelationSet];
    }
    //
    if(isShizhi){
        self.countL.text = [DigitalHelperService transformWith:self.cryModel.volume];
        if(kIsCNY){
            self.labelE.text = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:self.cryModel.turnoverCNY]];
        }else{
            self.labelE.text =[NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:self.cryModel.turnoverUSD]];
        }
    }else{//交易对
        
        NSString *fh_str = @"";
        if (kIsCNY) {
            fh_str = [NSString stringWithFormat:@"¥%@",[DigitalHelperService transformWith:self.cryModel.legalTendeCNY*self.cryModel.volume]];
            
        }else{
            fh_str = [NSString stringWithFormat:@"$%@",[DigitalHelperService transformWith:self.cryModel.legalTendeUSD*self.cryModel.volume]];
        }
        NSArray *kinds =[self.cryModel.kindCode componentsSeparatedByString:@"/"];
        NSString *unitKey = [kinds firstObject];
        self.countL.text = [NSString stringWithFormat:@"%@%@",[DigitalHelperService transformWith:self.cryModel.volume],SAFESTRING(unitKey)];
        
        self.labelE.text = fh_str;
    }
}

//交易对
- (void)haveRelationSet{
    //    BOOL isShizhi  = ![self.cryModel.kindCode containsString:@"/"];
    self.priceL.hidden = NO;
    self.labelRotationPrice.text = [DigitalHelperService isTransformWithDouble:self.cryModel.price];
    
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    if (kIsCNY) {
        self.priceL.text = [NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY]];
    }else{
        self.priceL.text =[NSString stringWithFormat:@"%@%@",str, [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD]];
    }
    
    if (self.cryModel.rose > 0){
        if (kIsCNY) {
            self.upAndDownL.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
        }else{
            
            self.upAndDownL.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
        }
        
    }else{
        if (self.cryModel.rose == -100) {
            self.upAndDownL.text = @"0";
            return;
        }
        if (kIsCNY) {
            self.upAndDownL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
        }else{
            
            self.upAndDownL.text = [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
        }
    }
}

//市值
- (void)noHaveRelationSet{
    self.priceL.hidden = YES;
    self.secondLeftCons.constant = 0;
    
    NSString *str =@"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    if (kIsCNY) {
        self.labelRotationPrice.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]]];
        if (self.cryModel.rose > 0){
            
            self.upAndDownL.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
        }else{
            if (self.cryModel.rose == - 100) {
                self.upAndDownL.text = @"0";
                return;
            }
            
            self.upAndDownL.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
        }
    }else{
        self.labelRotationPrice.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue]]] ;
        if (self.cryModel.rose > 0) {
            
            self.upAndDownL.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0]];
        }else{
            self.upAndDownL.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0];
        }
    }
}


@end
