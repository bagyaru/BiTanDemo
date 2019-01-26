//
//  AnalyseBaseDataTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AnalyseBaseDataTableViewCell.h"

#import "DetailHelper.h"
#import "BTPingjiViewCell.h"

@interface AnalyseBaseDataTableViewCell ()

@property (nonatomic,strong) UILabel *rightTimeLabel;
@property (nonatomic, strong) BTPingjiViewCell *pingjiView;
@property (nonatomic,strong) NSMutableArray *descLabelArr;

@end


@implementation AnalyseBaseDataTableViewCell{
    UILabel *mainTipLable;
}

- (NSMutableArray *)descLabelArr{
    if (!_descLabelArr) {
        _descLabelArr = [NSMutableArray array];
    }
    return _descLabelArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.pingjiView];
        self.pingjiView.frame = CGRectMake(0, 0, ScreenWidth, 40);
//        [self.pingjiView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.height.mas_equalTo(40.0f);
//        }];
        
        mainTipLable = [UILabel new];
        [self.contentView addSubview:mainTipLable];
        mainTipLable.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        mainTipLable.textColor = kHEXCOLOR(0x111210);
        mainTipLable.text = [APPLanguageService wyhSearchContentWith:@"jichushuju"];
        [mainTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(RELATIVE_WIDTH(10) +40);
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        UILabel *rightTimeLabel = [UILabel new];
        [self.contentView addSubview:rightTimeLabel];
        rightTimeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        rightTimeLabel.textColor = kHEXCOLOR(0x666666);
        rightTimeLabel.text = @"--";
        [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-RELATIVE_WIDTH(15));
            make.centerY.equalTo(mainTipLable);
            make.height.mas_equalTo(RELATIVE_WIDTH(17));
        }];
        self.rightTimeLabel = rightTimeLabel;
        
        UIView *firstLineView = [UIView new];
        firstLineView.backgroundColor = SeparateColor;
        [self.contentView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self);
            make.top.equalTo(mainTipLable.mas_bottom).offset(RELATIVE_WIDTH(9));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        UIView *verLineView = [UIView new];
        [self.contentView addSubview:verLineView];
        verLineView.backgroundColor = SeparateColor;
        [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstLineView.mas_bottom);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(RELATIVE_WIDTH(0.5));
            make.height.mas_equalTo(RELATIVE_WIDTH(90));
        }];
        NSArray *tipLabeltextArr =@[[APPLanguageService wyhSearchContentWith:@"shangjiajiaoyisou"],[APPLanguageService wyhSearchContentWith:@"qian10jiaoyisuo"],[APPLanguageService wyhSearchContentWith:@"dangqianliutonglv"],[APPLanguageService wyhSearchContentWith:@"24hhuanshoul"],[APPLanguageService wyhSearchContentWith:@"chibidizhishu"],[APPLanguageService wyhSearchContentWith:@"qian10mingchibi"]];
        //        NSArray *desctitleArr = @[@"197",@"10",@"81.24%",@"88.88%",@"12345667890",@"12.83%"];
        UIView *leftView = self;
        UIView *topView = firstLineView;
        for (int i = 0; i<tipLabeltextArr.count;i++) {
            UILabel *tipLabel = [UILabel new];
            [self.contentView addSubview:tipLabel];
            
            //分割线
            UIView *separateLineView = [UIView new];
            
            [self.contentView addSubview:separateLineView];
            separateLineView.backgroundColor = firstLineView.backgroundColor;
            if (i!=0 && i%2 == 0) {
                [separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(firstLineView.mas_bottom).offset(RELATIVE_WIDTH(30*i/2));
                    make.right.equalTo(self);
                    make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
                    make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
                }];
                
                topView = separateLineView;
            }
            
            
            tipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            tipLabel.textColor = kHEXCOLOR(0x666666);
            tipLabel.text = tipLabeltextArr[i];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i%2==1) {
                    make.left.equalTo(verLineView.mas_right).offset(RELATIVE_WIDTH(15));
                }else{
                    make.left.equalTo(leftView).offset(RELATIVE_WIDTH(15));
                }
                make.top.equalTo(topView.mas_bottom).offset(RELATIVE_WIDTH(7));
                make.height.mas_equalTo(RELATIVE_WIDTH(17));
            }];
            
            UILabel *descLabel = [UILabel new];
            [self.contentView addSubview:descLabel];
            descLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            descLabel.textColor = kHEXCOLOR(0x111210);
            descLabel.text = @"--";//desctitleArr[i];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i%2 == 0) {
                    make.right.equalTo(verLineView.mas_left).offset(RELATIVE_WIDTH(-15));
                }else{
                    make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
                }
                make.centerY.equalTo(tipLabel);
                make.height.mas_equalTo(RELATIVE_WIDTH(17));
            }];
            
            [self.descLabelArr addObject:descLabel];
        }
        
    }
    return self;
}
//
- (void)setInfo:(BTCoinBaseInfo *)info{
    if(!info) return;
    _info = info;
    if(SAFESTRING(self.info.reputation).length == 0){
        self.pingjiView.hidden = YES;
        [mainTipLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(RELATIVE_WIDTH(10));
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
    }else{
        self.pingjiView.hidden = NO;
        self.pingjiView.rateView.currentScore = [self numOfType:self.info.reputation];
    }
    NSDate *date = [NSDate date];
    NSString *dateFormatter = @"yyyy-MM-dd HH:mm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    NSString *dateStr = [formatter stringFromDate:date];
    self.rightTimeLabel.text = dateStr;
    
    NSString *address;
    if(SAFESTRING(@(info.addressNum)).length >0 && ![SAFESTRING(@(info.addressNum))isEqualToString:@"0"]){
        address = [DigitalHelperService analyseTransformWith:[@(info.addressNum) doubleValue]];
    }else{
        address = [DetailHelper processData:SAFESTRING(@(info.addressNum))];
    }
    NSArray *arr = @[[DetailHelper processData:SAFESTRING(@(info.exchangeAmount))],[DetailHelper processData:SAFESTRING(@(info.topTenExchangeNum))],[DetailHelper processData:SAFESTRING(info.floatRate)],[DetailHelper processData:SAFESTRING(info.changeRate)],address,[DetailHelper processData:SAFESTRING(info.topTenAddressRate)]];
    for (int i =0;i<self.descLabelArr.count;i++) {
        UILabel *label = self.descLabelArr[i];
        label.text = arr[i];
    }
}


- (BTPingjiViewCell*)pingjiView{
    if(!_pingjiView){
        _pingjiView = [BTPingjiViewCell loadFromXib];
    }
    return _pingjiView;
}
- (NSInteger)numOfType:(NSString*)type{
    NSDictionary *dict = @{@"OK":@(5),@"NEUTRAL":@(4),@"UNKNOWN":@(3),@"SPAM":@(2),@"SUSPICIOUS":@(1),@"UNSAFE":@(0)};
    NSNumber *num = dict[type];
    return [num integerValue];
}

@end
