//
//  BTDetailHeaderView.h
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "CurrencyModel.h"
#import "BTHorizotalKlineIndicator.h"
@interface BTDetailHeaderView : BTView

@property (nonatomic, strong) CurrencyModel *priCryModel;
@property (nonatomic, strong) CurrencyModel *cryModel;


@property (weak, nonatomic) IBOutlet UIView *viewQuotesHeader;

@property (weak, nonatomic) IBOutlet UIView *viewSegment;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewFenshi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConst;
@property (weak, nonatomic) IBOutlet UIView *klineBgView;

@property (weak, nonatomic) IBOutlet UIView *viewWarning;

@property (weak, nonatomic) IBOutlet UIView *timelineWarningView;

@property (nonatomic, assign) BOOL isFullScreen;
// type
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong)BTHorizotalKlineIndicator *horizotalKlineIndicator;



@end
