//
//  BTCoinDetailCell.m
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinDetailCell.h"
#import "BTCoinDetailView.h"
#import "GradualChange.h"
@interface BTCoinDetailCell()

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *sortL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *rateL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UIImageView *rateImageV;
@property (weak, nonatomic) IBOutlet UIView *rateBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateImageWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspect;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageV;

@end

@implementation BTCoinDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sortL.layer.cornerRadius = 2.0f;
    self.sortL.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.masksToBounds = NO;
    
    self.bgView.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    self.bgView.layer.shadowOpacity = 0.05f;
    self.bgView.layer.shadowRadius = 6.0f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.rateBgView.layer.cornerRadius = 3.0f;
    self.rateBgView.layer.masksToBounds = YES;
}

- (void)setModel:(BTCoinDetailModel *)model{
    _model = model;
    if(model){
        self.sortL.text = SAFESTRING(@(self.index+1));
        self.addressL.text = model.address;
        self.rateL.text = [NSString stringWithFormat:@"%.2f%%",model.rate];
        self.countL.text = [NSString stringWithFormat:@"%@：%.0f",[APPLanguageService sjhSearchContentWith:@"chibishuliang"],model.quantity];
        
        self.rateImageWidthCons.constant = self.rateBgView.width * model.rate /100;
        [self.rateImageV setNeedsLayout];
        [self.rateImageV layoutIfNeeded];
        self.rateImageV.image = [GradualChange viewChangeImg:self.rateImageV.bounds isVerticalBar:NO];
        if(model.isExpand){
            self.indicatorImageV.image = [UIImage imageNamed:@"ic_shang"];
            for(UIView *view in self.contentV.subviews){
                if([view isKindOfClass:[BTCoinDetailView class]]){
                    [view removeFromSuperview];
                }
            }
            self.contentV.hidden = NO;
            NSArray *arr;
            if([model.addressDetailVoList isKindOfClass:[NSArray class]]){
                arr = [model.addressDetailVoList sortedArrayUsingComparator:^NSComparisonResult(NSDictionary*  obj1, NSDictionary* obj2) {
                    NSString *str1 = SAFESTRING(obj1[@"date"]);
                    NSString *str2 =  SAFESTRING(obj2[@"date"]);
                    NSComparisonResult result = [str1 compare:str2];
                    if(result == NSOrderedAscending){
                        return NSOrderedDescending;
                    }else  if(result == NSOrderedDescending){
                        return  NSOrderedAscending;
                    }else{
                        return NSOrderedSame;
                    }
                }];
                
                
            }else{
                arr = @[];
            }
            for(NSInteger i = 0; i < arr.count; i++){
                NSDictionary *dict = arr[i];
                BTAddressDetailModel *addressModel = [BTAddressDetailModel objectWithDictionary:dict];
                BTCoinDetailView *detailV = [BTCoinDetailView loadFromXib];
                detailV.frame = CGRectMake(0, 44 + i*30, ScreenWidth - 30, 30);
                detailV.detailModel = addressModel;
                [self.contentV addSubview:detailV];
            }
        }else{
            self.contentV.hidden = YES;
            self.indicatorImageV.image = [UIImage imageNamed:@"ic_xia"];
        }
    }
}

@end
