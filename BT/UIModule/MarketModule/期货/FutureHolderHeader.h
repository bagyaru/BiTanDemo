//
//  BTCoinHolderHeader.h
//  BT
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

typedef void(^FutureHolderHeaderCompletion)(NSInteger type);

@interface FutureHolderHeader : BTView

@property (weak, nonatomic) IBOutlet BTLabel *titleL;

@property (weak, nonatomic) IBOutlet BTButton *fiveBtn;
@property (weak, nonatomic) IBOutlet BTButton *fiftyBtn;
@property (weak, nonatomic) IBOutlet BTButton *hourBtn;

@property (nonatomic, copy) FutureHolderHeaderCompletion completion;


@end
