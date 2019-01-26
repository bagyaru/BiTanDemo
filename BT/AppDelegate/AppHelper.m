//
//  AppHelper.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppHelper.h"

#import "BTSearchService.h"

#import "BTExchangeManager.h"
#import "BTExchangeModel.h"
#import "PCNetworkClient+Account.h"
#import "SYYHuobiNetHandler.h"
#import "OKexRequestApi.h"

#import "BTUserExchangeAccountApi.h"

#import "CurrencyListRequest.h"


static NSString *kExchangecode =@"exchangeCode";
static NSString *kExchangeName =@"exchangeName";

@implementation AppHelper

+ (BTButton *)yellowTitleBtn{
    BTButton *btn = [BTButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = MediumFont;
    [btn setTitleColor:CBlackColor forState:UIControlStateSelected];
    [btn setTitleColor:CWhiteColor forState:UIControlStateNormal];
    return btn;
}

+ (UIView *)addLineTopWithParentView:(UIView *)iv{
    if (iv) {
        UIView *ivLine = [UIView new];
        ivLine.backgroundColor = SeparateColor;
        [iv addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(iv);
            make.height.mas_equalTo(0.5);
        }];
        return ivLine;
    }
    return nil;
}

+ (UIView *)addSeparateLineWithParentView:(UIView *)iv{
    if (iv) {
        UIView *ivLine = [UIView new];
        ivLine.backgroundColor = SeparateColor;
        [iv addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv).offset(15);
            make.right.equalTo(iv).offset(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(iv).offset(-0.5);
        }];
        return ivLine;
    }
    return nil;
}

+ (UIView*)addBottomLineWithParentView:(UIView *)iv{
    if (iv) {
        UIView *ivLine = [UIView new];
        ivLine.backgroundColor = iv.tag == 87541513 ? UIColorHex(dddddd) : SeparateColor;
        [iv addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(iv);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(iv).offset(-0.5);
        }];
        return ivLine;
    }
    return nil;
    
}

+ (UIView*)addLeftLineWithParentView:(UIView*)iv{
    if (iv) {
        UIView *ivLine = [UIView new];
        ivLine.backgroundColor = SeparateColor;
        [iv addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(iv);
            make.left.equalTo(iv).offset(15);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(iv).offset(-0.5);
        }];
        return ivLine;
    }
    return nil;
}

+ (UIView *)addLineWithParentView:(UIView *)iv{
    if (iv) {
        UIView *ivLine = [UIView new];
        ivLine.backgroundColor = SeparateColor;
        [iv addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(iv);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(iv).offset(-0.5);
        }];
        return ivLine;
    }
    return nil;
}

+ (void)setView:(UIView *)iv borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius{
    if (iv) {
        [iv.layer setBorderWidth:borderWidth];
        [iv.layer setBorderColor:borderColor.CGColor];
        [iv.layer setCornerRadius:cornerRadius];
        if ([iv isKindOfClass:[UIImageView class]]) {
            iv.layer.masksToBounds = YES;
        }
    }
}


+ (void)saveExchangeCode:(NSString *)exchangeCode{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(exchangeCode) forKey:kExchangecode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getExchangeCode{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kExchangecode];
}

+ (void)saveExchangeName:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(name) forKey:kExchangeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getExchangeName{
    //保存记录 兼容国际化
    if([[self getExchangeCode] isEqualToString:k_Net_Code]){
        return SAFESTRING([APPLanguageService sjhSearchContentWith:@"quanwang"]);
    }else{
        return [[NSUserDefaults standardUserDefaults] valueForKey:kExchangeName];
    }
}

