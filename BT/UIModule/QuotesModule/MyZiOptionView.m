//
//  MyOptionSectionView.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyZiOptionView.h"
#import "GroupSideView.h"

#define downPng @"sort_down.png"
#define upPng   @"sort_up.png"

@interface MyZiOptionView ()

@property (weak, nonatomic) IBOutlet BTButton *btnSort;


@property (weak, nonatomic) IBOutlet BTButton *btnCurrentPrice;


@property (weak, nonatomic) IBOutlet BTButton *btnUpAndDown;


@property (nonatomic, assign) BOOL isSelectSort;


@property (nonatomic, assign) BOOL isSelectUpAndDown;

@property (nonatomic, assign) BOOL isSelectShizhi;


@property (weak, nonatomic) IBOutlet UIImageView *imageSortIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *imageUpAndDownIndicator;

@property (weak, nonatomic) IBOutlet BTButton *morenBtn;

@end

@implementation MyZiOptionView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = ViewBGColor;
    
    self.imageSortIndicator.image = [UIImage imageNamed:@"filterdown"];
    self.imageUpAndDownIndicator.image = [UIImage imageNamed:@"unsort"];
    [self.btnSort setTitleColor:FirstColor forState:UIControlStateNormal];
    [self.btnSort setTitleColor:FirstColor forState:UIControlStateSelected];
    
    self.btnSort.ts_acceptEventInterval = 2.0f;
    ///初始化
    [self.btnSort setTitle:[APPLanguageService sjhSearchContentWith:@"quanbu"] forState:UIControlStateNormal];
    
    [self.btnCurrentPrice setTitleColor:ThirdColor forState:UIControlStateNormal];
    
    //默认
    [self.morenBtn setTitleColor:FirstColor forState:UIControlStateSelected];
    [self.morenBtn setTitleColor:ThirdColor forState:UIControlStateNormal];
    //24H涨跌
    [self.btnUpAndDown setTitleColor:ThirdColor forState:UIControlStateNormal];
    [self.btnUpAndDown setTitleColor:FirstColor forState:UIControlStateSelected];
//    self.imageUpAndDownIndicator.hidden = YES;
    
    [AppHelper addLineWithParentView:self];
    [AppHelper addLineTopWithParentView:self];
}

- (void)setBtnCurrentPrieEnable:(BOOL)btnCurrentPrieEnable{
    _btnCurrentPrieEnable = btnCurrentPrieEnable;
    self.btnCurrentPrice.userInteractionEnabled = NO;
}

- (IBAction)clickedBtnUpAndDown:(id)sender {
    
    self.isSelectSort = NO;
    self.morenBtn.selected = NO;
    self.btnUpAndDown.selected = YES;
    
    self.isSelectUpAndDown =!self.isSelectUpAndDown;
    self.imageUpAndDownIndicator.hidden = NO;
    self.imageUpAndDownIndicator.image = self.isSelectUpAndDown ? [UIImage imageNamed:@"sort_down"] : [UIImage imageNamed:@"sort_up"];
    if (self.handleBlock) {
        if (self.isSelectUpAndDown) {
            self.handleBlock(SortTypeUpOrDownDescending);
        }else{
            self.handleBlock(SortTypeUpOrDownAscending);
        }
    }
}

//选择自选分组
- (IBAction)clickedBtnSort:(id)sender {
    if(self.selectGroupBlock){
        self.selectGroupBlock();
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

//点击默认排序
- (IBAction)morenSelectAction:(id)sender {
    self.morenBtn.selected = YES;
    self.btnUpAndDown.selected = NO;
    self.btnCurrentPrice.selected = NO;
    self.isSelectUpAndDown = NO;
//    self.imageUpAndDownIndicator.hidden = YES;
    self.imageUpAndDownIndicator.image = [UIImage imageNamed:@"unsort"];
    self.isSelectSort = !self.isSelectSort;
    if (self.sortBlock) {
        if (self.isSelectSort) {
            self.sortBlock(SortTypeNameDescending);
        }else{
            self.sortBlock(SortTypeNameAscending);
        }
    }
}

- (void)setGroupName:(NSString *)name{
    [self.btnSort setTitle:name forState:UIControlStateNormal];
}

@end
