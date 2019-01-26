//
//  BTRemindAlertView.m
//  BT
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRemindAlertView.h"
#import "MarketRealtimeRequest.h"
#define NUMBERS @"0123456789."
@interface BTRemindAlertView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentShizhiL;

@property (nonatomic, copy) remindCompletionBlcok block;
@property (nonatomic, strong)BTRemindModel *model;
@property (nonatomic, copy) NSString * price;
@end

@implementation BTRemindAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    _priceTf.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTf.delegate = self;
}
+ (void)showWithRemindModel:(BTRemindModel *)model completion:(remindCompletionBlcok)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTRemindAlertView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.block = block;
    alertView.model = model;
    [alertView show];
}

- (NSString*)shizhiWithDict:(NSDictionary*)dict{
    NSString *type = SAFESTRING(self.model.legalType);
    if([type isEqualToString:@"0"]){
        return SAFESTRING(dict[@"price"]);
        
    }else if([type isEqualToString:@"1"]){
        return SAFESTRING(dict[@"priceCNY"]);
    }else{
        return SAFESTRING(dict[@"priceUSD"]);
    }
}
- (void)requestShizhi{
    NSString *type = SAFESTRING(self.model.legalType);
    NSString *unit =@"";
    NSString *firstUnit=@"";
    if([self.model.kind containsString:@"/"]){
        NSArray *arr =[self.model.kind componentsSeparatedByString:@"/"];
        unit =[arr lastObject];
        firstUnit =[arr firstObject];
    }
    NSInteger typeS;
    NSArray *arr =@[];
    if([type isEqualToString:@"0"]){
        arr =@[self.model.kind];
        typeS =2;
    
    }else{
        arr =@[firstUnit];
        typeS =1;
    }
   
    
    MarketRealtimeRequest *marketRealtimeRequest = [[MarketRealtimeRequest alloc] initWithMarketType:typeS kindList:arr];
    [marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if([request.data isKindOfClass:[NSArray class]]){
            NSDictionary *dict = [request.data lastObject];
            NSString *price = [self shizhiWithDict:dict];
            
            
            self.currentShizhiL.text = [NSString stringWithFormat:@"当前价格:%@%@", [[DigitalHelper shareInstance] isTransformWithDouble:[price doubleValue]],unit];
            _price = price;
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
- (void)setModel:(BTRemindModel *)model{
    NSString *unit =@"";
    if([model.kind containsString:@"/"]){
        NSArray *arr =[model.kind componentsSeparatedByString:@"/"];
        unit =[arr lastObject];
    }
    _model = model;
    [self requestShizhi];
    self.nameLabel.text = unit;
    if(SAFESTRING(model.remindPrice).length>0){
        self.priceTf.text = [NSString stringWithFormat:@"%.2f",[SAFESTRING(model.remindPrice)floatValue]] ;
    }else{
        self.priceTf.text =@"";
    }
}

+ (CGRect)frameOfAlert{
    CGFloat width =ScreenWidth -2*24;
    return CGRectMake(0, 0, width, 172);
}
- (IBAction)cancel:(id)sender {
    [self __hide];
}

- (IBAction)confim:(id)sender {
    
    if(_priceTf.text.length == 0){
        [MBProgressHUD showMessageIsWait:@"请输入价格" wait:YES];
        return;
    }
    CGFloat tfValue = [_priceTf.text floatValue];
    CGFloat shizhiValue =[_price floatValue];
    
    if(tfValue>shizhiValue){
        self.model.remindType =@"0";
    }else{
        self.model.remindType =@"1";
    }
    [self __hide];
    
    if(self.model){
        self.model.remindPrice = [NSString stringWithFormat:@"%.2f",[_priceTf.text floatValue]];
    }
    if(self.block){
        self.block(self.model);
    }
}
//限制小数点位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 当前输入的字符是'.'
    if ([string isEqualToString:@"."]) {
        if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
            
            return NO;
        } else {
            
            return YES;
        }
    } else {// 当前输入的不是'.'
        if (textField.text.length == 1) {
            
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {
                
                return NO;
            }
            
            if (str != '0' && str != '1') {// 1xx或0xx
                
                return YES;
            } else {
                
                if (str == '1') {
                    
                    return YES;
                } else {
                    
                    if ([string isEqualToString:@""]) {
                        
                        return YES;
                    } else {
                        
                        return NO;
                    }
                }
            }
        }
        // 已输入的字符串中包含'.'
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            
            NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
            [str insertString:string atIndex:range.location];
            
            if (str.length >= [str rangeOfString:@"."].location + 10) {
                
                return NO;
            }
        } else {
            //限制小数点前位数
            if (textField.text.length > 7) {
                
                return range.location < 8;
            }
        }
    }
    
    NSCharacterSet*cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    if(!basicTest) {
        return NO;
        
    }
    return YES;
}


@end
