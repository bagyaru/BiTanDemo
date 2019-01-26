//
//  BTICOHeaderView.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOHeaderView.h"
#import "GradualChange.h"

@interface BTICOHeaderView()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *jinduL;
@property (weak, nonatomic) IBOutlet UIView *jinduView;
@property (weak, nonatomic) IBOutlet UIImageView *jinduImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jinduImageVWidthCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jinduLTopCons;


@property (weak, nonatomic) IBOutlet UILabel *tipsL;
@property (weak, nonatomic) IBOutlet BTLabel *relatedLinkView;

@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation BTICOHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setViewRadius:self.icoTimeView];
    [self setViewRadius:self.icoProcessView];
    [self setViewRadius:self.icoTipView];
    [self setViewRadius:self.icoLinkView];
    
    [self setViewRadius:self.firstView];
    [self setViewRadius:self.secondView];
    [self setViewRadius:self.thirdView];
    CGFloat width = (ScreenWidth - 30 - 2*12)/3;
    self.firstCons.constant = width;
    self.secondCons.constant = width;
    self.thirdCons.constant = width;
    
    CGRect frame = CGRectMake(0, 0, ScreenWidth, VIEW_H(self.footbgView));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.footbgView.layer.mask = maskLayer;
    
    self.imageV.layer.cornerRadius = 30.0f;
    self.imageV.layer.masksToBounds = YES;
    
    self.jinduView.layer.cornerRadius = 5.0f;
    self.jinduView.layer.masksToBounds = YES;
    
    WS(ws)
    //影音介绍
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if(SAFESTRING(ws.detailModel.audioIntro).length >0){
            H5Node *node = [[H5Node alloc] init];
            node.webUrl = ws.detailModel.audioIntro;
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        }else{
             [MBProgressHUD showMessage: [APPLanguageService sjhSearchContentWith:@"zanwuyingyinjieshao"] wait:NO];
        }
    }];
    
   
    [self.firstView addGestureRecognizer:tap];
    
    // 官网
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if(SAFESTRING(ws.detailModel.websiteAddress).length >0){
            H5Node *node = [[H5Node alloc] init];
            node.webUrl = ws.detailModel.websiteAddress;
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        }else{
            [MBProgressHUD showMessage: [APPLanguageService sjhSearchContentWith:@"zanwuguangwang"] wait:NO];
        }
    }];
    [self.secondView addGestureRecognizer:tap1];
    
    //白皮书
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if(SAFESTRING(ws.detailModel.whiteBookAddress).length >0){
            H5Node *node = [[H5Node alloc] init];
            node.webUrl = ws.detailModel.whiteBookAddress;
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        }else{
             [MBProgressHUD showMessage: [APPLanguageService sjhSearchContentWith:@"zanwubaipishu"] wait:NO];
        }
    }];
   
    [self.thirdView addGestureRecognizer:tap2];
}

//
- (void)setViewRadius:(UIView*)view{
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    view.layer.shadowOpacity = 0.05f;
    view.layer.shadowRadius = 6.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setDetailModel:(BTICODetailModel *)detailModel{
    _detailModel = detailModel;
    if(detailModel){
        [_imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.icoIcon]  placeholderImage:[UIImage imageNamed:@"default_exchange"]];
        _titleL.text = detailModel.icoCode;
        _timeL.text = detailModel.collectEndTime;
        
//        if(self.detailModel.websiteAddress.length ==0){
//            self.secondView.hidden = YES;
//            self.thirdView.hidden = YES;
//        }
        if(detailModel.collectProgress.length == 0 ||[SAFESTRING(detailModel.collectProgress) containsString:@"nan"]){
            detailModel.collectProgress = @"--";
            _jinduL.text = detailModel.collectProgress;
            self.jinduView.hidden = YES;
            self.jinduLTopCons.constant = 22.0f;
        }else{
            
            if([detailModel.collectProgress containsString:@"/"]){
                NSMutableAttributedString *mutaAttrStr = [[NSMutableAttributedString alloc] initWithString:detailModel.collectProgress];
                NSString *leftStr = [detailModel.collectProgress componentsSeparatedByString:@"/"].firstObject;
                [mutaAttrStr addAttributes:@{NSForegroundColorAttributeName:kHEXCOLOR(0x108ee9)} range:[detailModel.collectProgress rangeOfString:leftStr]];
                _jinduL.attributedText = mutaAttrStr;
            }else{
                _jinduL.text = detailModel.collectProgress;
            }
            if(SAFESTRING(detailModel.progressRate).length >0){
                self.jinduImageVWidthCons.constant = self.jinduView.width * [detailModel.progressRate doubleValue] /100;
                [self.jinduImageView setNeedsLayout];
                [self.jinduImageView layoutIfNeeded];
                self.jinduImageView.image = [GradualChange viewChangeImg:self.jinduImageView.bounds isVerticalBar:NO];
            }else{
                self.jinduView.hidden = YES;
                self.jinduLTopCons.constant = 22.0f;
                
            }
        }
        
        //重要提示 英文
        if(detailModel.importantNewsEn.length == 0){
            detailModel.importantNewsEn = @"--";
        }
        _tipsL.text = detailModel.importantNewsEn;
        
        if(detailModel.icoIntroEn.length == 0){
            detailModel.icoIntroEn = @"--";
        }
        
        _contentL.text =  detailModel.icoIntroEn;
        
        CGFloat width = ScreenWidth - 100;
        CGSize size = [detailModel.icoIntroEn boundingRectWithSize:CGSizeMake(MAXFLOAT, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width < width) {
            _contentL.textAlignment = NSTextAlignmentCenter;
        }else{
            _contentL.textAlignment = NSTextAlignmentLeft;
        }
        if([detailModel.relatedLinksInfo isKindOfClass:[NSArray class]]){
            
            for(UIView *view in self.icoLinkView.subviews){
                if([view isKindOfClass:[UIButton class]]){
                    [view removeFromSuperview];
                }
            }
            self.maxWidth =  18.0f;
            for(NSDictionary *dict in detailModel.relatedLinksInfo){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat width = 16.0f;
                NSString *key = SAFESTRING(dict[@"key"]);
                NSString *value = SAFESTRING(dict[@"value"]);
                [self.icoLinkView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.icoLinkView.mas_centerY);
                    make.left.equalTo(self.relatedLinkView.mas_right).offset(self.maxWidth);
                    make.width.height.mas_equalTo(16.0f);
                }];
                self.maxWidth += width+15;
                [btn setImageWithURL:[NSURL URLWithString:key] forState:UIControlStateNormal placeholder:nil];
                [btn bk_addEventHandler:^(id  _Nonnull sender) {
                    if(SAFESTRING(value).length >0){
                        H5Node *node = [[H5Node alloc] init];
                        node.webUrl = value;
                        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                    }
                    
                } forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }
        
    }
}

@end
