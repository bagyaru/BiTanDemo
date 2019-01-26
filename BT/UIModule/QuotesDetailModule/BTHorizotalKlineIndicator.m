//
//  BTHorizotalKlineIndicator.m
//  BT
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHorizotalKlineIndicator.h"

@interface BTHorizotalKlineIndicator()


@property (weak, nonatomic) IBOutlet UILabel *labelWarningOpen;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningHigh;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningMin;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningClose;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *lableCountRotation;

@property (weak, nonatomic) IBOutlet UILabel *zhenfuL;

@property (weak, nonatomic) IBOutlet BTLabel *zfL;

@property (weak, nonatomic) IBOutlet UILabel *changeRateL;

@property (weak, nonatomic) IBOutlet BTLabel *timeL;


@end

@implementation BTHorizotalKlineIndicator

- (void)setModel:(Y_KLineModel *)model{
    _model = model;
    
    if(model){
        Y_KLineModel *entity = model;
        NSString *time = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy-MM-dd HH:mm"];
        if ([entity isKindOfClass:[Y_KLineModel class]]) {
            
            self.labelWarningOpen.text = [DigitalHelperService isTransformWithDouble:entity.Open.doubleValue];;
            self.labelWarningHigh.text = [DigitalHelperService isTransformWithDouble:entity.High.doubleValue];
            self.labelWarningMin.text = [DigitalHelperService isTransformWithDouble:entity.Low.doubleValue];
            self.labelWarningClose.text = [DigitalHelperService isTransformWithDouble:entity.Close.doubleValue];
//            self.labelTime.text = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy.MM.dd HH:mm"];
            self.lableCountRotation.text = @(entity.Volume).p2fString;
            self.zhenfuL.text = SAFESTRING(entity.rate);
            self.zfL.text = SAFESTRING(entity.riseRate);
            self.timeL.text = time;
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
        }
    }
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



@end
