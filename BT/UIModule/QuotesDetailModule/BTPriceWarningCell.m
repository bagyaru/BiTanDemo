//
//  BTPriceWarningCell.m
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPriceWarningCell.h"

#define NUMBERS_DIGIT @"0123456789."
@interface BTPriceWarningCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@end

@implementation BTPriceWarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _priceTf.delegate = self;
    _priceTf.textColor = FirstColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_priceTf];
//    [self.priceTf setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.priceTf setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.switchBtn setImage:IMAGE_NAMED(@"个人-开关-关闭") forState:UIControlStateNormal];
    [self.switchBtn setImage:IMAGE_NAMED(@"个人-开关-开启") forState:UIControlStateSelected];
}

- (void)setModel:(BTPriceWarningModel *)model{
    if(model){
        _model = model;
        _nameL.text =  model.name;
        _unitL.text = model.unit;
        _priceTf.placeholder = model.placeHolder;
         [_priceTf setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
        if(![SAFESTRING(model.value) isEqualToString:@"0"]){
            _priceTf.text = [DigitalHelperService formartScientificNotationWithString:model.value];
        }
        if(model.isSwitch){
            _switchBtn.selected = model.isSwitch;
        }
        if(model.index == 2){
            _unitL.textColor = CRiseColor;
            
        }else if(model.index ==3){
             _unitL.textColor = CFallColor;
        }else{
            _unitL.textColor = FirstColor;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _model.value = textField.text;
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
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_DIGIT]invertedSet];
    
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    if(!basicTest) {
        return NO;
        
    }
    //
    return YES;
}

- (void)textFiledEditChanged:(NSNotification *)obj {
    _switchBtn.selected = self.priceTf.text.length>0;
    _model.isSwitch = _switchBtn.selected;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn =(UIButton*)sender;
    btn.selected =!btn.isSelected;
    _model.isSwitch = btn.isSelected;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
