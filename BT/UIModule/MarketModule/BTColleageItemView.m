//
//  BTColleageItemView.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageItemView.h"

@interface BTColleageItemView()

@property (nonatomic, assign) CGFloat maxWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@end

@implementation BTColleageItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setViewRadius:self];
    self.bgImageV.layer.cornerRadius = 8.0f;
    self.bgImageV.layer.masksToBounds = YES;
    self.bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageV.clipsToBounds = YES;
    
}
- (void)setTypes:(NSDictionary*)types{
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    self.maxWidth = 12;
    self.titleL.text = SAFESTRING(types[@"name"]);
    self.subTitleL.text = SAFESTRING(types[@"intro"]);
    
    if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
        _titleL.font = FONT(PF_MEDIUM, 14);
        _subTitleL.font = FONTOFSIZE(10.0);
    }else{
        _titleL.font = FONT(PF_MEDIUM, 10);
        _subTitleL.font = FONTOFSIZE(8.0);
    }
    if(self.index == 0){
        self.bgImageV.image = [UIImage imageNamed:@"colleage_blue"];
    }else if(self.index == 1){
        self.bgImageV.image = [UIImage imageNamed:@"colleage_black"];
    }else{
        self.bgImageV.image = [UIImage imageNamed:@"colleage_yellow"];
    }
    NSArray *child = types[@"child"];
    for(NSInteger i = 0 ; i< child.count ; i++){
        NSDictionary *dict = child[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = CWhiteColor;
        btn.layer.cornerRadius = 13;
        btn.layer.masksToBounds = YES;
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            btn.titleLabel.font = FONTOFSIZE(12.0);
        }else{
            btn.titleLabel.font = FONTOFSIZE(8.0);
        }
        if(self.index == 0){
           [btn setTitleColor:MainBg_Color forState:UIControlStateNormal];
        }else if(self.index == 1){
           [btn setTitleColor:kHEXCOLOR(0x565970) forState:UIControlStateNormal];
        }else{
           [btn setTitleColor:kHEXCOLOR(0xfaa361) forState:UIControlStateNormal];
        }
        [btn setTitle:SAFESTRING(dict[@"name"]) forState:UIControlStateNormal];
        
        CGFloat w = 78;
        CGFloat h = 26;
        CGFloat margin = 10;
        btn.frame = CGRectMake(self.maxWidth, 57, w, h);
        [btn bk_addEventHandler:^(id  _Nonnull sender) {
            NSDictionary *info  = [self getPointsDict];
            NSString *key = SAFESTRING(dict[@"value"]);
            [MobClick event:info[key]];
            [BTCMInstance pushViewControllerWithName:@"BTColleageDetailVC" andParams:dict];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        self.maxWidth += w + margin;
    }
}

- (void)setViewRadius:(UIView*)view{
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = kHEXCOLOR(0x000000).CGColor;
    if(isNightMode){
        view.layer.shadowOpacity = 0.31f;
    }else{
        view.layer.shadowOpacity = 0.05f;
    }
    view.layer.shadowRadius = 6.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

- (NSDictionary*)getPointsDict{
    return @{
             @"11":@"school_blockchain",
             @"12":@"school_buy_Cy.",
             @"13":@"school_main_Cy.",
             @"21":@"school_candles",
             @"22":@"school_zhibiao",
             @"23":@"school_state",
             @"31":@"school_attitude",
             @"32":@"school_skills",
             @"33":@"school_experience"
             };
}


@end
