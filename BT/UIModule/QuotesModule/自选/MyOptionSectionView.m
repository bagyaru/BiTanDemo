//
//  MyOptionSectionView.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyOptionSectionView.h"

#define downPng @"sort_down"
#define upPng   @"sort_up"

@interface MyOptionSectionView ()

@property (weak, nonatomic) IBOutlet BTButton *btnSort;

@property (weak, nonatomic) IBOutlet BTButton *btnCurrentPrice;

@property (weak, nonatomic) IBOutlet BTButton *btnUpAndDown;
@property (nonatomic, assign) BOOL isSelectSort;

@property (nonatomic, assign) BOOL isSelectUpAndDown;
@property (nonatomic, assign) BOOL isSelectCurrentPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (nonatomic, assign) BOOL isSelectShizhi;

@property (weak, nonatomic) IBOutlet BTButton *btnShizhi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnCountLeading;

@property (weak, nonatomic) IBOutlet UIImageView *imageSortIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageSortIndicatorWidth;

@property (weak, nonatomic) IBOutlet UIImageView *imageShizhiIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageShizhiIndicatorWidth;


@property (weak, nonatomic) IBOutlet UIImageView *imageCountIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageCountIndicatorWidth;


@property (weak, nonatomic) IBOutlet UIImageView *imageUpAndDownIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageUpAndDownIndicatorWidth;

@property (weak, nonatomic) IBOutlet UIImageView *imageCurrentPrice;


@end

@implementation MyOptionSectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    //self.backgroundColor = CWhiteColor;
    self.backgroundColor = ViewBGColor;
    [self.btnSort setTitleColor:ThirdColor forState:UIControlStateNormal];
    self.labelInfo.textColor = ThirdColor;
    
    [self.btnCount setTitleColor:ThirdColor forState:UIControlStateNormal];
    [self.btnCurrentPrice setTitleColor:ThirdColor forState:UIControlStateNormal];
    [self.btnSort setTitleColor:FirstColor forState:UIControlStateSelected];
    [self.btnCount setTitleColor:FirstColor forState:UIControlStateSelected];
    [self.btnCurrentPrice setTitleColor:FirstColor forState:UIControlStateSelected];
    
    [self.btnUpAndDown setTitleColor:ThirdColor forState:UIControlStateNormal];
    [self.btnUpAndDown setTitleColor:FirstColor forState:UIControlStateSelected];
    
    [self.btnShizhi setTitleColor:ThirdColor forState:UIControlStateNormal];
    [self.btnShizhi setTitleColor:FirstColor forState:UIControlStateSelected];
    
    [AppHelper addLineWithParentView:self];
    [AppHelper addLineTopWithParentView:self];
    [self setTheImageView:self.imageUpAndDownIndicator];
    [self setTheImageView:self.imageCurrentPrice];
    [self setTheImageView:self.imageSortIndicator];
    [self setTheImageView:self.imageCountIndicator];
    [self setTheImageView:self.imageShizhiIndicator];
}

