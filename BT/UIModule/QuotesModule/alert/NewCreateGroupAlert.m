//
//  NewCreateGroupAlert.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewCreateGroupAlert.h"
#import "UITextField+Factory.h"
@interface NewCreateGroupAlert()

@property (nonatomic, strong) BTLabel *titleLabel;
@property(nonatomic,strong) BTButton *cancelBtn;//取消
@property(nonatomic,strong) BTButton *confimBtn;//确定

@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) BTGroupListModel *model;
@property (nonatomic, copy) NewCreateGroupAlertBlock block;

@end

#define MAX_STARWORDS_LENGTH 10
@implementation NewCreateGroupAlert

+ (void)showWithModel:(BTGroupListModel *)model completion:(NewCreateGroupAlertBlock)block{
    NewCreateGroupAlert *alert = [[NewCreateGroupAlert alloc]initWithFrame:[self frameOfAlert]];
    alert.cancelBtn.fixTitle =@"cancel";
    alert.confimBtn.fixTitle =@"confirm";
    alert.titleLabel.fixText =@"newCreateGroup";
    alert.model = model;
    alert.block = block;
    
    [alert show];
}

- (void)setModel:(BTGroupListModel *)model{
    if(model){
        _model = model;
        self.nameTf.text = SAFESTRING(model.groupName);
        self.confimBtn.enabled = self.nameTf.text.length>0;
    }
}
+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 300.0f, 192.0f);
}

- (void)createView{
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    
    _titleLabel = [[BTLabel alloc]initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = CFontColor15;
    
    _nameTf = [[UITextField alloc] initWithFrame:CGRectZero];
    _nameTf.font = MainTextFont;
    _nameTf.textColor = MainTextColor;
    _nameTf.backgroundColor = kHEXCOLOR(0xF5F5F5);
    _nameTf.layer.cornerRadius = 4;
    _nameTf.layer.masksToBounds = YES;
    _nameTf.placeholder = [APPLanguageService sjhSearchContentWith:@"inputGroupName"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditCha:) name:@"UITextFieldTextDidChangeNotification" object:_nameTf];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 48)];
    _nameTf.leftView = leftView;
    _nameTf.leftViewMode = UITextFieldViewModeAlways;
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
//    lineView.backgroundColor = kHEXCOLOR(0xE1E1E1);
    _cancelBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _confimBtn =[BTButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.titleLabel.font = MainTextFont;
    _confimBtn.titleLabel.font = MainTextFont;
    
    [_cancelBtn setTitleColor:kHEXCOLOR(0x777777) forState:UIControlStateNormal];
    [_confimBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
    [_confimBtn setTitleColor:SecondTextColor forState:UIControlStateDisabled];
    _confimBtn.enabled = NO;
    
    WS(weakSelf)
    [_cancelBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_confimBtn bk_addEventHandler:^(id  _Nonnull sender) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self.nameTf.text stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return;
        }
        
        [weakSelf __hide];
        if(weakSelf.block){
            weakSelf.block(weakSelf.nameTf.text);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_titleLabel];
    [self addSubview:_nameTf];
//    [self addSubview:lineView];
    [self addSubview:_cancelBtn];
    [self addSubview:_confimBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15.0f);
    }];
    
    [_nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_titleLabel.mas_bottom).offset(28);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(48.0f);
    }];
    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.right.equalTo(self).offset(-15);
//        make.height.mas_equalTo(0.5);
//        make.top.equalTo(_nameTf.mas_bottom).offset(4);
//
//    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(150);
    }];
    [_confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(150);
    }];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectZero];
    hLine.backgroundColor = kHEXCOLOR(0xdddddd);
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectZero];
    vLine.backgroundColor = kHEXCOLOR(0xdddddd);
    
    [self addSubview:hLine];
    [self addSubview:vLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-44);
    }];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(hLine.mas_bottom);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(0.5);
    }];
}

-(void)textFiledEditCha:(NSNotification *)obj {
    //限制输入字数
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (toBeString.length > MAX_STARWORDS_LENGTH){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    [self checkAll];
}

-(void)checkAll {
    
    if (ISNSStringValid(self.nameTf.text)) {
        self.confimBtn.enabled =YES;
        
    } else {
        self.confimBtn.enabled = NO;;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
