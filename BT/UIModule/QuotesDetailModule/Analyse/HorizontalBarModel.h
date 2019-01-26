//
//  HorizontalBarModel.h
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HorizontalBarModel : NSObject

@property (nonatomic,copy) NSString *mainTitle;
/**成交量*/
@property (nonatomic,assign) double tradeAmount;
/**比例*/
@property (nonatomic,assign) CGFloat proportion;
/**进度条比例*/
@property (nonatomic,assign) CGFloat progressScale;

@end
