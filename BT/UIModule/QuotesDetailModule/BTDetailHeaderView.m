//
//  BTDetailHeaderView.m
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDetailHeaderView.h"
#import "Y_KLineModel.h"

@interface BTDetailHeaderView()

@property (weak, nonatomic) IBOutlet BTLabel *labelPriceTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet BTLabel *labelUpAndDown;
@property (weak, nonatomic) IBOutlet BTLabel *labelUpAndDownRate;

@property (weak, nonatomic) IBOutlet BTLabel *labelCount;

@property (weak, nonatomic) IBOutlet BTLabel *labelEL;

@property (weak, nonatomic) IBOutlet BTLabel *label24BottomInfo;

@property (weak, nonatomic) IBOutlet BTLabel *label24TopInfo;

@property (weak, nonatomic) IBOutlet UILabel *label24Bottom;
@property (weak, nonatomic) IBOutlet UILabel *label24Top;

@property (nonatomic, strong) UIImageView *imageViewGradient;

@property (nonatomic, assign) BOOL isShizhi;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeaderHeightCons;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTopConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTopCons;




@property (weak, nonatomic) IBOutlet UILabel *labelWarningOpen;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningHigh;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningMin;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningClose;

//@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *lableCountRotation;

@property (weak, nonatomic) IBOutlet UILabel *zhenfuL;

@property (weak, nonatomic) IBOutlet BTLabel *zfL;

@property (weak, nonatomic) IBOutlet UILabel *changeRateL;

@property (weak, nonatomic) IBOutlet BTLabel *labelTimeL;
@property (weak, nonatomic) IBOutlet BTLabel *labelTime1L;






@property (weak, nonatomic) IBOutlet BTLabel *avePriceL;

@property (weak, nonatomic) IBOutlet BTLabel *timeL;

@property (weak, nonatomic) IBOutlet BTLabel *time1L;


@end

@implementation BTDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarningRotation:) name:NSNotification_ShowWarningRotationView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noShowWarningRotation) name:NSNotification_noShowWarningRotationView object:nil];
    self.viewWarning.hidden = YES;
    self.timelineWarningView.hidden = YES;
//    self.viewWarning.layer.cornerRadius = 2.0f;
//    self.viewWarning.layer.masksToBounds = YES;
    self.scrollViewFenshi.contentSize = CGSizeMake(ScreenWidth, 0);
    self.scrollViewFenshi.alwaysBounceVertical = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (UIImageView *)imageViewGradient{
    if (!_imageViewGradient) {
        _imageViewGradient = [[UIImageView alloc] initWithFrame:CGRectMake(- ScreenWidth, 0, ScreenWidth, 60)];
        [self addSubview:_imageViewGradient];
    }
    return _imageViewGradient;
}

- (void)gradientMoveAnimationWith:(NSInteger)type{
    switch (type) {
        case 1:{
            self.imageViewGradient.image = CGreenBackgroundImage;
            [UIView animateWithDuration:1.0f animations:^{
                self.imageViewGradient.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 60);
            } completion:^(BOOL finished) {
                self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, 60);
            }];
        }
            break;
        case 2:{
            self.imageViewGradient.image = CRedBackgroundImage;
            [UIView animateWithDuration:1.0f animations:^{
                self.imageViewGradient.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 60);
            } completion:^(BOOL finished) {
                self.imageViewGradient.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, 60);
            }];
        }
            
        default:
            break;
    }
}

