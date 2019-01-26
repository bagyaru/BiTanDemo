//
//  BTRedRiseAlertView.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTRedRiseAlertView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "FileUtil.h"
@interface BTRedRiseAlertView()

@property (nonatomic, strong) BTLabel *titleLabel;
@property(nonatomic,strong) BTButton *confimBtn;//确定
@property (nonatomic, copy) BTRedRiseAlertViewCompletion completion;
@property (nonatomic, strong) FLAnimatedImageView *animationView;

@end

@implementation BTRedRiseAlertView

+ (void)showWithTitle:(NSString *)title completion:(BTRedRiseAlertViewCompletion)block{
    BTRedRiseAlertView *alert = [[BTRedRiseAlertView alloc]initWithFrame:[self frameOfAlert]];
    alert.confimBtn.localTitle = @"wozhidaol";
    alert.titleLabel.text = title;
    alert.completion = block;
    [alert show];
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 305.0f, 287.0f);
}

- (void)createView{
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
//    self.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
    
    _titleLabel = [[BTLabel alloc]initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = FirstDayColor;
    
    _animationView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_animationView];
    
    BOOL isRed  = [[NSUserDefaults standardUserDefaults] boolForKey:RedRiseGreenFall];
    
    NSData *data;
    if(!isRed){
        if(isNightMode){
            data = [NSData dataWithContentsOfFile:[FileUtil findBundleFilePath:@"redRise_Night" ofType:@"gif"]];
        }else{
            data = [NSData dataWithContentsOfFile:[FileUtil findBundleFilePath:@"redRise" ofType:@"gif"]];
        }
    }else{
        if(isNightMode){
            data = [NSData dataWithContentsOfFile:[FileUtil findBundleFilePath:@"greenRise_Night" ofType:@"gif"]];
        }else{
            data = [NSData dataWithContentsOfFile:[FileUtil findBundleFilePath:@"greenRise" ofType:@"gif"]];
        }
    }
    
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    _animationView.animatedImage = image;
    _animationView.contentMode = UIViewContentModeScaleAspectFill;
    _animationView.clipsToBounds = YES;
    
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(50);
        make.bottom.equalTo(self).offset(-53);
    }];
    
    
    _confimBtn =[BTButton buttonWithType:UIButtonTypeCustom];
    _confimBtn.titleLabel.font = FONTOFSIZE(16.0f);
//    _confimBtn.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
    [_confimBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
    
    WS(weakSelf)
    [_confimBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        if(weakSelf.completion){
            weakSelf.completion();
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_titleLabel];
    [self addSubview:_confimBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15.0f);
    }];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectZero];
    hLine.backgroundColor = SeparateLineDayColor;
    [self addSubview:hLine];
   
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-44);
    }];
    
    [_confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
        
    }];
}

@end
