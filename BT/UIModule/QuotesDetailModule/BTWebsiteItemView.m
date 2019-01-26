//
//  BTWebsiteItemView.m
//  BT
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTWebsiteItemView.h"

@interface BTWebsiteItemView()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation BTWebsiteItemView

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
    _titleL = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:12.0f] textColor:ThirdColor];
    [self addSubview:_imageV];
    [self addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV);
        make.top.equalTo(_imageV.mas_bottom).offset(6);
    }];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.width.height.mas_equalTo(34.0f);
    }];
    
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(tap:)];
    [self addGestureRecognizer:gesture];
}

- (void)tap:(UIGestureRecognizer*)gesture{
    if(self.completion){
        self.completion();
    }
}

- (void)setData:(NSDictionary *)data{
    _data =data;
    NSString *url = SAFESTRING(data[@"iconUrl"]);
    [_imageV sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:[UIImage imageNamed:@"default_exchange"]];
    NSString *title = @"";
    if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
        title =SAFESTRING(data[@"chineseTitle"]);
    }else{
        title =SAFESTRING(data[@"englishTitle"]);
    }
    self.titleL.text = title;
    
}


@end