+ (void)saveApiKey:(NSString *)apiKey withExchangeCode:(NSString *)exchangeCode{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(apiKey) forKey:exchangeCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveApiSecret:(NSString *)ApiSecret withExchangeCode:(NSString *)exchangeCode{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(ApiSecret) forKey:[NSString stringWithFormat:@"%@_secret",exchangeCode]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)apikeyWithExchangeCode:(NSString *)exchangeCode{
    return [[NSUserDefaults standardUserDefaults] valueForKey:exchangeCode];
}

+ (NSString*)apiSecretWithExchangeCode:(NSString *)exchangeCode{
    NSString *key = [NSString stringWithFormat:@"%@_secret",exchangeCode];
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)saveApiAccountId:(NSString *)accountId{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(accountId) forKey:@"hb_accountId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getAccountId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"hb_accountId"];
}


+ (void)saveHbApiAccountId:(NSString *)accountId{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(accountId) forKey:@"hb_accountId1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getHbApiAccountId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"hb_accountId1"];
}

+ (void)saveExchangeData:(NSArray *)data withExchangeCode:(NSString *)exchangeCode{
    NSString *key = [NSString stringWithFormat:@"%@_data",exchangeCode];
    if(data.count){
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

+ (NSArray*)getExchangeData:(NSString *)exchangeCode{
    NSString *key = [NSString stringWithFormat:@"%@_data",exchangeCode];
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if(value){
        return value;
    }
    return @[];
}

+ (void)saveExchangeTotalInfo:(NSDictionary *)info withEXCode:(NSString *)exchnageCode{
    NSString *key = [NSString stringWithFormat:@"%@_info",exchnageCode];
    if(info){
        [[NSUserDefaults standardUserDefaults] setValue:info forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSDictionary*)getExchangeTotolInfo:(NSString *)exchangeCode{
    NSString *key = [NSString stringWithFormat:@"%@_info",exchangeCode];
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if(value){
        return value;
    }
    return @{};
}

+ (NSArray*)concatFirstArr:(NSArray *)firstArr secondArray:(NSArray *)secondArr{
    NSMutableArray *arrData = @[].mutableCopy;
    [arrData addObjectsFromArray:firstArr];
    [arrData addObjectsFromArray:secondArr];
    
    NSArray *sortArray =
    [arrData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = (NSDictionary*)obj1;
        NSDictionary *dic2 = (NSDictionary*)obj2;
        
        NSString *name1 = dic1[@"kind"];
        NSString *name2 = dic2[@"kind"];
        
        return [name1 compare:name2];
    }];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSDictionary *firstInfo = sortArray.firstObject;
    __block NSString *referenceName = firstInfo[@"kind"];
    __block NSString *referType = firstInfo[@"type"];
    __block double totalFee = 0.00;
    
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *userInfo = (NSDictionary*)obj;
        NSString *name = userInfo[@"kind"];
        NSString *type = userInfo[@"type"];
        double price = [userInfo[@"count"] doubleValue];
        if ([referenceName isEqualToString:name]&&[referType isEqualToString:type]) {
            //名称相同 累加价格
            totalFee += price;
        }else {
            //名称不同 将价格保存到新数组中
            [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString),@"type":referType}];
            //同时重置全局变量
            totalFee = price;
            referenceName = name;
            referType = type;
        }
    }];
    //最后一组数据必定会跳出循环，因此在循环结束时加到数组中
    [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString),@"type":referType}];
    return arr;
    
}

+ (void)clearTanliTime{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nowDate"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:continueQianDao];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RedRiseGreenFall];
}
+ (void)startRefreshTasks{
    if (getUserCenter.userInfo.token.length == 0) {
        return;
    }
    [self refreshTasks];
}

//开始交易所定时任务
+ (void)refreshTasks{
    
    NSArray *tasks = [[BTSearchService sharedService] readExchangeAuthorizedWithUserId:SAFESTRING(@(getUserCenter.userInfo.userId))];
    if(tasks.count == 0){
        return;
    }
    for(BTExchangeModel *model in tasks){
        [self requestWithApiKey:model.exchangeKey apiSecret:model.exchangeSecret model:model];
    }
}

+ (void)requestWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret model:(BTExchangeModel*)model{
    NSString *type = model.exchangeCode;
    if([type isEqualToString:@"binance"]){
        [self bianceRequestAccount:apiKey apiSecret:apiSecret model:model];
    }
    if([type isEqualToString:@"huobi.pro"]){
        [self hbRequestAccount:apiKey apiSecret:apiSecret model:model];
    }
    if([type isEqualToString:@"okex"]){
        [self okexRequestAccount:apiKey apiSecret:apiSecret model:model];
    }
}

