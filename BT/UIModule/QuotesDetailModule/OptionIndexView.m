//
//  OptionIndexView.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OptionIndexView.h"

@interface OptionIndexView ()

@property (nonatomic, strong) UIView *ivAlpha;

@property (nonatomic, strong) UIView *topAlpha;

@property (weak, nonatomic) IBOutlet UIView *viewBG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewBGHeight;


@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;

@end

@implementation OptionIndexView{
    UIButton *pribtn;
    NSArray *_arr;
    UIView *_parentView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.topAlpha = [[UIView alloc] init];
    self.topAlpha.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapTopAlpha = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.topAlpha addGestureRecognizer:tapTopAlpha];
    
    self.ivAlpha = [[UIView alloc] init];
    self.ivAlpha.backgroundColor = kHEXCOLOR(0x000000);
    self.ivAlpha.alpha = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.ivAlpha addGestureRecognizer:tap];
    
   self.viewBG.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
    ViewRadius(self.viewBG, 1.0f);
}

- (void)setDataArr:(NSArray *)dataArr{
    for(UIView *view in self.viewBG.subviews){
        [view removeFromSuperview];
    }
    
    _dataArr = dataArr;
    _arr = dataArr;
    self.width = 0;
    self.height = 0;
    CGFloat height = 44.0f;
    
    BTLabel *mainIndexTitleL = [[BTLabel alloc] initWithFrame:CGRectZero];
    mainIndexTitleL.textColor = SecondColor;
    mainIndexTitleL.font = FONTOFSIZE(12);
    mainIndexTitleL.fixText = @"mainIndex";
    [self.viewBG addSubview:mainIndexTitleL];
    [mainIndexTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBG).offset(15);
        make.top.equalTo(self.viewBG);
        make.height.mas_equalTo(height);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = SeparateColor;
    [self.viewBG addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewBG);
        make.top.equalTo(self.viewBG).offset(44);
        make.height.mas_equalTo(0.5);
    }];
    
    
    for (NSInteger i = 0;i < _arr.count;i++) {
        NSDictionary *dict = _arr[i];
        NSString *str = dict[@"name"];
        BTButton *btn = [BTButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FONTOFSIZE(14.0f);
        NSString *tag = dict[@"tag"];
        btn.tag = [tag integerValue];
        
        //设置选中的指标
        if([tag isEqualToString:self.mainTag]){
            btn.selected = YES;
            if(SAFESTRING(dict[@"point"]).length>0){
                [MobClick event: dict[@"point"]];
            }
        }
        
        if([tag isEqualToString:self.accessoryTag]){
            btn.selected = YES;
            if(SAFESTRING(dict[@"point"]).length>0){
                [MobClick event: dict[@"point"]];
            }
        }
        
        [btn setTitleColor:ThirdColor forState:UIControlStateNormal];
        [btn setTitleColor:MainBg_Color forState:UIControlStateSelected];
        
        
        btn.fixTitle = str;
        [self.viewBG addSubview:btn];
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat stringWidth = [[APPLanguageService sjhSearchContentWith:str] boundingRectWithSize:CGSizeMake(ScreenWidth, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONTOFSIZE(14)} context:nil].size.width;
        
        stringWidth += 20;
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(mainIndexTitleL.mas_right).offset(0);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(height);
                make.width.mas_equalTo(stringWidth);
            }];
        }else{
            if(i ==4){
                BTLabel *mainIndexTitleL = [[BTLabel alloc] initWithFrame:CGRectZero];
                mainIndexTitleL.textColor = SecondColor;
                mainIndexTitleL.font = FONTOFSIZE(12);
                mainIndexTitleL.fixText = @"zhuanyeIndex";
                [self.viewBG addSubview:mainIndexTitleL];
                [mainIndexTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.viewBG).offset(15);
                    make.top.equalTo(self.viewBG).offset(44);
                    make.height.mas_equalTo(height);
                }];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(mainIndexTitleL.mas_right).offset(0);
                    make.top.equalTo(pribtn.mas_bottom).offset(0);
                    make.height.mas_equalTo(height);
                    make.width.mas_equalTo(stringWidth);
                }];
                
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i % 4 == 0 &&i <= 4) {
                        make.left.equalTo(self).offset(0);
                        make.top.equalTo(pribtn.mas_bottom).offset(0);
                        make.height.mas_equalTo(height);
                        make.width.mas_equalTo(stringWidth);
                    }else{
                        make.left.equalTo(pribtn.mas_right);
                        make.top.equalTo(pribtn);
                        make.height.mas_equalTo(height);
                        make.width.mas_equalTo(stringWidth);
                    }
                }];
            }
        }
        pribtn = btn;
    }
    self.width = ScreenWidth;
    NSInteger row = _arr.count / 4 ;
    self.height += row*44.0f;
}




- (NSInteger)fromeWithTitle:(NSString *)title{
    for (NSInteger i = 0; i < _arr.count; i++) {
        NSDictionary *dict = _arr[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        BTButton *btn = [self.viewBG viewWithTag:tag];
        if ([btn isKindOfClass:[BTButton class]]) {
            if ([title isEqualToString:btn.currentTitle]) {
                if (self.optionTypeBlock) {
                    self.optionTypeBlock(btn.tag,btn.currentTitle);
                }
                break;
            }
        }
    }
    return 0;
}
- (void)clickedBtn:(UIButton *)btn{
    if (self.optionTypeBlock) {
        self.optionTypeBlock(btn.tag,btn.currentTitle);
    }
    //打点
    for (NSInteger i = 0; i < _arr.count; i++) {
        NSDictionary *dict = _arr[i];
        NSInteger tag = [dict[@"tag"] integerValue];
        if(tag == btn.tag){
            if(SAFESTRING(dict[@"point"]).length>0){
                [MobClick event: dict[@"point"]];
            }
            break;
        }
    }
    [self hiddenView];
}

- (void)showInParentView:(UIView *)parentView relativeView:(UIView *)relativeView{
    if ([self superview]) {
        if (![self.viewRotation isEqual:parentView] && self.viewRotation) {
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
            [parentView addSubview:self.ivAlpha];
            [parentView addSubview:self];
            [self.ivAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(parentView).insets(insets);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(relativeView.mas_bottom).offset(0);
                make.right.equalTo(parentView).offset(0);
                make.width.mas_equalTo(self.width);
                make.height.mas_equalTo(self.height);
            }];
            _parentView = parentView;
            [self show];
            return;
        }else{
            [self show];
        }
    }
    if (parentView && relativeView) {
        _parentView = parentView;
        [parentView addSubview:self.topAlpha];
        [parentView addSubview:self.ivAlpha];
        [parentView addSubview:self];
        [self.topAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(parentView);
            make.bottom.equalTo(relativeView.mas_bottom);
        }];
        [self.ivAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(relativeView.mas_bottom);
            make.left.right.bottom.equalTo(parentView);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(relativeView.mas_bottom);
            make.right.equalTo(relativeView);
            make.width.mas_equalTo(self.width);
            make.height.mas_equalTo(self.height);
        }];
    }
}

- (void)show{
    self.hidden = NO;
    self.ivAlpha.hidden = NO;
    self.topAlpha.hidden = NO;
}

- (void)hiddenView{
    if (self.hiddenblock) {
        self.hiddenblock();
    }
    self.hidden = YES;
    self.ivAlpha.hidden = YES;
    self.topAlpha.hidden = YES;
}

@end