- (void)setCryModel:(CurrencyModel *)cryModel{
    _cryModel = cryModel;
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
    if (self.isShizhi) {
        self.labelPrice.hidden = YES;
        
        if (kIsCNY) {
            self.label24Top.text =[DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceCNY];
            self.label24Bottom.text =[DigitalHelperService isTransformWithDouble:self.cryModel.minPriceCNY];
            if (self.cryModel.maxPriceCNY == 0 && self.cryModel.minPriceCNY == 0) {
                [self noQutailsHeader];
            }
        }else{
            self.label24Top.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceUSD];
            self.label24Bottom.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPriceUSD];
            if (self.cryModel.maxPriceUSD == 0 && self.cryModel.minPriceUSD == 0) {
                [self noQutailsHeader];
            }
        }
        
    }else{
        self.labelPrice.hidden = NO;
        self.label24Top.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPrice];
        self.label24Bottom.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPrice];
        if (self.cryModel.maxPrice == 0 && self.cryModel.minPrice == 0) {
            [self noQutailsHeader];
        }
    }
    
    self.label24Top.text = [NSString stringWithFormat:@"%@%@",str,self.label24Top.text];
    self.label24Bottom.text =[NSString stringWithFormat:@"%@%@",str,self.label24Bottom.text];
    
    NSInteger type = 0;
    if (self.isShizhi) {
        type = [self compareShizhiPrice];
    }else{
        type = [self comparePrice];
    }
    
    switch (type) {
//        case 0:
//            self.labelPriceTwo.textColor = CBlackColor;
//            self.labelUpAndDown.textColor = CBlackColor;
//            self.labelUpAndDownRate.textColor = CBlackColor;
//            self.labelPrice.textColor = CBlackColor;
//            break;
        case 1:
            self.labelPriceTwo.textColor = CGreenColor;
            self.labelUpAndDown.textColor = CGreenColor;
            self.labelUpAndDownRate.textColor = CGreenColor;
            self.labelPrice.textColor = CGreenColor;
            break;
        case 2:
            self.labelPriceTwo.textColor = CRedColor;
            self.labelUpAndDown.textColor = CRedColor;
            self.labelUpAndDownRate.textColor = CRedColor;
            self.labelPrice.textColor = CRedColor;
            
            break;
            
        default:
            break;
    }
    [self gradientMoveAnimationWith:type];
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
    if(self.isShizhi){
        self.labelCount.text = [DigitalHelperService transformWith:self.cryModel.volume];
        if(kIsCNY){
            self.labelEL.text = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:self.cryModel.turnoverCNY]];
        }else{
            self.labelEL.text = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],[DigitalHelperService transformWith:self.cryModel.turnoverUSD]];
        }
    }else{//交易对
        
        NSString *fh_str = @"";
        if (kIsCNY) {
            fh_str = [NSString stringWithFormat:@"¥%@",[DigitalHelperService transformWith:self.cryModel.legalTendeCNY*self.cryModel.volume]];
            
        }else{
            fh_str = [NSString stringWithFormat:@"$%@",[DigitalHelperService transformWith:self.cryModel.legalTendeUSD*self.cryModel.volume]];
        }
        //        NSArray *kinds =[self.cryModel.kindCode componentsSeparatedByString:@"/"];
        //        NSString *unitKey = [kinds firstObject];
        //        self.labelCount.text = [NSString stringWithFormat:@"%@%@",[DigitalHelperService transformWith:self.cryModel.volume],SAFESTRING(unitKey)];
        self.labelCount.text = [NSString stringWithFormat:@"%@",[DigitalHelperService transformWith:self.cryModel.volume]];
        
        self.labelEL.text = fh_str;
    }
}

//没有则不显示
- (void)noQutailsHeader{
    //self.viewHeader.frame = CGRectMake(0, 0, ScreenWidth, 114.0f);
    //    self.label24Top.hidden = YES;
    //    self.label24TopInfo.hidden = YES;
    //    self.label24Bottom.hidden = YES;
    //    self.label24BottomInfo.hidden = YES;
    //self.viewSegment.hidden = YES;
    //更新table的header
    //[self.tableViewContainer reloadData];
}

//交易对
- (void)haveRelationSet{
    self.labelPrice.hidden = NO;
    self.labelPriceTwo.text = [DigitalHelperService isTransformWithDouble:self.cryModel.price];
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
    if (kIsCNY) {
        self.labelPrice.text = [NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeCNY]];
    }else{
        self.labelPrice.text =[NSString stringWithFormat:@"%@%@",str, [DigitalHelperService isTransformWithDouble:self.cryModel.legalTendeUSD]];
    }
    if (self.isShizhi) {
        NSString *str = @"";
        if (kIsCNY) {
            str = @"¥";
        }else{
            str = @"$";
        }
        self.labelPriceTwo.text = [NSString stringWithFormat:@"%@%@",str,self.labelPriceTwo.text];
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
    self.labelPrice.hidden = YES;
    self.firstTopConst.constant = 16;
    self.thirdTopCons.constant = 58.0f;
    NSString *str =@"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
   if (kIsCNY) {
      
       self.labelPriceTwo.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]]];
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
        
        self.labelPriceTwo.text =[NSString stringWithFormat:@"%@%@",str,[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue]]] ;
//        self.labelPriceTwo.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue]];
        if (self.cryModel.rose > 0) {
            
            self.labelUpAndDown.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0]];
        }else{
            self.labelUpAndDown.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceUSD doubleValue] * self.cryModel.rose / 100.0];
        }
    }
//    if (self.isShizhi) {
//        NSString *str = @"";
//        if (kIsCNY) {
//            str = @"¥";
//        }else{
//            str = @"$";
//        }
//        self.labelPriceTwo.text = [NSString stringWithFormat:@"%@%@",str,self.labelPriceTwo.text];
//        //self.labelRotationPrice.text = self.labelPriceTwo.text;
//    }
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