//
+ (void)bianceRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret model:(BTExchangeModel*)model{
    [PCNetworkClient accountInfoWithApiKey:apiKey apiSecert:apiSecret completion:^(NSError *error, id responseObj) {
        
        if(!error){
            if([responseObj isKindOfClass:[NSDictionary class]]){
                NSArray *balances = responseObj[@"balances"];
                if([balances isKindOfClass:[NSArray class]]){
                    if(balances.count == 0){
                        return ;
                    }
                    // 逻辑处理
                    NSMutableArray *mutaData =@[].mutableCopy;
                    for(NSDictionary *dict in balances){
                        double count = [SAFESTRING(dict[@"free"]) doubleValue];
                        double locked = [SAFESTRING(dict[@"locked"]) doubleValue];
                        if(count != 0){
                            NSDictionary *params =@{
                                                    @"count":SAFESTRING(dict[@"free"]),
                                                    @"kind":[SAFESTRING(dict[@"asset"]) uppercaseString],
                                                    @"type":@"trade"
                                                    };
                            
                            [mutaData addObject:params];
                        }
                        if(locked != 0){
                            NSDictionary *params =@{
                                                    @"count":SAFESTRING(dict[@"locked"]),
                                                    @"kind":[SAFESTRING(dict[@"asset"]) uppercaseString],
                                                    @"type":@"frozon"
                                                    };
                            
                            [mutaData addObject:params];
                        }
                        
                    }
                    [self uploadToServer:mutaData exchangeCode:@"binance"];
                    
                }
            }
        }
    }];
}

+ (void)hbRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret model:(BTExchangeModel*)model{
    NSString *id1 = [AppHelper getAccountId];
    NSString *id2 = [AppHelper getHbApiAccountId];
    if(id1.length > 0 && id2.length > 0){
        [self processMultiHubiTask:model];
        return;
    }
    
    NSString *mId = id1;
    if(mId.length == 0) return;
    [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mId succeed:^(id respondObject) {
        if([respondObject isKindOfClass:[NSDictionary class]]){
            NSArray *list = respondObject[@"list"];
            if(![list isKindOfClass:[NSArray class]]) return;
            if(list.count>0){
                
                // 逻辑处理
                NSMutableArray *mutaData =@[].mutableCopy;
                for(NSDictionary *dict in list){
                    NSString* type = SAFESTRING(dict[@"type"]);
                   // if([type isEqualToString:@"trade"]){
                        double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                        if(count != 0){
                            NSDictionary *params =@{
                                                    @"count":SAFESTRING(dict[@"balance"]),
                                                    @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString],
                                                    @"type":dict[@"type"]
                                                    };
                            
                            [mutaData addObject:params];
                        }
                    //}
                }
                [self uploadToServer:mutaData exchangeCode:@"huobi.pro"];
            }
        }
        
        
    } failed:^(id error) {
        
    }];
}

+ (void)okexRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret model:(BTExchangeModel*)model{
    [OKexRequestApi accountWithApiKey:apiKey apiSecret:apiSecret succeed:^(id respondObject) {
        if(respondObject&&[respondObject isKindOfClass:[NSDictionary class]]){
            id info = respondObject[@"info"];
            if([info isKindOfClass:[NSDictionary class]]){
                id value = info[@"funds"];
                if([value isKindOfClass:[NSDictionary class]]){
                    NSDictionary *free = value[@"free"];
                    NSDictionary *freezed = value[@"freezed"];
                   
                    //数据处理
                    NSMutableArray *dataArr = @[].mutableCopy;
                    for(NSString *key in free.allKeys){
                        
                        double count = [SAFESTRING(free[key]) doubleValue];
                        if(count !=0){
                            NSDictionary *dict= @{
                                                  @"kind":[SAFESTRING(key) uppercaseString],
                                                  @"count":SAFESTRING(free[key]),
                                                  @"type":@"trade"
                                                  };
                            [dataArr addObject:dict];
                        }
                    }
                    for(NSString *key in freezed.allKeys){
                        
                        double count = [SAFESTRING(freezed[key]) doubleValue];
                        if(count !=0){
                            NSDictionary *dict= @{
                                                  @"kind":[SAFESTRING(key) uppercaseString],
                                                  @"count":SAFESTRING(freezed[key]),
                                                  @"type":@"frozon"
                                                  };
                            [dataArr addObject:dict];
                        }
                    }
                    
                    [self uploadToServer:dataArr exchangeCode:@"okex"];
                    
                }
            }
        }
        
        
    } failed:^(id error) {
        
    }];
}

//处理计算后的结果
+ (void)uploadToServer:(NSArray*)data exchangeCode:(NSString*)exchangeCode{
    [AppHelper saveExchangeData:data withExchangeCode:exchangeCode];
    
    NSDictionary *params =@{
                            @"bookkeeptingExchangeCurrencyVOList":data,
                            @"exchange":SAFESTRING(exchangeCode)
                            };
    
    BTUserExchangeAccountApi *api  =[[BTUserExchangeAccountApi alloc] initWithAccountData:@[params]];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self processData:request.data exchangeCode:exchangeCode];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

