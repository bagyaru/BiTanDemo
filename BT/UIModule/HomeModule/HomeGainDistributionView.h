//
//  HomeGainDistributionView.h
//  BT
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface HomeGainDistributionView : BTView
@property (nonatomic,strong) NSArray *heightArray;
@property (nonatomic,strong) NSArray *numbArray;
-(void)strokeChart;
@end
