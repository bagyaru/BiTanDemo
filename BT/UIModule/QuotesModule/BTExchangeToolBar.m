//
//  BTExchangeToolBar.m
//  BT
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeToolBar.h"

@interface BTExchangeToolBar()<BTExchangeToolMenuViewDelegate>
@end

@implementation BTExchangeToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
        self.layer.shadowOpacity = 0.05f;
        self.layer.shadowRadius = 6.0f;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

- (void)setMenus:(NSArray *)menus{
    _menus = menus;
    if(menus.count ==0){
        return;
    }
    CGFloat width = ScreenWidth;
    CGFloat memuWidth = width/menus.count;
    for(NSUInteger i =0;i<menus.count;i++){
        NSDictionary *dict = menus[i];
        BTExchangeToolMenuView *menuView =[[BTExchangeToolMenuView alloc]initWithFrame:CGRectZero];
        menuView.delegate = self;
        menuView.data = dict;
        if(i ==0){
            menuView.isSelected = YES;
        }
        menuView.tag = 500 +i;
        [self addSubview:menuView];
        menuView.frame =CGRectMake(i*memuWidth, 0, memuWidth,49.0f);
    }
}
//
- (void)clickView:(BTExchangeToolMenuView *)menu withData:(NSDictionary *)data{
    if([self.delegate respondsToSelector:@selector(menuView:didClickIndex:)]){
        [self.delegate menuView:self didClickIndex:[data[@"index"] integerValue]];
    }
    for(BTExchangeToolMenuView *menuView in self.subviews){
        if(menuView.tag == menu.tag){
            menuView.isSelected = YES;
        }else{
            menuView.isSelected = NO;
        }
    }
}

- (void)itemSelectIndex:(NSInteger)index{
    NSInteger tag = index + 500;
    for(BTExchangeToolMenuView *menuView in self.subviews){
        if(menuView.tag == tag){
            menuView.isSelected = YES;
        }else{
            menuView.isSelected = NO;
        }
    }
}
@end

@interface BTExchangeToolMenuView()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleL;

@end
@implementation BTExchangeToolMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageV.userInteractionEnabled = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    _titleL = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:10.0f] textColor:ThirdColor];
    [self addSubview:_imageV];
    [self addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_titleL.mas_top);
        make.width.height.mas_equalTo(30.0f);
    }];
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(tap:)];
    [self addGestureRecognizer:gesture];
}

- (void)tap:(UIGestureRecognizer*)gesture{
    BTExchangeToolMenuView *view = (BTExchangeToolMenuView*)gesture.view;
    if([self.delegate respondsToSelector:@selector(clickView:withData:)]){
        [self.delegate clickView:view withData:self.data];
    }
}

- (void)setData:(NSDictionary *)data{
    _data =data;
    self.imageV.image = [UIImage imageNamed:data[@"image"]];
    self.titleL.text = [APPLanguageService sjhSearchContentWith:data[@"title"]];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(isSelected){
        self.imageV.image = [UIImage imageNamed:self.data[@"selectImage"]];
        self.titleL.text = [APPLanguageService sjhSearchContentWith:self.data[@"title"]];
        self.titleL.textColor = MainBg_Color;
    }else{
        self.imageV.image = [UIImage imageNamed:self.data[@"image"]];
        self.titleL.text = [APPLanguageService sjhSearchContentWith:self.data[@"title"]];
        self.titleL.textColor = ThirdColor;
    }
}

@end