+ (void)processData:(NSDictionary*)dict exchangeCode:(NSString*)code{
    if(dict&&[dict isKindOfClass:[NSDictionary class]]){
        NSArray *exchangeVOList = dict[@"exchangeVOList"];
        if(exchangeVOList.count>0){
            [AppHelper saveExchangeTotalInfo:exchangeVOList.firstObject withEXCode:code];
        }
    }
}

+ (void)processMultiHubiTask:(BTExchangeModel*)model{
    NSString *mId = [AppHelper getAccountId];
    NSString *mID1 = [AppHelper getHbApiAccountId];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSMutableArray *hb1Arr = @[].mutableCopy;
    __block NSMutableArray *hb2Arr = @[].mutableCopy;
    dispatch_group_async(group, queue, ^{
        [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mId  succeed:^(id respondObject) {
            if([respondObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *data =respondObject[@"data"];
                if(![data isKindOfClass:[NSDictionary class]]) return;
                NSArray *list = data[@"list"];
                if(![list isKindOfClass:[NSArray class]]) return;
                if(list.count>0){
                    // 逻辑处理
                    for(NSDictionary *dict in list){
                        NSString* type = SAFESTRING(dict[@"type"]);
                        //if([type isEqualToString:@"trade"]){
                            
                            double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                            if(count != 0){
                                
                                NSDictionary *params =@{
                                                        @"count":SAFESTRING(dict[@"balance"]),
                                                        @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString],
                                                        @"type":dict[@"type"]
                                                        };
                                
                                [hb1Arr addObject:params];
                            }
                        //}
                    }
                    dispatch_semaphore_signal(semaphore);
                    
                }
            }
        } failed:^(id error) {
            
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mID1  succeed:^(id respondObject) {
            if([respondObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *data =respondObject[@"data"];
                if(![data isKindOfClass:[NSDictionary class]]) return;
                NSArray *list = data[@"list"];
                if(![list isKindOfClass:[NSArray class]]) return;
                if(list.count>0){
                    
                    for(NSDictionary *dict in list){
                        NSString* type = SAFESTRING(dict[@"type"]);
                        //if([type isEqualToString:@"trade"]){
                        
                        double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                        if(count != 0){
                            
                            NSDictionary *params =@{
                                                    @"count":SAFESTRING(dict[@"balance"]),
                                                    @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString],
                                                    @"type":dict[@"type"]
                                                    };
                            
                            
                            [hb2Arr addObject:params];
                        }
                        //}
                    }
                    dispatch_semaphore_signal(semaphore);
                    
                }
            }
        } failed:^(id error) {
            
        }];
        
    });
    
    dispatch_group_notify(group, queue, ^{
        //两个任务
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        //这里就是所有异步任务请求结束后执行的代码
        NSArray * arr =[AppHelper concatFirstArr:hb1Arr secondArray:hb2Arr];
        [self uploadToServer:arr exchangeCode:model.exchangeCode];
        
    });
}

//
+ (void)saveMainIndex:(NSString*)mainIndex{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(mainIndex) forKey:@"mainIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)mainIndex{
    NSString *mainIndex= SAFESTRING([[NSUserDefaults standardUserDefaults] valueForKey:@"mainIndex"]);
    if(mainIndex.length == 0) return @"105";
    return mainIndex;
}

+ (void)saveAccessoryIndex:(NSString*)accessoryIndex{
    [[NSUserDefaults standardUserDefaults] setValue:SAFESTRING(accessoryIndex) forKey:@"accessoryIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)accessoryIndex{
    NSString *accessoryIndex =  SAFESTRING([[NSUserDefaults standardUserDefaults] valueForKey:@"accessoryIndex"]);
    if(accessoryIndex.length == 0) return @"104"; //默认关闭副指标
    
    return accessoryIndex;
    
}


+ (void)requestCurrency{
   CurrencyListRequest*api =   [[CurrencyListRequest alloc] initWithExchangeCode:k_Net_Code];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *mutaArr = @[].mutableCopy;
            for(NSDictionary *dict in request.data){
                NSString *name = SAFESTRING(dict[@"currencySimpleName"]);
                [mutaArr addObject:name];
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:mutaArr forKey:@"currency_types"];
            [userDefaults synchronize];
        }
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
    
}

@end
