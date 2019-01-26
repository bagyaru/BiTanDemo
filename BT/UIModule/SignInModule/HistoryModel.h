//
//  HistoryModel.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

/**主标题*/
@property (nonatomic,copy) NSString *getway;
/**主标题英文*/
@property (nonatomic,copy) NSString *getwayEn;
/**时间*/
@property (nonatomic,assign) NSInteger dateTime;
/**探力*/
@property (nonatomic,assign) NSInteger coin;

@end
