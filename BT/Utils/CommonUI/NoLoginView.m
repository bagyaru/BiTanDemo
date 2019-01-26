//
//  NoLoginView.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoLoginView.h"

@interface NoLoginView ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet BTButton *btnLogin;

@property (weak, nonatomic) IBOutlet BTLabel *lableInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginW;


@end

@implementation NoLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = kHEXCOLOR(0xf5f5f5);
    self.viewContent.backgroundColor = kHEXCOLOR(0xf5f5f5);
    self.lableInfo.textColor = TextColor;
    [self.btnLogin setTitleColor:MainBg_Color forState:UIControlStateNormal];
    ViewBorderRadius(self.btnLogin, 2.0f, 1, MainBg_Color);
   
}
- (void)setType:(LoginOrOptionType)type{
    _type = type;
    if (_type == LoginOrOptionTypeNoLogin) {
        self.btnLogin.fixTitle = @"lijidenglu";
        self.lableInfo.fixText = @"nolgin";
        self.imageViewIcon.image = [UIImage imageNamed:@"ic_wudenglu"];
    }else if (self.type == UserCenterNoMessage) {
        
        self.lableInfo.localText = @"noData";
        self.imageViewIcon.image = [UIImage imageNamed:@"无消息"];
    }else if (self.type == FocusListVC) {
        self.btnLogin.fixTitle = @"lijidenglu";
        self.lableInfo.localText = @"dengluhoucainenghuoqudongtai";
        self.imageViewIcon.image = [UIImage imageNamed:@"空白-未登录"];
        
        self.imageH.constant = 130;
        self.imageW.constant = 130;
        self.topH.constant   = 20;
        self.loginTop.constant= 30;
        self.centerH.constant= - 100;
        self.loginW.constant = 140;
        self.viewH.constant  = 300;
        self.lableInfo.textColor = SecondTextColor;
        [self.btnLogin setTitleColor:MainBg_Color forState:UIControlStateNormal];
        ViewBorderRadius(self.btnLogin, 1.0f, 1, kHEXCOLOR(0x83BFEA));
    }else{
        self.btnLogin.fixTitle = @"lijitianjia";
        self.lableInfo.fixText = @"nooption";
        self.imageViewIcon.image = [UIImage imageNamed:@"nouserbtc.png"];
    }
}

- (IBAction)clickedBtnLogin:(id)sender {
    if (self.type == LoginOrOptionTypeNoLogin || self.type == FocusListVC) {
        //去登录
        if (self.loginBlock) {
            self.loginBlock();
        }
    }else{
        //去添加自选
        if (self.noOptionBlock) {
            self.noOptionBlock();
        }
    }
}

- (void)showInWithParentView:(UIView *)parentView{
    if (parentView) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        [parentView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView).insets(insets);
        }];
    }
}

@end
