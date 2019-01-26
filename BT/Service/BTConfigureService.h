//
//  BTConfigureService.h
//  BT
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTConfigureService : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger futureIndex;
@property (nonatomic, assign) NSInteger sheQuIndex;
@property (nonatomic, assign) NSInteger timeSepa;

@property (nonatomic, copy) NSArray  *hotSearchArray;
+ (instancetype)shareInstanceService;


/**
 * 检查服务器的配置文件，同时做到切换服务器的地址
 */
- (void) checkServerSite;

- (void)checkTimerInterVal;

- (void)getGlobal_HTML_configuration;

- (void)saveHotSearchData;

//检查未读消息
- (void)checkMessageCenter;
@end