- (void)noShowWarningRotation{
    if(self.type ==0){
        self.timelineWarningView.hidden = YES;
        self.viewWarning.hidden = YES;
        self.horizotalKlineIndicator.hidden = YES;
    }else{
        if(self.isFullScreen){
            self.horizotalKlineIndicator.hidden = YES;
        }else{
            self.viewWarning.hidden = YES;
        }
    }
   
}

- (void)showWarningRotation:(NSNotification *)noti{
    Y_KLineModel *entity = noti.object;
    
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeHeader = [[time componentsSeparatedByString:@" "] firstObject];
    NSString *timeTail = [[time componentsSeparatedByString:@" "] lastObject];
    
    if ([noti.object isKindOfClass:[Y_KLineModel class]]) {
        if(!entity){
            return;
        }
        if(self.type ==0){
            self.timelineWarningView.hidden = NO;
            self.viewWarning.hidden = YES;
            self.horizotalKlineIndicator.hidden = YES;
            self.avePriceL.text = [DigitalHelperService isTransformWithDouble:entity.Close.doubleValue];
            self.timeL.text = timeHeader;
            self.time1L.text = timeTail;
        }else{
            if(!self.isFullScreen){
                self.viewWarning.hidden = NO;
                self.labelWarningOpen.text = [DigitalHelperService isTransformWithDouble:entity.Open.doubleValue];;
                self.labelWarningHigh.text = [DigitalHelperService isTransformWithDouble:entity.High.doubleValue];
                self.labelWarningMin.text = [DigitalHelperService isTransformWithDouble:entity.Low.doubleValue];
                self.labelWarningClose.text = [DigitalHelperService isTransformWithDouble:entity.Close.doubleValue];
                //                self.labelTime.text = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy.MM.dd HH:mm"];
                self.lableCountRotation.text = @(entity.Volume).p2fString;
                self.zhenfuL.text = SAFESTRING(entity.rate);
                self.zfL.text = SAFESTRING(entity.riseRate);
                self.labelTimeL.text = timeHeader;
                self.labelTime1L.text = timeTail;
                if(entity.zfRate >0){
                    self.zfL.textColor = CGreenColor;
                }else if(entity.zfRate <0){
                    self.zfL.textColor = CRedColor;
                }else{
                    self.zfL.textColor = TextColor;
                }
                [self setLabelColorWithLabel:self.labelWarningHigh currentValue:entity.High.doubleValue previousValue:entity.Open.doubleValue];
                [self setLabelColorWithLabel:self.labelWarningMin currentValue:entity.Low.doubleValue previousValue:entity.Open.doubleValue];
                [self setLabelColorWithLabel:self.labelWarningClose currentValue:entity.Close.doubleValue previousValue:entity.Open.doubleValue];
            }else{
                self.horizotalKlineIndicator.hidden = NO;
                self.horizotalKlineIndicator.model = entity;
            }
        }
    }
}

- (BTHorizotalKlineIndicator*)horizotalKlineIndicator{
    if(!_horizotalKlineIndicator){
        _horizotalKlineIndicator = [BTHorizotalKlineIndicator loadFromXib];
    }
    return _horizotalKlineIndicator;
}

- (void)setLabelColorWithLabel:(UILabel*)label currentValue:(double)currentValue previousValue:(double)previousValue{
    if(currentValue > previousValue){
        label.textColor = CGreenColor;
    }else if(currentValue < previousValue){
        label.textColor = CRedColor;
    }else{
        label.textColor = TextColor;
    }
}
//- (void)setLabelColorWithLabel:(UILabel*)label currentValue:(NSNumber*)currentValue previousValue:(NSNumber*)previousValue{
//    
////    NSString *current = [DigitalHelperService isTransformWithDouble:currentValue];
////    NSString *previous = [DigitalHelperService isTransformWithDouble:previousValue];
//    
////    currentValue = [current doubleValue];
////    previousValue = [previous doubleValue];
////
//    NSComparisonResult resust = [currentValue compare:previousValue];
//    if(resust == NSOrderedDescending){
//          label.textColor = CGreenColor;
//    }else if(resust == NSOrderedAscending){
//        label.textColor = CRedColor;
//    }else{
//         label.textColor = TextColor;
//    }
////    if(currentValue > previousValue){
////        label.textColor = CGreenColor;
////    }else if(currentValue < previousValue){
////        label.textColor = CRedColor;
////    }else{
////        label.textColor = TextColor;
////    }
//}

@end
