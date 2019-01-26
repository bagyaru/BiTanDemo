//
//  QuotesSegment.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuotesSegment.h"


#define MoreTag 16
@interface QuotesSegment ()

@property (weak, nonatomic) IBOutlet UIButton *btnFillScreen;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIndicator;


@property (weak, nonatomic) IBOutlet UIImageView *moreImageviewIndic;

@property (nonatomic, assign) BOOL isOther;

@property (weak, nonatomic) IBOutlet BTButton *btnFenshi;

@property (weak, nonatomic) IBOutlet BTButton *indexBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftFirst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftSecond;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftThird;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnTrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreRightConst;



@end

@implementation QuotesSegment{
    UIButton *firstBtn;
    UIButton *priBtn;
    UIView *ivLine;
}

- (void)awakeFromNib{
   
    [AppHelper addBottomLineWithParentView:self];
    [super awakeFromNib];
    self.moreImageviewIndic.image = [UIImage imageNamed:@"ic_jiantouweixuan"];
    [self.btnFillScreen setImage:[UIImage imageNamed:@"ic_quanping"] forState:UIControlStateNormal];
    NSArray *arr =@[@{@"name":@"fenshi",@"tag":@"0"},@{@"name":@"15fen",@"tag":@"3"},@{@"name":@"1h",@"tag":@"5"},@{@"name":@"4h",@"tag":@"7",@"point":@"More_4h"},@{@"name":@"rixian",@"tag":@"10"},@{@"name":@"more",@"tag":@"16"}];
    
    for (NSInteger i = 9; i < 15; i++) {
        UIButton *btn = [self viewWithTag:200 + i];
        if (i == 9) {
            btn.selected = YES;
            priBtn = btn;
            firstBtn = btn;
        }
        
        BTButton *btBtn = (BTButton*)btn;
        btBtn.fixTitle = arr[i-9][@"name"];
        NSString *tag = arr[i-9][@"tag"];
        btBtn.tag = [tag integerValue];
        
        [btn setTitleColor:ThirdColor forState:UIControlStateNormal];
        [btn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(showKView:) forControlEvents:UIControlEventTouchUpInside];
    }
//    ivLine = [[UIView alloc] init];
//    ivLine.backgroundColor = CBlackColor;
//    [self addSubview:ivLine];
//    [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-2);
//        make.centerX.equalTo(firstBtn);
//        make.height.mas_equalTo(2);
//        make.width.mas_equalTo(40);
//    }];
    
    if (!kIszh_hans) {
        self.constraintLeftFirst.constant = 0;
        self.constraintLeftSecond.constant = 0;
        self.constraintLeftThird.constant = 0;
        self.constraintBtnTrailing.constant = 15;
    }else{
        self.constraintLeftFirst.constant = 10;
        self.constraintLeftSecond.constant = 0;
        self.constraintLeftThird.constant = 0;
        self.constraintBtnTrailing.constant = 15;
    }
    
   
}

- (void)setFenshiTitle:(NSString *)fenshiTitle{
    _fenshiTitle = fenshiTitle;
    [self.btnFenshi setTitle:fenshiTitle forState:UIControlStateNormal];
}

- (void)setIndexTitle:(NSString *)indexTitle{
    _indexTitle = indexTitle;
    [self.indexBtn setTitle:indexTitle forState:UIControlStateNormal];
    
}

- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    if(self.btnFenshi.isSelected){
        self.imageViewIndicator.image = [UIImage imageNamed:@"ic_jiantouyixuan"];
    }else{
        self.imageViewIndicator.image = [UIImage imageNamed:@"ic_jiantouweixuan"];
    }
    
    if(self.indexBtn.isSelected){
        self.moreImageviewIndic.image = [UIImage imageNamed:@"ic_jiantouyixuan"];
    }else{
        self.moreImageviewIndic.image = [UIImage imageNamed:@"ic_jiantouweixuan"];
    }
}

-  (void)setIsShowFullScreen:(BOOL)isShowFullScreen{
    _isShowFullScreen = isShowFullScreen;
    self.btnFillScreen.hidden = !_isShowFullScreen;
    if(!isShowFullScreen){
        self.moreRightConst.constant = 15.0f;
    }else{
        self.moreRightConst.constant = 50.0f;
    }
}

//
- (void)showKView:(UIButton *)btn{
    //解决更多选择和其他按钮选择同时存在的情况
    if(btn.tag != 16){
        priBtn.selected = NO;
        priBtn = btn;
        self.indexBtn.selected = NO;
    }
    
    btn.selected = YES;
    self.type = btn.tag ;//修正后的tag
    
    //选择分时按钮后
    if (self.type == 0) {
        if(self.isOther){
            self.isShow = NO;
        }else{
            self.isShow = !self.isShow;
        }
        self.isOther = NO;
        if(btn.isSelected){
            self.imageViewIndicator.image = [UIImage imageNamed:@"ic_jiantouyixuan"];
        }
        else{
            self.imageViewIndicator.image = [UIImage imageNamed:@"ic_jiantouweixuan"];
        }
    }
    //选择更多按钮后
    if (self.type == 16) {
        self.isShow = !self.isShow;
        if(btn.isSelected){
            self.moreImageviewIndic.image = [UIImage imageNamed:@"ic_jiantouyixuan"];
        }
        else{
            self.moreImageviewIndic.image = [UIImage imageNamed:@"ic_jiantouweixuan"];
        }
    }
    
    if (self.segmentBlock) {
        if (self.type == 0) {//分时
            //点击更多直接弹出选择框
//            if([_fenshiTitle isEqualToString:[APPLanguageService sjhSearchContentWith:@"fenshi"]]){
//                self.isShow = YES;
//            }
            //更多打点
            [MobClick event:@"detail_table_time"];
            self.segmentBlock(self.type,self, self.isShow,self.isHideAlpha);
        }else  if (self.type == 16) {//分时{
            //点击更多直接弹出选择框
            if([_indexTitle isEqualToString:[APPLanguageService sjhSearchContentWith:@"more"]]){
                self.isShow = YES;
            }
            self.segmentBlock(self.type,self, self.isShow,self.isHideAlpha);
            
        }else{
            self.isShow = NO;
            self.isOther = YES;
            //分时 日周月 打点
            switch (self.type) {
                case 0:
                    [AnalysisService alaysisDetail_table_time];
                    break;
                case 3:
                    [MobClick event:@"15min"];
                    break;
                case 5:
                    [MobClick event:@"1h"];
                    break;
                case 10:
                    [AnalysisService alaysisDetail_table_day];
                    break;
                default:
                    break;
            }
            self.segmentBlock(self.type,self, NO,self.isHideAlpha);
        }
        
    }
    //    [UIView animateWithDuration:0.25 animations:^{
    //        [ivLine mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.bottom.equalTo(self).offset(-2);
    //            make.centerX.equalTo(btn.mas_centerX).offset(-2);
    //            make.height.mas_equalTo(2);
    //            make.width.mas_equalTo(40);
    //        }];
    //        [self layoutIfNeeded];
    //    }];
    
}

- (void)showInViewWith:(UIView *)parentView{
    if (parentView) {
        [parentView addSubview:self];
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView).insets(insets);
        }];
    }
}

- (IBAction)fillScreen:(id)sender {
    [AnalysisService alaysisDetail_table_fullScreen];
    if (self.fullScreenBlock) {
        self.fullScreenBlock();
    }
}

@end
