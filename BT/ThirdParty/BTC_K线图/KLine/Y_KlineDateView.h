//
//  Y_KlineDateView.h
//  BT
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLinePositionModel.h"
#import "Y_KLineModel.h"

@interface Y_KlineDateView : UIView

/**
 * 需要绘制的K线模型数组
 */
@property (nonatomic, strong) NSArray<Y_KLineModel*> *needDrawKLineModels;

/**
 * 需要绘制的K线位置数组
 */
@property (nonatomic, strong) NSArray<Y_KLinePositionModel*> *needDrawKLinePositionModels;

@property (nonatomic, assign) BOOL isFullScreen;

- (void)draw;


@end
