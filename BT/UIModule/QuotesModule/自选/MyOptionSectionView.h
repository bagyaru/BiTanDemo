//
//  MyOptionSectionView.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SectionViewType){
    SectionViewTypeOption,
    SectionViewTypeMarket,
    SectionViewTypeCurrentcy
};

typedef NS_ENUM(NSInteger,SortType) {
    SortTypeNameAscending  = 1,
    SortTypeNameDescending = 2,
    SortTypeUpOrDownAscending = 3,
    SortTypeUpOrDownDescending = 4,
    SortTypeCountAscending = 5,
    SortTypeCountDescending = 6,
    SortTypeShizhiAscending = 7,
    SortTypeShizhiDescending = 8,
    SortTypeCurrentPriceAscending = 9,
    SortTypeCurrentPriceDescending = 10,
    
};

typedef void(^SortBlock)(NSInteger type);
typedef void(^HandleBlock)(NSInteger type);
typedef void(^CountBlock)(NSInteger type);
typedef void(^SortPriceBlock)(NSInteger type);
typedef void(^SortShizhiBlock)(NSInteger type);


@interface MyOptionSectionView : UIView

@property (nonatomic, copy) SortBlock sortBlock;

@property (nonatomic, copy) HandleBlock handleBlock;

@property (nonatomic, copy) CountBlock countBlock;

@property (nonatomic, copy) SortPriceBlock sortPriceBlock;

@property (nonatomic, copy) SortShizhiBlock sortShizhiBlock;

@property (nonatomic, assign) SectionViewType type;

@property (weak, nonatomic) IBOutlet BTButton *btnCount;

@property (nonatomic, assign) BOOL isSelectCount;

@property (nonatomic, assign) BOOL hiddenLine;

@property (nonatomic, assign) BOOL btnCurrentPrieEnable;

@property (nonatomic, assign) BOOL isShizhi;

- (void)showInViewWith:(UIView *)parentView;
- (IBAction)clickedBtnSort:(id)sender;

@end
