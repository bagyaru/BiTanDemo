//
//  IntroduceCell.m
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IntroduceCell.h"

@interface IntroduceCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) IBOutlet UILabel *labelIntroduce;

@property (weak, nonatomic) IBOutlet UILabel *labelSimple;

@property (weak, nonatomic) IBOutlet UILabel *labelEnglishName;

@property (weak, nonatomic) IBOutlet UILabel *labelChineseName;


@property (weak, nonatomic) IBOutlet UILabel *labelConcept;
@property (weak, nonatomic) IBOutlet BTLabel *xggnL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xggnTop;


@property (weak, nonatomic) IBOutlet UILabel *labelRanking;

@property (weak, nonatomic) IBOutlet UILabel *labelMarket;

@property (weak, nonatomic) IBOutlet UILabel *labelLiuCount;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalCount;

@property (weak, nonatomic) IBOutlet UILabel *labelMuji;

@property (weak, nonatomic) IBOutlet UILabel *labelIcoCost;


@property (weak, nonatomic) IBOutlet UILabel *labelIcoTime;

@property (weak, nonatomic) IBOutlet UILabel *labelWiteBookAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelwebsite;
@property (weak, nonatomic) IBOutlet UILabel *labelQukuaiAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h10;



@end

@implementation IntroduceCell{
    IntroduceModel *_model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelIntroduce.preferredMaxLayoutWidth = ScreenWidth - 30;
    self.contentView.backgroundColor = CWhiteColor;
    self.viewBg.backgroundColor = CWhiteColor;
    for (NSInteger i = 100; i < 110; i++) {
        UIView *iv = [self.viewBg viewWithTag:i];
        iv.backgroundColor = [UIColor redColor];
        if (i == 100) {
            [AppHelper addLineTopWithParentView:iv];
        }
        [AppHelper addLineWithParentView:iv];
    }
    self.labelWiteBookAddress.textColor = CBlueColor;
    self.labelwebsite.textColor = CBlueColor;
    self.labelQukuaiAddress.textColor = CBlueColor;
    UITapGestureRecognizer *tapwhiteAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.whiteAddressBlock && [_model.whiteBookAddress containsString:@"http"]) {
            self.whiteAddressBlock(_model.whiteBookAddress);
        }
    }];
    self.labelWiteBookAddress.userInteractionEnabled = YES;
    [self.labelWiteBookAddress addGestureRecognizer:tapwhiteAddress];
    
    UITapGestureRecognizer *tapwebAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.webSiteAddressBlock && [_model.websiteAddress containsString:@"http"]) {
            self.webSiteAddressBlock(_model.websiteAddress);
        }
    }];
    self.labelwebsite.userInteractionEnabled = YES;
    [self.labelwebsite addGestureRecognizer:tapwebAddress];
    
    UITapGestureRecognizer *tapqukuaiAddress = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.qukuaiAddressBlock && [_model.websiteAddress containsString:@"http"]) {
            self.qukuaiAddressBlock(_model.websiteAddress);
        }
    }];
    self.labelQukuaiAddress.userInteractionEnabled = YES;
    [self.labelQukuaiAddress addGestureRecognizer:tapqukuaiAddress];
    
    
}

+ (instancetype)shareInstance{
    static IntroduceCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([IntroduceCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

+ (CGFloat)cellHeightWith:(IntroduceModel *)model{
    IntroduceCell *cell = [self shareInstance];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    if (model == nil) {
        
        return 0;
    }
    [cell configWith:model];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"%.0f",height);
    return height;
}

- (void)configWith:(IntroduceModel *)model{
    if (model) {
        _model = model;
        self.labelSimple.text = model.currencySimpleName;
        self.labelEnglishName.text = model.currencyEnglishName;
        self.labelChineseName.text = model.currencyChineseName;
        if (model.abstractValue.length == 0) {
            self.labelIntroduce.text = @"";
        }else{
            self.labelIntroduce.text = model.abstractValue;
        }
       
        if (ISNSStringValid(model.relatedNotion)) {
            self.labelConcept.text = model.relatedNotion;
        }else {
           
            self.xggnTop.constant = -16;
            self.xggnL.hidden = YES;
        }
        self.h4.constant = 0;
        if (model.ranking > 0) {
            self.labelRanking.text = @(model.ranking).p0fString;
        }else {
            self.h1.constant = 0;
        }
        
        if (kIsCNY) {
            
            if (model.costRmb > 0) {
               
                if (model.costRmb >= YI) {
                    self.labelMarket.text = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                    
                }else {
                    
                    self.labelMarket.text  = [NSString stringWithFormat:@"$%.2f%@",model.costRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
                }
            } else {
                self.h2.constant = 0;
            }
        }else{
           
            if (model.costDollar > 0) {
                
                if (model.costDollar >= YI) {
                    self.labelMarket.text = [NSString stringWithFormat:@"¥%.2f%@",model.costDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                    
                }else {
                    
                    self.labelMarket.text  = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
                }
            } else {
                self.h2.constant = 0;
            }
        }
        
        if (model.currencyAmount > 0) {
            
            if (model.currencyAmount >= YI) {
                self.labelLiuCount.text = [NSString stringWithFormat:@"¥%.2f%@",model.currencyAmount/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                self.labelLiuCount.text  = [NSString stringWithFormat:@"$%.2f%@",model.currencyAmount/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        } else {
            self.h3.constant = 0;
        }
        
        if (ISNSStringValid(model.collectFundAmount)) {
            self.labelMuji.text = model.collectFundAmount;
        } else {
            self.h5.constant = 0;
        }
       
        if (ISNSStringValid(model.icoCost)) {
            
             self.labelIcoCost.text = model.icoCost;
        } else {
            
            self.h6.constant = 0;
        }
        if (ISNSStringValid(model.icoTime)) {
            
            self.labelIcoTime.text = model.icoTime;
        } else {
            
            self.h7.constant = 0;
        }
       
        if (ISNSStringValid(model.websiteAddress)) {
            
            self.labelwebsite.text = model.websiteAddress;
        } else {
            
            self.h8.constant = 0;
        }
        if (ISNSStringValid(model.explorerAddress)) {
            
            self.labelQukuaiAddress.text = model.explorerAddress;
        } else {
            
            self.h9.constant = 0;
        }
        
        if (ISNSStringValid(model.whiteBookAddress)) {
            
            self.labelWiteBookAddress.text = model.whiteBookAddress;
        } else {
            
            self.h10.constant = 0;
        }
       
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