- (void)setType:(SectionViewType)type{
    _type = type;
    switch (self.type) {
        case SectionViewTypeOption:{
            self.btnSort.fixTitle = @"morenpaixu";
            self.btnCount.hidden = YES;
        }
            break;
        case SectionViewTypeMarket:{
            self.btnSort.fixTitle = @"mingcheng";
            self.btnCount.fixTitle =@"chengjiaoe";
            self.btnCount.hidden = YES;
            self.imageShizhiIndicator.image = [UIImage imageNamed:downPng];
//            self.imageSortIndicator.hidden = YES;
//            self.constraintImageSortIndicatorWidth.constant = 0;
//            self.imageCountIndicator.hidden = YES;
        }
            break;
        case SectionViewTypeCurrentcy:{
            self.btnSort.fixTitle = @"mingcheng";
            self.btnCount.fixTitle =@"chengjiaoe";
            self.imageCountIndicator.image = [UIImage imageNamed:downPng];
            //            self.imageSortIndicator.hidden = YES;
            //            self.constraintImageSortIndicatorWidth.constant = 0;
            //            self.imageShizhiIndicator.hidden = YES;
            //            self.imageCurrentPrice.hidden = YES;
            //            self.imageUpAndDownIndicator.hidden = YES;
            self.imageShizhiIndicator.hidden = YES;
            self.btnCount.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setBtnCurrentPrieEnable:(BOOL)btnCurrentPrieEnable{
    _btnCurrentPrieEnable = btnCurrentPrieEnable;
    self.btnCurrentPrice.userInteractionEnabled = NO;
}

- (void)setHiddenLine:(BOOL)hiddenLine{
    _hiddenLine = hiddenLine;
    self.labelInfo.hidden = _hiddenLine;
    self.imageSortIndicator.hidden = _hiddenLine;
}

//市值
- (void)setIsShizhi:(BOOL)isShizhi{
    _isShizhi = isShizhi;
    if (_isShizhi) {
        self.btnShizhi.hidden = NO;
        self.btnCount.hidden = NO;
        if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            self.constraintBtnCountLeading.constant = 45;
        }else{
            self.constraintBtnCountLeading.constant = 70.0f;
        }
        
        self.isSelectShizhi = YES;
        self.btnShizhi.selected = YES;
        self.imageSortIndicator.hidden = NO;
//        self.constraintImageSortIndicatorWidth.constant = 0;
//        self.imageCountIndicator.hidden = YES;
//        self.imageCurrentPrice.hidden = YES;
//        self.imageUpAndDownIndicator.hidden = YES;
        [self setTheImageView:self.imageCountIndicator];
        [self setTheImageView:self.imageCurrentPrice];
        [self setTheImageView:self.imageUpAndDownIndicator];
        
    }else{
        self.isSelectShizhi = NO;
        self.btnShizhi.selected = NO;
    }
  
}

- (IBAction)clickedBtnUpAndDown:(id)sender {
    self.btnSort.selected = NO;
    self.btnCount.selected = NO;
    self.btnShizhi.selected = NO;
    self.btnCurrentPrice.selected = NO;
    self.isSelectSort = NO;
    self.isSelectCount = NO;
    self.isSelectCurrentPrice = NO;
    self.isSelectUpAndDown = !self.isSelectUpAndDown;
    self.btnUpAndDown.selected = YES;
//    self.imageSortIndicator.hidden = YES;
//    self.constraintImageSortIndicatorWidth.constant = 0;
//    self.imageShizhiIndicator.hidden = YES;
//    self.imageCountIndicator.hidden = YES;
//    self.imageCurrentPrice.hidden = YES;
    [self setTheImageView:self.imageSortIndicator];
    [self setTheImageView:self.imageShizhiIndicator];
    [self setTheImageView:self.imageCountIndicator];
    [self setTheImageView:self.imageCurrentPrice];
    
    
    self.imageUpAndDownIndicator.hidden = NO;
    self.imageUpAndDownIndicator.image = self.isSelectUpAndDown ? [UIImage imageNamed:downPng] : [UIImage imageNamed:upPng];
    if (self.handleBlock) {
        if (self.isSelectUpAndDown) {
            self.handleBlock(SortTypeUpOrDownDescending);
        }else{
            self.handleBlock(SortTypeUpOrDownAscending);
        }
    }
}

- (IBAction)clickedBtnSort:(id)sender {
    self.btnUpAndDown.selected = NO;
    self.btnCount.selected = NO;
    self.btnCurrentPrice.selected = NO;
    self.btnShizhi.selected = NO;
    self.isSelectUpAndDown = NO;
    self.isSelectCount = NO;
    self.isSelectCurrentPrice = NO;
    self.isSelectShizhi = NO;
    self.isSelectSort = !self.isSelectSort;
    self.btnSort.selected = YES;
//    self.imageShizhiIndicator.hidden = YES;
//    self.imageCountIndicator.hidden = YES;
//    self.imageCurrentPrice.hidden = YES;
//    self.imageUpAndDownIndicator.hidden = YES;
    [self setTheImageView:self.imageUpAndDownIndicator];
    [self setTheImageView:self.imageShizhiIndicator];
    [self setTheImageView:self.imageCountIndicator];
    [self setTheImageView:self.imageCurrentPrice];
    
    self.imageSortIndicator.hidden = NO;
    self.constraintImageSortIndicatorWidth.constant = 6;
    self.imageSortIndicator.image = self.isSelectSort ? [UIImage imageNamed:downPng] : [UIImage imageNamed:upPng];
    self.imageSortIndicator.hidden = self.hiddenLine;
    if (self.sortBlock) {
        if (self.isSelectSort) {
            self.sortBlock(SortTypeNameDescending);
        }else{
            self.sortBlock(SortTypeNameAscending);
        }
    }
}
//
- (IBAction)clickedBtnCount:(id)sender {
    //成交量
    self.btnSort.selected = NO;
    self.btnUpAndDown.selected = NO;
    self.btnCurrentPrice.selected = NO;
    self.btnShizhi.selected = NO;
    
    self.isSelectSort = NO;
    self.isSelectUpAndDown = NO;
    self.isSelectCurrentPrice = NO;
    self.isSelectShizhi = NO;
    self.isSelectCount = !self.isSelectCount;
    self.btnCount.selected = YES;
    
    //self.imageSortIndicator.hidden = YES;
    //self.constraintImageSortIndicatorWidth.constant = 0;
    //self.imageShizhiIndicator.hidden = YES;
    //self.imageCurrentPrice.hidden = YES;
    //self.imageUpAndDownIndicator.hidden = YES;
    [self setTheImageView:self.imageUpAndDownIndicator];
    [self setTheImageView:self.imageShizhiIndicator];
    [self setTheImageView:self.imageSortIndicator];
    [self setTheImageView:self.imageCurrentPrice];
    self.imageCountIndicator.hidden = NO;
    self.imageCountIndicator.image = self.isSelectCount ? [UIImage imageNamed:downPng] : [UIImage imageNamed:upPng];
    if (self.isSelectCount) {
        if (self.countBlock) {
            self.countBlock(SortTypeCountDescending);
        }
    }else{
        if (self.countBlock) {
            self.countBlock(SortTypeCountAscending);
        }
        
    }
    
}

- (IBAction)sortPrice:(id)sender {
    self.btnSort.selected = NO;
    self.btnUpAndDown.selected = NO;
    self.btnCount.selected = NO;
    self.btnShizhi.selected = NO;
    self.isSelectSort = NO;
    self.isSelectUpAndDown = NO;
    self.isSelectCount = NO;
    self.isSelectShizhi = NO;
    self.isSelectCurrentPrice = !self.isSelectCurrentPrice;
    self.btnCurrentPrice.selected = YES;
    
//    self.imageSortIndicator.hidden = YES;
//    self.constraintImageSortIndicatorWidth.constant = 0;
//    self.imageShizhiIndicator.hidden = YES;
//    self.imageCountIndicator.hidden = YES;
//    self.imageUpAndDownIndicator.hidden = YES;
    [self setTheImageView:self.imageUpAndDownIndicator];
    [self setTheImageView:self.imageShizhiIndicator];
    [self setTheImageView:self.imageCountIndicator];
    [self setTheImageView:self.imageSortIndicator];
    
    self.imageCurrentPrice.hidden = NO;
    self.imageCurrentPrice.image = self.isSelectCurrentPrice ? [UIImage imageNamed:downPng] : [UIImage imageNamed:upPng];
    if (self.sortPriceBlock) {
        if (self.isSelectCurrentPrice) {
            self.sortPriceBlock(SortTypeCurrentPriceDescending);
        }else{
            self.sortPriceBlock(SortTypeCurrentPriceAscending);
        }
    }
    
}

- (IBAction)clickedShizhi:(id)sender {
    self.btnSort.selected = NO;
    self.btnCount.selected = NO;
    self.btnCurrentPrice.selected = NO;
    self.btnUpAndDown.selected = NO;
   
    self.isSelectSort = NO;
    self.isSelectCount = NO;
    self.isSelectCurrentPrice = NO;
     self.isSelectUpAndDown = NO;
    self.btnShizhi.selected = YES;
    self.isSelectShizhi = !self.isSelectShizhi;
//    self.imageSortIndicator.hidden = YES;
//    self.constraintImageSortIndicatorWidth.constant = 0;
//    self.imageCurrentPrice.hidden = YES;
//    self.imageUpAndDownIndicator.hidden = YES;
//    self.imageCountIndicator.hidden = YES;
    
    [self setTheImageView:self.imageUpAndDownIndicator];
    [self setTheImageView:self.imageCurrentPrice];
    [self setTheImageView:self.imageSortIndicator];
    [self setTheImageView:self.imageCountIndicator];
    
    self.imageShizhiIndicator.hidden = NO;
    self.imageShizhiIndicator.image = self.isSelectShizhi ? [UIImage imageNamed:downPng] :  [UIImage imageNamed:upPng];
    if (self.sortShizhiBlock) {
        if (self.isSelectShizhi) {
            self.sortShizhiBlock(SortTypeShizhiDescending);
        }else{
            self.sortShizhiBlock(SortTypeShizhiAscending);
        }
        
    }
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

- (void)setTheImageView:(UIImageView*)imageView{
    imageView.image = [UIImage imageNamed:@"unsort"];
}

@end
