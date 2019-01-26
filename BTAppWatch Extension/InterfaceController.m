//
//  InterfaceController.m
//  BTAppWatch Extension
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "BTAppWatchModel.h"
#import "LCNetworking.h"
#import "BTAppWatchCell.h"
#define SHIZHI_URL @"http://api.bitane.io/market/market-rest/market-info-list-v2"
@interface InterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation InterfaceController
#pragma lazy
-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loadData];
    [self startTimer];
    //[self.tableView setNumberOfRows:0 withRowType:@"BTAWCell"];
}
-(void)didDeactivate {
    [super didDeactivate];
    [self stopTimer];
}


- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(requestData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
    
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
-(void)loadData {

    NSString *URL = SHIZHI_URL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"marketType"]   = @(1);
    params[@"pageIndex"]    = @(1);
    params[@"pageSize"]     = @(30);
    params[@"sortType"]     = @(8);
    //[self.dataArray removeAllObjects];
    [LCNetworking PostWithURL:URL Params:params success:^(NSDictionary *responseObject) {
        
        if (![responseObject[@"data"] isKindOfClass:[NSArray class]]) return;
        self.dataArray = @[].mutableCopy;
        for (NSDictionary *dic in responseObject[@"data"]) {
            BTAppWatchModel *model = [BTAppWatchModel objectWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView setNumberOfRows:self.dataArray.count withRowType:@"BTAWCell"];
        [self loadTabViewDate];
    } failure:^(NSString *error) {
        NSLog(@"POST_failure____%@", error);
    }];
}
-(void)requestData {
    
    NSMutableArray *visibleData = self.dataArray.mutableCopy;
    if (visibleData.count == 0) {
        return;
    }
    
    NSString *URL = SHIZHI_URL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"marketType"]   = @(1);
    params[@"pageIndex"]    = @(1);
    params[@"pageSize"]     = @(30);
    params[@"sortType"]     = @(8);
    //[self.dataArray removeAllObjects];
    [LCNetworking PostWithURL:URL Params:params success:^(NSDictionary *responseObject) {
        NSLog(@"POST_success____%@_____resultMsg==%@", responseObject,responseObject[@"resultMsg"]);
        
        if (![responseObject[@"data"] isKindOfClass:[NSArray class]]) return;
        
        for(int i = 0;i < visibleData.count;i++){
            BTAppWatchModel *model = visibleData[i];
            //NSIndexPath *indexPath = visibleArray[i];
            for(NSDictionary *dict in responseObject[@"data"]){
                BTAppWatchModel *changeModel =[BTAppWatchModel objectWithDictionary:dict];
                if([model.kindCode isEqualToString:changeModel.kindCode]){
                    changeModel.type = [self compareSecondModel:changeModel  firstModel:model];
                    if (self.dataArray.count != 0) {
                       [self.dataArray replaceObjectAtIndex:i withObject:changeModel];
                    }
                }
            }
        }
//        
//        for (NSDictionary *dic in responseObject[@"data"]) {
//            BTAppWatchModel *model = [BTAppWatchModel objectWithDictionary:dic];
//            NSLog(@"%@",model.kind);
//            [self.dataArray addObject:model];
//        }
        [self loadTabViewDate];
    } failure:^(NSString *error) {
        NSLog(@"POST_failure____%@", error);
    }];
}
-(void)loadTabViewDate {
    
    for(int i = 0; i < self.dataArray.count; i ++){
        BTAppWatchModel *model = [self.dataArray objectAtIndex:i];
        BTAppWatchCell*cell = [self.tableView rowControllerAtIndex:i];
        [cell setCellContent:model];
    }
}
- (NSInteger)compareSecondModel:(BTAppWatchModel*)secondModel firstModel:(BTAppWatchModel*)firstModel{
    if ([secondModel.priceCNY doubleValue] > [firstModel.priceCNY doubleValue]) {
        return 1;
    }else if ([secondModel.priceCNY doubleValue] == [firstModel.priceCNY doubleValue]){
        return 0;
    }else{
        return 2;
    }
}


@end



