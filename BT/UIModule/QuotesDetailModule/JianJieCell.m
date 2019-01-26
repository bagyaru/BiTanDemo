//
//  JianJieCell.m
//  BT
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JianJieCell.h"
@interface JianJieCell ()
@property (weak, nonatomic) IBOutlet UILabel *jianjieL;
@property (weak, nonatomic) IBOutlet UILabel *yingwenNameL;
@property (weak, nonatomic) IBOutlet UILabel *zhongwenNameL;
@property (weak, nonatomic) IBOutlet UILabel *xiangguangainianL;
@property (weak, nonatomic) IBOutlet UILabel *shoumingL;
@property (weak, nonatomic) IBOutlet UILabel *paimingL;
@property (weak, nonatomic) IBOutlet UILabel *shichangL;
@property (weak, nonatomic) IBOutlet UILabel *liutongliangL;
@property (weak, nonatomic) IBOutlet UILabel *zongliangL;
@property (weak, nonatomic) IBOutlet UILabel *mujizijingL;
@property (weak, nonatomic) IBOutlet UILabel *icoChengBenL;
@property (weak, nonatomic) IBOutlet UILabel *icoTimeL;
@property (weak, nonatomic) IBOutlet UILabel *guangwangL;
@property (weak, nonatomic) IBOutlet UILabel *quguangzhangL;
@property (weak, nonatomic) IBOutlet UILabel *baipishuL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H11;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H12;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H13;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H14;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H15;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H0;



@end
@implementation JianJieCell{
    IntroduceModel *_model;
}

