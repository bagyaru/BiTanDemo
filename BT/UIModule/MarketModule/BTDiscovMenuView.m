//
//  BTDiscovMenuView.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDiscovMenuView.h"

@interface BTDiscovMenuView()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation BTDiscovMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //to do
    _imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageV.userInteractionEnabled = YES;
    _titleL = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:12.0f] textColor:FirstColor];
    [self addSubview:_imageV];
    [self addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_titleL.mas_top);
        make.width.height.mas_equalTo(50.0f);
    }];
    
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(tap:)];
    [self addGestureRecognizer:gesture];
}

- (void)tap:(UIGestureRecognizer*)gesture{
    if([self.delegate respondsToSelector:@selector(clickWithData:)]){
        [self.delegate clickWithData:self.data];
    }
    
}
- (void)setData:(NSDictionary *)data{
    _data =data;
    self.imageV.image = [UIImage imageNamed:data[@"image"]];
    self.titleL.text = [APPLanguageService wyhSearchContentWith:data[@"title"]];
    
}
@end


@interface BTDiscovMenuContainerView()<BTDiscovMenuViewDelegate>

@end
@implementation BTDiscovMenuContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setMenus:(NSArray *)menus{
    if(menus.count ==0){
        return;
    }
    CGFloat width = ScreenWidth;
    CGFloat memuWidth = width/menus.count;
    for(NSUInteger i =0;i<menus.count;i++){
        NSDictionary *dict = menus[i];
        
        BTDiscovMenuView *menuView =[[BTDiscovMenuView alloc]initWithFrame:CGRectZero];
        menuView.delegate = self;
        menuView.data =dict;
        [self addSubview:menuView];
        menuView.frame =CGRectMake(i*memuWidth, 0, memuWidth,97.0f);
    }
    
}

- (void)clickWithData:(NSDictionary *)data{
    if([self.deleagte respondsToSelector:@selector(menuView:didClickIndex:)]){
        [self.deleagte menuView:self didClickIndex:[data[@"index"] integerValue]];
    }
}
@end
