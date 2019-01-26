//
//  BTConfigureService.m
//  BT
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTConfigureService.h"
#import "BTConfig.h"
#import "TimerRequest.h"
#import "BTHotSearchRwquest.h"
#import "CurrentcyModel.h"
#import "BTShareDomainRequest.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"
@implementation BTConfigureService

+ (instancetype)shareInstanceService{
    static BTConfigureService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[BTConfigureService alloc] init];
    });
    return service;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.timeSepa = 3.0;
        self.hotSearchArray = @[];
    }
    return self;
}





#pragma mark - 检查服务器地址
- (void)checkServerSite{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"BT.bt"];
    
    NSError *error;
    NSString *textFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error == nil && nil != textFile) {
        NSArray *lines = [textFile componentsSeparatedByString:@"\n"];
        if (lines.count >= 2) {
            NSString *domain = [lines objectAtIndex:0];
//            NSString *h5Domain = [lines objectAtIndex:1];
//            NSString *Post_h5domain = [lines objectAtIndex:2];
//            NSString *Info_h5domain = [lines objectAtIndex:3];
            
            [BTConfig sharedInstance].domain        = domain;
//            [BTConfig sharedInstance].h5domain      = h5Domain;
//            [BTConfig sharedInstance].Info_h5domain = Info_h5domain;
//            [BTConfig sharedInstance].Post_h5domain = Post_h5domain;
        }
    } else {
#ifdef DEBUG
        [BTConfig sharedInstance].domain        = BTDomainDev;
//        [BTConfig sharedInstance].h5domain      = BTDomainH5Dev;
//        [BTConfig sharedInstance].Info_h5domain = Info_BTDomainH5Dev;
//        [BTConfig sharedInstance].Post_h5domain = Post_BTDomainH5Dev;
#else
        [BTConfig sharedInstance].domain = BTDomainProduct;
//        [BTConfig sharedInstance].h5domain = BTDomainH5Product;
//        [BTConfig sharedInstance].Info_h5domain = Info_BTDomainH5Product;
//        [BTConfig sharedInstance].Post_h5domain = Post_BTDomainH5Product;
#endif
    }
}

- (void)checkTimerInterVal{
    TimerRequest *re = [TimerRequest new];
    [re requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.data) {
            if ([request.data integerValue] > 0) {
                 self.timeSepa = [request.data integerValue];
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

-(void)saveHotSearchData {
    
    BTHotSearchRwquest *re = [BTHotSearchRwquest new];
    [re requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.data) {
            if ([request.data count] > 0) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in request.data) {
                    CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
                    [array addObject:model.currencySimpleName];
                }
                self.hotSearchArray = array;
                NSLog(@"热门搜索==========%@",self.hotSearchArray);
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
- (void)getGlobal_HTML_configuration {
    
    BTShareDomainRequest *api = [BTShareDomainRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        
        if ([request.data isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in request.data) {
                
                if ([dict[@"domainId"] integerValue] == 1) {
                    
                    [BTConfig sharedInstance].h5domain      = dict[@"domain"];
                }
                if ([dict[@"domainId"] integerValue] == 2) {
                    
                  [BTConfig sharedInstance].Post_h5domain = dict[@"domain"];
                }
                if ([dict[@"domainId"] integerValue] == 3) {
                    
                    [BTConfig sharedInstance].Info_h5domain = dict[@"domain"];
                }
            }
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
//检查未读消息
- (void)checkMessageCenter {
    if ([getUserCenter isLogined]) {
        
        KPostNotification(@"JiGuangTuiSong", nil)
        CheckMessageUnreadRequest *api = [[CheckMessageUnreadRequest alloc] initWithCheckMessageUnread];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            MessageModel *model = [MessageModel modelWithJSON:request.data];
            UITabBarItem * item=[getMainTabBar.tabBar.items objectAtIndex:4];
            if(@available(iOS 10.0, *)){
                item.badgeColor = kHEXCOLOR(0xE8003F);
            }
            NSInteger total = model.comment + model.like + model.message + model.mention;
            if (total > 0) {
                
                item.badgeValue = total > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",total];
            }else {
                item.badgeValue = nil;
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    }
}
@end