+ (instancetype)shareInstance{
    static JianJieCell *cell = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([JianJieCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = CWhiteColor;
    UITapGestureRecognizer *tapwhiteAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.whiteAddressBlock && [_model.whiteBookAddress containsString:@"http"]) {
            self.whiteAddressBlock(_model.whiteBookAddress);
        }
    }];
    self.baipishuL.userInteractionEnabled = YES;
    [self.baipishuL addGestureRecognizer:tapwhiteAddress];
    
    UITapGestureRecognizer *tapwebAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.webSiteAddressBlock && [_model.websiteAddress containsString:@"http"]) {
            self.webSiteAddressBlock(_model.websiteAddress);
        }
    }];
    self.guangwangL.userInteractionEnabled = YES;
    [self.guangwangL addGestureRecognizer:tapwebAddress];
    
    UITapGestureRecognizer *tapqukuaiAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.qukuaiAddressBlock && [_model.websiteAddress containsString:@"http"]) {
            self.qukuaiAddressBlock(_model.websiteAddress);
        }
    }];
    self.quguangzhangL.userInteractionEnabled = YES;
    [self.quguangzhangL addGestureRecognizer:tapqukuaiAddress];
    
    for (NSInteger i = 100; i < 110; i++) {
        UIView *iv = [self viewWithTag:i];
        iv.backgroundColor = CWhiteColor;
//        if (i == 100) {
//            [AppHelper addLineTopWithParentView:iv];
//        }
        [AppHelper addLineWithParentView:iv];
    }
}
+ (CGFloat)cellHeightWith:(IntroduceModel *)model{
    
    JianJieCell *cell = [self shareInstance];
    [cell configWith:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
   CGFloat heigh = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return heigh;
    CGFloat height = 0.0;
    
    if (ISNSStringValid(model.currencySimpleName)) {
        
       height = height+48+15;
    }
    if (ISNSStringValid(model.currencySimpleName)) {
        
        height = height+30;
    }
    if (ISNSStringValid(model.currencyEnglishName)) {
        
        height = height+30;
    }
    if (ISNSStringValid(model.currencyChineseName)) {
        
       height = height+30;
    }
    if (ISNSStringValid(model.relatedNotion)) {
       
        height = height+30;
    }
    if (ISNSStringValid(model.abstractValue)) {
        
        CGFloat height1 = [getUserCenter customGetContactHeight:model.abstractValue FontOfSize:13 LabelMaxWidth:ScreenWidth-30 jianju:0.0];
         height = height+height1+1;
    }
    
    
    if (model.ranking > 0) {
       
        height = height+40;
    }
    
    if (kIsCNY) {
        
        if (model.costRmb > 0) {
            
          height = height+40;
        }
    }else{
        
        if (model.costDollar > 0) {
            
           height = height+40;
        }
    }
    
    if (model.currencyAmount > 0) {
        
       height = height+40;
    }
    
    if (ISNSStringValid(model.collectFundAmount)) {
        
        height = height+40;
    }
    if (ISNSStringValid(model.maxAmount)) {
       
        height = height+40;
    }
    if (ISNSStringValid(model.icoCost)) {
        
       height = height+40;
    }
    if (ISNSStringValid(model.icoTime)) {
        
       height = height+40;
    }
    
    if (ISNSStringValid(model.websiteAddress)) {
        
       height = height+40;
    }
    if (ISNSStringValid(model.explorerAddress)) {
        
      height = height+40;
    }
    
    if (ISNSStringValid(model.whiteBookAddress)) {
        
      height = height+40;
    }
    
    
    return height;
}
- (void)configWith:(IntroduceModel *)model {
    
    if (model) {
        _model = model;
        self.H0.constant = 18;
        self.H1.constant = 30;
        self.H2.constant = 30;
        self.H3.constant = 30;
        self.H4.constant = 30;
        self.H5.constant = 32;
        self.H6.constant = 40;
        self.H7.constant = 40;
        self.H8.constant = 40;
        self.H9.constant = 40;
        self.H10.constant = 40;
        self.H11.constant = 40;
        self.H12.constant = 40;
        self.H13.constant = 40;
        self.H14.constant = 40;
        self.H15.constant = 40;
        if (ISNSStringValid(model.currencySimpleName)) {
            
            self.jianjieL.text = model.currencySimpleName;
        }else {
            
            self.H1.constant = 0;
        }
        if (ISNSStringValid(model.currencyEnglishName)) {
            
            self.yingwenNameL.text = model.currencyEnglishName;
        }else {
            
            self.H2.constant = 0;
        }
        if (ISNSStringValid(model.currencyChineseName)) {
            
            self.zhongwenNameL.text = model.currencyChineseName;
        }else {
            
            self.H3.constant = 0;
        }
        if (ISNSStringValid(model.relatedNotion)) {
            self.xiangguangainianL.text = model.relatedNotion;
        }else {
            
            self.H4.constant = 0;
        }
        if (ISNSStringValid(model.abstractValue)) {
            
            //self.shoumingL.text = model.abstractValue;
            
            NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
            wordStyle.lineSpacing = 8.0f;
            NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle};
            NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:model.abstractValue attributes:wordDic];
            self.shoumingL.attributedText = wordLabelAttStr;
            
//            [NSMutableAttributedString alloc]initWithString:<#(nonnull NSString *)#> attributes:@{}
//            NSp
//             CGFloat height1 = [getUserCenter customGetContactHeight:model.abstractValue FontOfSize:13 LabelMaxWidth:ScreenWidth-30 jianju:0.0];
            CGFloat height1 = [model.abstractValue boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
            
            self.H5.constant = 1 + height1;
        }else {
            
            self.H5.constant = 0;
        }
       
       
        if (model.ranking > 0) {
            self.paimingL.text = @(model.ranking).p0fString;
        }else {
            
            self.H6.constant = 0;
        }
        
        if (kIsCNY) {
            
            if (model.costRmb > 0) {
                
                if (model.costRmb >= YI) {
                    self.shichangL.text = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                    
                }else {
                    
                    self.shichangL.text  = [NSString stringWithFormat:@"$%.2f%@",model.costRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
                }
            }else {
                
                self.H7.constant = 0;
            }
        }else{
            
            if (model.costDollar > 0) {
                
                if (model.costDollar >= YI) {
                    self.shichangL.text = [NSString stringWithFormat:@"¥%.2f%@",model.costDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                    
                }else {
                    
                    self.shichangL.text  = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
                }
            }else {
                
                self.H7.constant = 0;
            }
        }
        
        if (model.currencyAmount > 0) {
            
            if (model.currencyAmount >= YI) {
                self.liutongliangL.text = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                self.liutongliangL.text  = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        }else {
            
            self.H8.constant = 0;
        }
        
        if (ISNSStringValid(model.maxAmount)) {
            self.zongliangL.text = model.maxAmount;
        }else {
            
            self.H9.constant = 0;
        }
        if (ISNSStringValid(model.collectFundAmount)) {
            self.mujizijingL.text = model.collectFundAmount;
        }else {
            
            self.H10.constant = 0;
        }
        
        if (ISNSStringValid(model.icoCost)) {
            
            self.icoChengBenL.text = model.icoCost;
        }else {
            
            self.H11.constant = 0;
        }
        if (ISNSStringValid(model.icoTime)) {
            
            self.icoTimeL.text = model.icoTime;
        }else {
            
            self.H12.constant = 0;
        }
        
        if (ISNSStringValid(model.websiteAddress)) {
            
            self.guangwangL.text = model.websiteAddress;
        }else {
            
            self.H13.constant = 0;
        }
        if (ISNSStringValid(model.explorerAddress)) {
            
            self.quguangzhangL.text = model.explorerAddress;
        }else {
            
            self.H14.constant = 0;
        }
        
        if (ISNSStringValid(model.whiteBookAddress)) {
            
            self.baipishuL.text = model.whiteBookAddress;
        }else {
            
            self.H15.constant = 0;
        }
        
    }else {
        self.H0.constant = 0;
        self.H1.constant = 0;
        self.H2.constant = 0;
        self.H3.constant = 0;
        self.H4.constant = 0;
        self.H5.constant = 0;
        self.H6.constant = 0;
        self.H7.constant = 0;
        self.H8.constant = 0;
        self.H9.constant = 0;
        self.H10.constant = 0;
        self.H11.constant = 0;
        self.H12.constant = 0;
        self.H13.constant = 0;
        self.H14.constant = 0;
        self.H15.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
