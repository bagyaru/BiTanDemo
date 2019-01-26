//
//  BTViewRotationHeader.h
//  BT
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "CurrencyModel.h"
@protocol BTViewRotationHeaderDelegate<NSObject>
- (void)exitFullScreen;
@end

@interface BTViewRotationHeader : BTView

@property (nonatomic, weak)id<BTViewRotationHeaderDelegate> delegate;
@property (nonatomic, strong)CurrencyModel *cryModel;

//- (void)startTimeForTime;
//- (void)stopTimeForTime;

@end
