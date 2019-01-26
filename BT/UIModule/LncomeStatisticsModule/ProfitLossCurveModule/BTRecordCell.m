//
//  BTRecordCell.m
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRecordCell.h"
#import "BTDeteleRecordAlert.h"
#import "BTDeleteRecordRequest.h"

@interface BTRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *statusL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *singlePriceL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
@property (weak, nonatomic) IBOutlet BTLabel *singPriceValueL;
@property (weak, nonatomic) IBOutlet BTLabel *totalPriceValueL;

@property (weak, nonatomic) IBOutlet UILabel *exchangeL;
@property (weak, nonatomic) IBOutlet UILabel *noteL;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end


@implementation BTRecordCell

- (void)setModel:(BTRecordModel *)model{
    _model =model;
    NSString *str = @"";
    NSString *unitStr =@"";
    if([model.relevantKind isEqualToString:@"CNY"]){
        str = @"¥";
        unitStr = @"";
    }else if([model.relevantKind isEqualToString:@"USD"]){
        str = @"$";
        unitStr =@"";

    }else{ //虚拟
        str= @"";
        unitStr = model.relevantKind;
    }
    
    NSString *unit;
    if(kIsCNY){
        unit =@"¥";
    }else{
        unit = @"$";
    }
    if([SAFESTRING(model.buy) isEqualToString:@"1"]){
        self.statusL.text =@"买入";
        self.statusL.layer.borderWidth = 1;
        self.statusL.layer.borderColor = kHEXCOLOR(0xc00ac1e).CGColor;
        self.statusL.textColor = kHEXCOLOR(0x00ac1e);
        self.statusL.backgroundColor =  rgba(0,172,30,0.10);
    }else{
        self.statusL.text =@"卖出";
        self.statusL.layer.borderWidth = 1;
        self.statusL.layer.borderColor = kHEXCOLOR(0xc52b18).CGColor;
        self.statusL.textColor = kHEXCOLOR(0xc52b18);
        self.statusL.backgroundColor =  rgba(197,43,24,0.10);
    }
    self.timeL.text = model.recordDate;
    //价格显示规则
    if([model.relevantKind isEqualToString:@"CNY"]||[model.relevantKind isEqualToString:@"USD"]){
        self.singlePriceL.text  = [NSString stringWithFormat:@"%@%@%@",str,[DigitalHelperService isTransformWithDouble:model.unitPrice],unitStr];
        self.totalPriceL.text = [NSString stringWithFormat:@"%@%@%@",str,[DigitalHelperService isTransformWithDouble:model.totalPrice],unitStr];
    }else{//币种
        self.singlePriceL.text  = [NSString stringWithFormat:@"%@%@%@",str,@(model.unitPrice).p8fString,unitStr];
        self.totalPriceL.text = [NSString stringWithFormat:@"%@%@%@",str,@(model.totalPrice).p8fString,unitStr];
    }
    
    self.singPriceValueL.text = [NSString stringWithFormat:@"≈%@%@",unit,[DigitalHelperService isTransformWithDouble:model.unitPriceLegalTende]];
    self.totalPriceValueL.text = [NSString stringWithFormat:@"≈%@%@",unit,[DigitalHelperService isTransformWithDouble:model.totalPriceLegalTende]];
    self.countL.text = [NSString stringWithFormat:@"%@",[DigitalHelperService isp6DataWithDouble:model.count]];
    
    if (ISNSStringValid(model.dealSourceInfo)) {
        self.exchangeL.text  = [NSString stringWithFormat:@"%@：%@",[APPLanguageService wyhSearchContentWith:@"jiaoyisuo"],model.dealSourceInfo];
    } else {
        self.exchangeL.text  = [NSString stringWithFormat:@"%@：%@",[APPLanguageService wyhSearchContentWith:@"jiaoyisuo"],[APPLanguageService wyhSearchContentWith:@"weixuanze"]];
    }
    if(SAFESTRING(model.note).length>0){
        self.noteL.text = [NSString stringWithFormat:@"%@:%@",[APPLanguageService wyhSearchContentWith:@"beizhu_New"],model.note];
    }else{
        self.noteL.text = [NSString stringWithFormat:@"%@:%@",[APPLanguageService wyhSearchContentWith:@"beizhu_New"],[APPLanguageService wyhSearchContentWith:@"wu"]];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusL.layer.cornerRadius = 2.0f;
    self.statusL.layer.masksToBounds = YES;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //设定最小的长按时间 按不够这个时间不响应手势
    longPressGR.minimumPressDuration = 1;
    [self addGestureRecognizer:longPressGR];
    [self.deleteBtn setImage:[UIImage imageNamed:@"我的帖子-删除"] forState:UIControlStateNormal];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        [BTDeteleRecordAlert showWithRecordModel:self.model completion:^(BTRecordModel *model) {
            BTDeleteRecordRequest *request =[[BTDeleteRecordRequest alloc]initWithRecord:self.model];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                if(request.data){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRecord" object:nil];
                }
            } failure:^(__kindof BTBaseRequest *request) {
                
            }];
            
        }];
    }
}

- (NSString*)decimalNumberWithDouble:(double)conversionValue{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

//删除
- (IBAction)deleteBtnClcik:(UIButton *)sender {
    
    [BTDeteleRecordAlert showWithRecordModel:self.model completion:^(BTRecordModel *model) {
        BTDeleteRecordRequest *request =[[BTDeleteRecordRequest alloc]initWithRecord:self.model];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if(request.data){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRecord" object:nil];
                
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    }];
}

//编辑
- (IBAction)walletBtn:(UIButton *)sender {
    _model.kind = [NSString stringWithFormat:@"%@/%@",self.kind,_model.relevantKind];
    [AnalysisService alaysisIncome_add_button];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@"",@"model":_model}];
}

@end
