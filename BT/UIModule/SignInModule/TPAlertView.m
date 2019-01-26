//
//  TPAlertView.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TPAlertView.h"

@interface TPAlertView ()

@property (nonatomic,strong) UILabel *mainLabel;

@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UILabel *additionalLabel;

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,copy) BtnClickBlock btnBlock;

@end

@implementation TPAlertView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

static TPAlertView *tp = nil;
+(void)showTPAlertView:(AlertType)type day:(NSInteger)day award:(NSInteger)award btnClick:(BtnClickBlock)btnBlock{
    if (!tp) {
        tp = [[TPAlertView alloc] init];
        [kAppWindow addSubview:tp];
        [tp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(kAppWindow);
        }];
        [tp initUI:type day:day award:award];
        tp.btnBlock = btnBlock;
        tp.alertType = type;
    }
    
//    [tp initUI];
    
}

-(void)initUI:(AlertType)type day:(NSInteger)day award:(NSInteger)award{
    
    UIView *bgView = [[UIView alloc] init];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:g];
    [self addSubview:bgView];
    bgView.backgroundColor = kHEXCOLOR(0x000000);
    bgView.alpha = 0.5;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *mainView = [[UIView alloc] init];
    [self addSubview:mainView];
    
    CGFloat height = 0;
    CGFloat imgW = 0;
    CGFloat imgH = 0;
    NSString *imgStr;
    NSString *mainStr;
    BOOL isHiddenSub;
    BOOL isAdditional;
    NSString *subStr;
    NSString *additionalStr;
    NSString *btnStr = [APPLanguageService wyhSearchContentWith:@"wancheng"];
    switch (type) {
        case AlertTypeNOTSign:
            height = RELATIVE_WIDTH(243) ;
            imgW = RELATIVE_WIDTH(78);
            imgH = RELATIVE_WIDTH(95);
            imgStr = @"ic_tankuang-weiqiandao";
            mainStr = [APPLanguageService wyhSearchContentWith:@"dalaoweiqiandao"];
            btnStr = [APPLanguageService wyhSearchContentWith:@"quqiandao"];
            isHiddenSub  = YES;
            isAdditional = YES;
            break;
        case AlertTypeSignSucc:
            height = RELATIVE_WIDTH(252);
            imgW = RELATIVE_WIDTH(32);
            imgH = RELATIVE_WIDTH(32);
            imgStr = @"ic_tanli-yilingqu";
            mainStr = [APPLanguageService wyhSearchContentWith:@"qiandaosucc"];
            isHiddenSub = NO;
            isAdditional = YES;
            subStr = [NSString stringWithFormat:@"%@+%ldTP",[APPLanguageService wyhSearchContentWith:@"qiandao"],day];
            break;
        case AlertTypeSignAward:
            height = RELATIVE_WIDTH(277);
            imgW = RELATIVE_WIDTH(32);
            imgH = RELATIVE_WIDTH(32);
            imgStr = @"ic_bigtanli-yilingqu";
            mainStr = [APPLanguageService wyhSearchContentWith:@"qiandaosucc"];
            isHiddenSub = NO;
            isAdditional = NO;
            subStr = [NSString stringWithFormat:@"%@%+ldTP",[APPLanguageService wyhSearchContentWith:@"qiandao"],day];
            additionalStr = [NSString stringWithFormat:@"%@%+ldTP",[APPLanguageService wyhSearchContentWith:@"qiandaojianli"],award];
            break;
            
        default:
            break;
    }
    
    mainView.backgroundColor = [UIColor whiteColor];
    ViewRadius(mainView, RELATIVE_WIDTH(4));
    
    self.mainLabel = [UILabel new];
    [mainView addSubview:self.mainLabel];
    self.mainLabel.textColor = kHEXCOLOR(0x333333);
    self.mainLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.mainLabel.numberOfLines = 0;
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView).offset(RELATIVE_WIDTH(15));
        make.left.equalTo(mainView).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(mainView).offset(RELATIVE_WIDTH(-15));
        //make.height.mas_equalTo(RELATIVE_WIDTH(28));
    }];
    self.mainLabel.text = mainStr;
    
    self.imgView = [UIImageView new];
    [mainView addSubview:self.imgView];
    self.imgView.image = [UIImage imageNamed:imgStr];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(mainView);
        make.top.equalTo(self.mainLabel.mas_bottom).offset(RELATIVE_WIDTH(21));
        make.width.mas_equalTo(imgW);
        make.height.mas_equalTo(imgH);
    }];
    
    self.subLabel = [UILabel new];
    [mainView addSubview:self.subLabel];
    self.subLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    self.subLabel.textColor = self.mainLabel.textColor;
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainView);
        make.top.equalTo(self.imgView.mas_bottom).offset(RELATIVE_WIDTH(20));
        make.height.mas_equalTo(isHiddenSub?0:RELATIVE_WIDTH(22)); 
    }];
    self.subLabel.hidden = isHiddenSub;
    self.subLabel.text = subStr;
    
    self.additionalLabel = [UILabel new];
    [mainView addSubview:self.additionalLabel];
    self.additionalLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    self.additionalLabel.textColor = MainBg_Color;
    self.additionalLabel.textAlignment = NSTextAlignmentCenter;
    [self.additionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainView);
        make.top.equalTo(self.subLabel.mas_bottom).offset(isAdditional?0:RELATIVE_WIDTH(15));
        make.height.mas_equalTo(isAdditional?0:RELATIVE_WIDTH(20));
    }];
    self.additionalLabel.hidden = isAdditional;
    self.additionalLabel.text = additionalStr;
    
    UIButton *btn = [UIButton new];
    [mainView addSubview:btn];
    ViewRadius(btn, RELATIVE_WIDTH(2));
    btn.backgroundColor = MainBg_Color;
    [btn setTitle:btnStr forState:UIControlStateNormal];
    [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(mainView).offset(RELATIVE_WIDTH(-15));
        make.top.equalTo(self.additionalLabel.mas_bottom).offset(RELATIVE_WIDTH(20));
        make.height.mas_equalTo(40);
    }];
    
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(RELATIVE_WIDTH(250));
//        make.height.mas_equalTo(height);
        make.bottom.equalTo(btn).offset(RELATIVE_WIDTH(15));
    }];
    
}

-(void)btnClick{
    DLog(@"按钮点击");
    
    if (self.btnBlock) {
        self.btnBlock();
    }
    
    [tp removeFromSuperview];
    tp = nil;
    
}
-(void)dismiss {
    DLog(@"移除");
    if (self.alertType != AlertTypeNOTSign) {
        if (self.btnBlock) {
            self.btnBlock();
        }
    }
    [tp removeFromSuperview];
     tp = nil;
}

@end
