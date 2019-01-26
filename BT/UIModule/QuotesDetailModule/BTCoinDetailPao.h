//
//  BTCoinDetailPao.h
//  BT
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "CurrencyModel.h"

@interface BTCoinDetailPao : BTView

@property (weak, nonatomic) IBOutlet BTLabel *labelPriceTwo;

@property (nonatomic, strong) CurrencyModel *priCryModel;
@property (nonatomic, strong) CurrencyModel *cryModel;
@property (nonatomic, assign) BOOL isPriceWarning;

@end
