//
//  YZMStockSearchService.m
//  YZMicroStock
//
//  Created by wangminhong on 16/4/8.
//  Copyright © 2016年 cqjr. All rights reserved.
//

#import "BTSearchService.h"
//#import "CurrentcyModel+CoreDataClass.h"
//#import "CurrentcyModel+CoreDataProperties.h"
#import "CurrentcyModel.h"
#import "XianHuoSearchObj+CoreDataClass.h"
#import "XianHuoSearchObj+CoreDataProperties.h"
#import <CoreData/CoreData.h>
#import "QueryBtcListRequest.h"
#import "ItemModel.h"
#import "XianHuoSeachAllRequest.h"
#import "XianHuoMainObj.h"
#import "XianHuoModel.h"
#import "QiHuoSeachAllRequest.h"
#import "QiHuoSearchObj+CoreDataClass.h"
#import "QiHuoSearchObj+CoreDataProperties.h"
#import "QihuoModel.h"
#import "KLineHelper.h"
#import "BTRealTimeSeachRequest.h"
#import "BTBZSeachRequset.h"
//static NSString *const sYZMStockListVersionDefault = @"YZMStockListVersionDefault";

#import "BTOptionSearchRequest.h"

#define dataTime @"dataTime"
#define currentcyModePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/currentcyModel.sql"]

@interface BTSearchService()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSDate *versionDate;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) BOOL ready;
@property (nonatomic, strong) NSString *historyCodes;
@property (nonatomic, strong) BTRealTimeSeachRequest *seachApi;

@property (nonatomic, strong) BTOptionSearchRequest *optionSearchApi;

@end

@implementation BTSearchService

@synthesize historyCodes = _historyCodes;

+ (instancetype)sharedService
{
    static BTSearchService *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];;
    });
    
    return sInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.versionDate = [[NSUserDefaults standardUserDefaults] objectForKey:sYZMStockListVersionDefault];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        __weak typeof(&*self) safeSelf = self;
        [self.operationQueue addOperationWithBlock:^{
            [safeSelf managedObjectContext];
            safeSelf.ready = YES;
        }];

        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(noticeForResignActive:) name: UIApplicationWillResignActiveNotification object: nil];
    }
    return self;
}

- (void)noticeForResignActive:(id)notice{
    
    [self saveContext];
}

- (void)checkIfNeedUpdateStocks{
    
//    NSDate *serverdate = [YZMSeverTimeService sharedService].severDate;
//    if (self.versionDate && [self.versionDate isSameDay:serverdate] && (self.versionDate.hour >9 || (self.versionDate.hour ==9 && self.versionDate.minute >= 17))) {
//
//        //同一天，且上次更新时间 大于9点16分，不需要更新
//        return;
//    }
    
    DLog(@"day:%ld",[[NSDate date] day]);
    
    [self.operationQueue addOperationWithBlock:^{
        NSDate *date = [self readDatatime];
        if (date == nil || ([[NSDate date] day] != date.day)) {
              NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:currentcyModePath];
            if (arr == nil) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"json"];
                NSData *data = [[NSData alloc] initWithContentsOfFile:path];
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSMutableArray *arrSearch = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
                    [arrSearch addObject:model];
                }
                
                BOOL save =  [NSKeyedArchiver archiveRootObject:arrSearch toFile:currentcyModePath];
                if (save) {
                    DLog(@"saveSuccess");
                }else{
                    DLog(@"saveFaild");
                }
            }
            
            [self fetchAllStockFromNetwork];
            [self requestXianhuo];
            [self requestQihuo];
        }
        
    }];
}

- (void)fetchAllStockFromNetwork{
    QueryBtcListRequest *btcListRequest = [[QueryBtcListRequest alloc] init];
    [btcListRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSData *data1 = [[NSData alloc] initWithBase64EncodedString:request.data  options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *data2 = [[KLineHelper shareInstance] uncompressZippedData:data1];
        NSArray *arrData = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in arrData) {
            CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
            [array addObject:model];
        }
       BOOL save =  [NSKeyedArchiver archiveRootObject:array toFile:currentcyModePath];
        if (save) {
            DLog(@"saveSuccess");
            [self writeDatatime];
        }else{
            DLog(@"saveFaild");
        }
//        [self updateNativeStoreageWithArray:array];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];

//    [YZClient qt_getAllStocksWithVersion:nil success:^(NSURLResponse *response, id responseObject) {
//
//        YZGeneralResultModel *topModel = responseObject;
//        if (topModel.success) {
//
//            YZMAllStockPacket *packet = topModel.data;
//            __weak typeof(&*self) safeSelf = self;
//            [safeSelf updateNativeStoreageWithArray: packet.stocks];
//            if (packet.versionDate) {
//                [[NSUserDefaults standardUserDefaults] setObject:packet.versionDate forKey:sYZMStockListVersionDefault];
//                safeSelf.versionDate = packet.versionDate;
//            }
//        }
//
//    } failure:nil];
}

- (void)requestQihuo{
    QiHuoSeachAllRequest *qihuoRequest = [[QiHuoSeachAllRequest alloc] init];
    [qihuoRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSMutableArray *arrQihuo = [NSMutableArray array];
        if (![request.data isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in request.data) {
                QihuoModel *qihuoItem  = [QihuoModel modelWithJSON:dic];
                [arrQihuo addObject:qihuoItem];
            }
            [self updateNativeStoreageWithQihuoArray:arrQihuo];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)requestXianhuo{
     XianHuoSeachAllRequest *api = [[XianHuoSeachAllRequest alloc] initWithXianHuoSeachAllRequest];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSMutableArray *arrXianhuo = [NSMutableArray array];
        if (![request.data isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in request.data) {
                XianHuoModel *xianhuoitem  = [XianHuoModel modelWithJSON:dic];
                [arrXianhuo addObject:xianhuoitem];
            }
              [self updateNativeStoreageWithXianhuoArray:arrXianhuo];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)updateNativeStoreageWithQihuoArray: (NSArray *)array
{
    if (array.count == 0) {
        
        return;
    }
    
    for (QihuoModel *item in array) {
        if (item.contractCode.length == 0) {
            continue;
        }
        [self.operationQueue addOperationWithBlock:^{
            QiHuoSearchObj *stockInfo = [self fecthStockWithQihuoStockCode:item.contractCode];
            if (!stockInfo) {
                stockInfo = [NSEntityDescription insertNewObjectForEntityForName:@"QiHuoSearchObj"
                                                          inManagedObjectContext: self.managedObjectContext];
            }
            if (stockInfo) {
                stockInfo.contractCode = item.contractCode;
                stockInfo.futuresId = item.futuresId;
                stockInfo.contractName = item.contractName;
                stockInfo.productCode = item.productCode;
            }
        }];
    }
    [self saveContext];
}

- (void)updateNativeStoreageWithXianhuoArray: (NSArray *)array
{
    if (array.count == 0) {
        
        return;
    }
    
    for (XianHuoModel *item in array) {
        if (@(item.exchangeId).stringValue.length == 0) {
            continue;
        }
        [self.operationQueue addOperationWithBlock:^{
            XianHuoSearchObj *stockInfo = [self fecthStockWithXianhuoStockCode: @(item.exchangeId).stringValue];
            if (!stockInfo) {
                stockInfo = [NSEntityDescription insertNewObjectForEntityForName:@"XianHuoSearchObj"
                                                          inManagedObjectContext: self.managedObjectContext];
            }
            if (stockInfo) {
                if ([item.exchangeCode isEqualToString:@"bitbay"]) {
                    DLog(@"exid:%d",item.exchangeId);
                }
                stockInfo.exchangeName = item.exchangeName;
                stockInfo.exchangeId = item.exchangeId;
                stockInfo.exchangeCode = item.exchangeCode;
                stockInfo.exchangeLabel = item.exchangeLabel;
            }
        }];
    }
    [self saveContext];
}

- (void)updateNativeStoreageWithArray: (NSArray *)array
{
    if (array.count == 0) {
        
        return;
    }
    
    for (ItemModel *item in array) {
        if (item.currencySimpleName.length == 0) {
            continue;
        }
        [self.operationQueue addOperationWithBlock:^{
            CurrentcyModel *stockInfo = [self fecthStockWithStockCode: item.currencySimpleName];
            if (!stockInfo) {
                stockInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentcyModel"
                                                          inManagedObjectContext: self.managedObjectContext];
            }
            if (stockInfo) {
                stockInfo.currencyChineseName = item.currencyChineseName;
                stockInfo.currencyChineseNameRelation = item.currencyChineseNameRelation;
                stockInfo.currencyCode = item.currencyCode;
                stockInfo.currencyCodeRelation = item.currencyCodeRelation;
                stockInfo.currencySimpleName = item.currencySimpleName;
                stockInfo.currencySimpleNameRelation = item.currencySimpleNameRelation;
                stockInfo.currencyEnglishName = item.currencyEnglishName;
                stockInfo.currencyEnglishNameRelation = item.currencyEnglishNameRelation;
            }
        }];
    }
    [self saveContext];
}

- (QiHuoSearchObj *)fecthStockWithQihuoStockCode: (NSString *)stockCode{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"QiHuoSearchObj"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractCode == %@", stockCode];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
    if (results.count == 0) {
        return nil;
    }
    else
    {
        return results[0];
    }
}


- (XianHuoSearchObj *)fecthStockWithXianhuoStockCode: (NSString *)stockCode
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XianHuoSearchObj"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exchangeId == %@", stockCode];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
    if (results.count == 0) {
        return nil;
    }
    else
    {
        return results[0];
    }
}

- (CurrentcyModel *)fecthStockWithStockCode: (NSString *)stockCode
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentcyModel"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currencySimpleName == %@", stockCode];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
    if (results.count == 0) {
        return nil;
    }
    else
    {
        return results[0];
    }
}

- (void)fecthStocksQihuoWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result
{
    if (!self.ready || result == nil) {
        return ;
    }
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"QiHuoSearchObj"];
        request.fetchLimit = 20;
        NSSortDescriptor *sortDesc  = [NSSortDescriptor sortDescriptorWithKey: @"contractCode" ascending: YES];
        request.sortDescriptors = @[sortDesc];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(contractCode CONTAINS[c] %@) OR (contractName CONTAINS[c] %@) OR (productCode CONTAINS[c] %@)", inputStr, inputStr, inputStr];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
        if (results.count == 0) {
            results = nil;
        }
//        NSMutableArray *arrTotal = [NSMutableArray array];
//        NSMutableArray *arrPrefix = [NSMutableArray array];
//        NSMutableArray *arrSuffer = [NSMutableArray array];
//        for (QiHuoSearchObj *model in results) {
//            if ([model.contractCode hasPrefix:inputStr] || [model.contractName hasPrefix:inputStr]) {
//                [arrPrefix addObject:model];
//            }else{
//                [arrSuffer addObject:model];
//            }
//        }
//        [arrTotal addObjectsFromArray:arrPrefix];
//        [arrTotal addObjectsFromArray:arrSuffer];
//        if (arrTotal.count == 0) {
//            arrTotal = nil;
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(results);
        });
    }];
}

- (void)fecthStocksXianhuoWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result
{
    if (!self.ready || result == nil) {
        return ;
    }
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XianHuoSearchObj"];
        request.fetchLimit = 20;
        NSSortDescriptor *sortDesc  = [NSSortDescriptor sortDescriptorWithKey: @"exchangeId" ascending: YES];
        request.sortDescriptors = @[sortDesc];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(exchangeId CONTAINS[c] %@ ) OR (exchangeName CONTAINS[c] %@) OR (exchangeLabel CONTAINS[c] %@)", inputStr, inputStr, inputStr];
        request.predicate = predicate;
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
        if (results.count == 0) {
            results = nil;
        }
        NSMutableArray *arrTotal = [NSMutableArray array];
        NSMutableArray *arrPrefix = [NSMutableArray array];
        NSMutableArray *arrSuffer = [NSMutableArray array];
        for (XianHuoSearchObj *model in results) {
            if ([SAFESTRING(model.exchangeCode) hasPrefix:inputStr] || [SAFESTRING(model.exchangeName) hasPrefix:inputStr]) {
                [arrPrefix addObject:model];
            }else{
                [arrSuffer addObject:model];
            }
        }
        [arrTotal addObjectsFromArray:arrPrefix];
        [arrTotal addObjectsFromArray:arrSuffer];
        if (arrTotal.count == 0) {
            arrTotal = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrTotal);
        });
    }];
}

- (void)fecthStocksWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result
{
    if (!self.ready || result == nil) {
        return ;
    }
    inputStr = inputStr.uppercaseString;
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CurrentcyModel"];
//        request.fetchLimit = 4000;
//        NSSortDescriptor *sortDesc  = [NSSortDescriptor sortDescriptorWithKey: @"currencySimpleName" ascending: YES];
//        request.sortDescriptors = @[sortDesc];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:currentcyModePath];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currencySimpleName CONTAINS[c] %@ OR currencyChineseName CONTAINS[c] %@",inputStr,inputStr];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"currencySimpleName == %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"currencySimpleName == %@ && currencySimpleNameRelation != ''", inputStr];
        
        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"currencySimpleName BEGINSWITH[c] %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"(currencySimpleName BEGINSWITH[c] %@ && currencySimpleNameRelation != '')", inputStr];
        
        NSPredicate *predicate5 = [NSPredicate predicateWithFormat:@"currencySimpleName CONTAINS[c] %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate6 = [NSPredicate predicateWithFormat:@"(currencySimpleName CONTAINS[c] %@ && currencySimpleNameRelation != '')", inputStr];
        
        NSPredicate *predicate7 = [NSPredicate predicateWithFormat:@"currencyChineseName == %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate8 = [NSPredicate predicateWithFormat:@"(currencyChineseName == %@ && currencySimpleNameRelation != '')", inputStr];
        
        NSPredicate *predicate9 = [NSPredicate predicateWithFormat:@"currencyChineseName BEGINSWITH[c] %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate10 = [NSPredicate predicateWithFormat:@"(currencyChineseName BEGINSWITH[c] %@ && currencySimpleNameRelation != '')", inputStr];
        
        NSPredicate *predicate11 = [NSPredicate predicateWithFormat:@"currencyChineseName CONTAINS[c] %@ && currencySimpleNameRelation == ''", inputStr];
        NSPredicate *predicate12 = [NSPredicate predicateWithFormat:@"(currencyChineseName CONTAINS[c] %@ && currencySimpleNameRelation != '')", inputStr];
        NSMutableArray *arrFilterTotal = [NSMutableArray array];
        NSMutableArray *arrFirst = [NSMutableArray array];
        NSMutableArray *arrSecond = [NSMutableArray array];
        NSMutableArray *arrThird = [NSMutableArray array];
        NSMutableArray *arrForth = [NSMutableArray array];
        NSMutableArray *arrFive = [NSMutableArray array];
        NSMutableArray *arrSix = [NSMutableArray array];
        NSMutableArray *arrSeven = [NSMutableArray array];
        NSMutableArray *arrEight = [NSMutableArray array];
        NSMutableArray *arrNi = [NSMutableArray array];
        NSMutableArray *arrTen = [NSMutableArray array];
        NSMutableArray *arrEleven = [NSMutableArray array];
        NSMutableArray *arrTwe = [NSMutableArray array];
        NSMutableArray *arrTotal = [NSMutableArray array];
        for (CurrentcyModel *model in arr) {
            if ([predicate evaluateWithObject:model]) {
                [arrFilterTotal addObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate1 evaluateWithObject:model]) {
                [arrFirst addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate2 evaluateWithObject:model]) {
                [arrSecond addObject:model];
                 [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrFirst) {
            if ([arrSecond containsObject:model]) {
                [arrSecond removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate3 evaluateWithObject:model]) {
                [arrThird addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate4 evaluateWithObject:model]) {
                [arrForth addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrThird) {
            if ([arrForth containsObject:model]) {
                [arrForth removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate5 evaluateWithObject:model]) {
                [arrFive addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate6 evaluateWithObject:model]) {
                [arrSix addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrFive) {
            if ([arrSix containsObject:model]) {
                [arrSix removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate7 evaluateWithObject:model]) {
                [arrSeven addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate8 evaluateWithObject:model]) {
                [arrEight addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrSeven) {
            if ([arrEight containsObject:model]) {
                [arrEight removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate9 evaluateWithObject:model]) {
                [arrNi addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate10 evaluateWithObject:model]) {
                [arrTen addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrNi) {
            if ([arrTen containsObject:model]) {
                [arrTen removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate11 evaluateWithObject:model]) {
                [arrEleven addObject:model];
                [arrFilterTotal removeObject:model];
            }
            if ([predicate12 evaluateWithObject:model]) {
                [arrTwe addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in arrEleven) {
            if ([arrTwe containsObject:model]) {
                [arrTwe removeObject:model];
            }
        }
        
        [arrTotal addObjectsFromArray:arrFirst];
        [arrTotal addObjectsFromArray:arrSecond];
        [arrTotal addObjectsFromArray:arrThird];
        [arrTotal addObjectsFromArray:arrForth];
        [arrTotal addObjectsFromArray:arrFive];
        [arrTotal addObjectsFromArray:arrSix];
        [arrTotal addObjectsFromArray:arrSeven];
        [arrTotal addObjectsFromArray:arrEight];
        [arrTotal addObjectsFromArray:arrNi];
        [arrTotal addObjectsFromArray:arrTen];
        [arrTotal addObjectsFromArray:arrEleven];
        [arrTotal addObjectsFromArray:arrTwe];
        [arrTotal addObjectsFromArray:[arrFilterTotal copy]];
       
//        request.predicate = predicate;
//        NSError *error = nil;
//        NSArray *results = [self.managedObjectContext executeFetchRequest: request error: &error];
        
       
//        NSSet *set = [NSSet setWithArray:arrTotal];
//        NSSortDescriptor *sortDesc  = [NSSortDescriptor sortDescriptorWithKey: @"currencySimpleName" ascending: YES];
//        NSArray *results = [[set allObjects] sortedArrayUsingDescriptors:@[sortDesc]];
//        NSArray *results = [arr filteredArrayUsingPredicate:predicate];
        
        
        if (arrTotal.count == 0) {
            arrTotal = nil;
        }
//        NSMutableArray *arrTotal = [NSMutableArray array];
//        NSMutableArray *arrPrefix = [NSMutableArray array];
//        NSMutableArray *arrSuffer = [NSMutableArray array];
//        for (CurrentcyModel *model in results) {
//            if ([model.currencySimpleName hasPrefix:inputStr]  || [model.currencyChineseName hasPrefix:inputStr]) {
//                [arrPrefix addObject:model];
//            }else{
//                [arrSuffer addObject:model];
//            }
//        }
//        [arrTotal addObjectsFromArray:arrPrefix];
//        [arrTotal addObjectsFromArray:arrSuffer];
//        if (arrTotal.count == 0) {
//            arrTotal = nil;
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrTotal);
        });
    }];
}
- (void)fecthStocksSYTJWithInput:(NSString *)inputStr result:(void (^)(NSArray *))result {
    
    if (!self.ready || result == nil) {
        return ;
    }
    inputStr = inputStr.uppercaseString;
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
       
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:currentcyModePath];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currencySimpleName CONTAINS[c] %@ OR currencyChineseName CONTAINS[c] %@",inputStr,inputStr];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"currencySimpleName == %@ && currencySimpleNameRelation == ''", inputStr];
        
        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"currencySimpleName BEGINSWITH[c] %@ && currencySimpleNameRelation == ''", inputStr];
       
        NSPredicate *predicate5 = [NSPredicate predicateWithFormat:@"currencySimpleName CONTAINS[c] %@ && currencySimpleNameRelation == ''", inputStr];
        
        
        NSPredicate *predicate7 = [NSPredicate predicateWithFormat:@"currencyChineseName == %@ && currencySimpleNameRelation == ''", inputStr];
        
        NSPredicate *predicate9 = [NSPredicate predicateWithFormat:@"currencyChineseName BEGINSWITH[c] %@ && currencySimpleNameRelation == ''", inputStr];
        
        NSPredicate *predicate11 = [NSPredicate predicateWithFormat:@"currencyChineseName CONTAINS[c] %@ && currencySimpleNameRelation == ''", inputStr];
        
        NSMutableArray *arrFilterTotal = [NSMutableArray array];
        NSMutableArray *arrFirst = [NSMutableArray array];
        NSMutableArray *arrThird = [NSMutableArray array];
        NSMutableArray *arrFive = [NSMutableArray array];
        NSMutableArray *arrSeven = [NSMutableArray array];
        NSMutableArray *arrNi = [NSMutableArray array];
        NSMutableArray *arrEleven = [NSMutableArray array];
        NSMutableArray *arrTotal = [NSMutableArray array];
        for (CurrentcyModel *model in arr) {
            if ([predicate evaluateWithObject:model]) {
                [arrFilterTotal addObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate1 evaluateWithObject:model]) {
                [arrFirst addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
       
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate3 evaluateWithObject:model]) {
                [arrThird addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate5 evaluateWithObject:model]) {
                [arrFive addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate7 evaluateWithObject:model]) {
                [arrSeven addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate9 evaluateWithObject:model]) {
                [arrNi addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate11 evaluateWithObject:model]) {
                [arrEleven addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
    
        [arrTotal addObjectsFromArray:arrFirst];
        [arrTotal addObjectsFromArray:arrThird];
        [arrTotal addObjectsFromArray:arrFive];
        [arrTotal addObjectsFromArray:arrSeven];
        [arrTotal addObjectsFromArray:arrNi];
        [arrTotal addObjectsFromArray:arrEleven];
        //[arrTotal addObjectsFromArray:[arrFilterTotal copy]];
       
        if (arrTotal.count == 0) {
            arrTotal = nil;
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrTotal);
        });
    }];
}
-(void)fecthStocksTJJYWithSimpleName:(NSString *)simpleName ChineseName:(NSString *)chineseName result:(void (^)(NSArray *))result {
    
    if (!self.ready || result == nil) {
        return ;
    }
    simpleName = simpleName.uppercaseString;
    chineseName = chineseName.uppercaseString;
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
       
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:currentcyModePath];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currencySimpleName CONTAINS[c] %@ OR currencyChineseName CONTAINS[c] %@",simpleName,chineseName];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"currencySimpleName == %@ && currencySimpleNameRelation != ''", simpleName];
       
        NSPredicate *predicate8 = [NSPredicate predicateWithFormat:@"(currencyChineseName == %@ && currencySimpleNameRelation != '')", chineseName];

        NSMutableArray *arrFilterTotal = [NSMutableArray array];
        NSMutableArray *arrSecond = [NSMutableArray array];
        NSMutableArray *arrForth = [NSMutableArray array];
        NSMutableArray *arrSix = [NSMutableArray array];
        NSMutableArray *arrEight = [NSMutableArray array];
        NSMutableArray *arrTen = [NSMutableArray array];
        NSMutableArray *arrTwe = [NSMutableArray array];
        NSMutableArray *arrTotal = [NSMutableArray array];
        for (CurrentcyModel *model in arr) {
            if ([predicate evaluateWithObject:model]) {
                [arrFilterTotal addObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
           
            if ([predicate2 evaluateWithObject:model]) {
                [arrSecond addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
   

        for (CurrentcyModel *model in [arrFilterTotal copy]) {
           
            if ([predicate8 evaluateWithObject:model]) {
                [arrEight addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        
        [arrTotal addObjectsFromArray:arrSecond];
        [arrTotal addObjectsFromArray:arrForth];
        [arrTotal addObjectsFromArray:arrSix];
        [arrTotal addObjectsFromArray:arrEight];
        [arrTotal addObjectsFromArray:arrTen];
        [arrTotal addObjectsFromArray:arrTwe];
        //[arrTotal addObjectsFromArray:[arrFilterTotal copy]];
        
        if (arrTotal.count == 0) {
            arrTotal = nil;
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrTotal);
        });
    }];
}
-(void)searchJYDWithArray:(NSMutableArray *)arr withInput:(NSString *)inputStr result:(void (^)(NSArray *))result {
    
    if (!self.ready || result == nil) {
        return ;
    }
    inputStr = inputStr.uppercaseString;
    [self.operationQueue cancelAllOperations];
    [self.operationQueue addOperationWithBlock:^{
        
//        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:currentcyModePath];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currencySimpleNameRelation CONTAINS[c] %@ OR currencyChineseNameRelation CONTAINS[c] %@",inputStr,inputStr];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"currencySimpleNameRelation == %@", inputStr];
        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"currencySimpleNameRelation BEGINSWITH[c] %@", inputStr];
        NSPredicate *predicate5 = [NSPredicate predicateWithFormat:@"currencySimpleNameRelation CONTAINS[c] %@", inputStr];
        NSPredicate *predicate7 = [NSPredicate predicateWithFormat:@"currencyChineseNameRelation == %@", inputStr];
        NSPredicate *predicate9 = [NSPredicate predicateWithFormat:@"currencyChineseNameRelation BEGINSWITH[c] %@", inputStr];
        NSPredicate *predicate11 = [NSPredicate predicateWithFormat:@"currencyChineseNameRelation CONTAINS[c] %@", inputStr];
        NSMutableArray *arrFilterTotal = [NSMutableArray array];
        NSMutableArray *arrFirst = [NSMutableArray array];
        NSMutableArray *arrThird = [NSMutableArray array];
        NSMutableArray *arrFive = [NSMutableArray array];
        NSMutableArray *arrSeven = [NSMutableArray array];
        NSMutableArray *arrNi = [NSMutableArray array];
        NSMutableArray *arrEleven = [NSMutableArray array];
        NSMutableArray *arrTotal = [NSMutableArray array];
        for (CurrentcyModel *model in arr) {
            if ([predicate evaluateWithObject:model]) {
                [arrFilterTotal addObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate1 evaluateWithObject:model]) {
                [arrFirst addObject:model];
                [arrFilterTotal removeObject:model];
            }
           
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate3 evaluateWithObject:model]) {
                [arrThird addObject:model];
                [arrFilterTotal removeObject:model];
            }
          }
   
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate5 evaluateWithObject:model]) {
                [arrFive addObject:model];
                [arrFilterTotal removeObject:model];
            }
          }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate7 evaluateWithObject:model]) {
                [arrSeven addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }
        
        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate9 evaluateWithObject:model]) {
                [arrNi addObject:model];
                [arrFilterTotal removeObject:model];
            }
        }

        for (CurrentcyModel *model in [arrFilterTotal copy]) {
            if ([predicate11 evaluateWithObject:model]) {
                [arrEleven addObject:model];
                [arrFilterTotal removeObject:model];
            }

        }

        [arrTotal addObjectsFromArray:arrFirst];
        [arrTotal addObjectsFromArray:arrThird];
        [arrTotal addObjectsFromArray:arrFive];
        [arrTotal addObjectsFromArray:arrSeven];
        [arrTotal addObjectsFromArray:arrNi];
        [arrTotal addObjectsFromArray:arrEleven];
        [arrTotal addObjectsFromArray:[arrFilterTotal copy]];
        
        if (arrTotal.count == 0) {
            arrTotal = nil;
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrTotal);
        });
    }];
    
}
- (BOOL)isChineseWithInputStr:(NSString *)str{
    if (str.length == 0) {
        str = @"";
    }
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ matches %@", str,match];
    return [predicate evaluateWithObject:self];
}

#define sYZMHISTORYLIMIT 10

- (void)appendHistoryWithCode: (NSString *)code
{
    if (code.length == 0) {
        return;
    }
    NSMutableArray *array = [self.historyCodes componentsSeparatedByString: @","].mutableCopy;
    if (array == nil) {
        array = @[].mutableCopy;
    }
    NSInteger found = [array indexOfObject: code];
    if (found != NSNotFound) {
        [array removeObjectAtIndex: found];
    }
    [array insertObject: code atIndex: 0];
    //limit
    if (array.count > sYZMHISTORYLIMIT) {
        [array removeObjectsInRange: NSMakeRange(sYZMHISTORYLIMIT, array.count-sYZMHISTORYLIMIT)];
    }
    NSString *result = [array componentsJoinedByString:@","];
    self.historyCodes = result;
}

- (void)fecthHistoryResult:(void (^)(NSArray *))result
{
    if (!self.ready || result == nil) {
        return;
    }
    [self.operationQueue addOperationWithBlock:^{
        
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *array = [self.historyCodes componentsSeparatedByString: @","];
        for (NSString *str in  array) {
            if (str.length > 0) {
                CurrentcyModel *stock = [self fecthStockWithStockCode: str];
                if (stock) {
                    [tempArray addObject: stock];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(tempArray);
        });
    }];
}

- (void)clearHistory{
    self.historyCodes = nil;
}
-(void)realTimeWithInput:(NSString *)inputStr pageIndex:(NSInteger)pageIndex result:(void (^)(NSArray *))result {
    
    if (_seachApi) {
        
        [_seachApi stop];
    }
    _seachApi = [[BTRealTimeSeachRequest alloc] initWithInput:inputStr pageIndex:pageIndex];
    
    [_seachApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in request.data) {
            CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
            [array addObject:model];
        }
        if (array.count == 0) {
            array = nil;
        }
        result(array);
    } failure:^(__kindof BTBaseRequest *request) {
        result(nil);
    }];
}

//自选搜索
- (void)optionSearchWithInput:(NSString *)inputStr pageIndex:(NSInteger)pageIndex  result: (void (^)(NSArray *))result{
    if (_optionSearchApi) {
        
        [_optionSearchApi stop];
    }
    _optionSearchApi = [[BTOptionSearchRequest alloc] initWithInput:inputStr pageIndex:pageIndex];
    
    [_optionSearchApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in request.data) {
            CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
            [array addObject:model];
        }
        if (array.count == 0) {
            array = nil;
        }
        result(array);
    } failure:^(__kindof BTBaseRequest *request) {
        result(nil);
    }];
    
    
}

- (void)BZ_RealTimeWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result {
    if (_bzSeachApi) {
        [_bzSeachApi stop];
    }
    _bzSeachApi = [[BTBZSeachRequset alloc] initWithInput:inputStr];
    [_bzSeachApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in request.data) {
            CurrentcyModel *model = [CurrentcyModel modelWithJSON:dic];
            [array addObject:model];
        }
        if (array.count == 0) {
            array = nil;
        }
        result(array);
    } failure:^(__kindof BTBaseRequest *request) {
        result(nil);
    }];
}
#pragma mark -- override

#define sYZMStockSearchHistoryDefault @"YZMStockSearchHistoryDefault"

- (NSString *)historyCodes
{
    if (_historyCodes == nil) {
        _historyCodes = [[NSUserDefaults standardUserDefaults] objectForKey: sYZMStockSearchHistoryDefault];
    }
    return _historyCodes;
}

- (void)setHistoryCodes:(NSString *)historyCodes
{
    if (_historyCodes != historyCodes) {
        _historyCodes = historyCodes;
        if (_historyCodes == nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: sYZMStockSearchHistoryDefault];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject: _historyCodes forKey: sYZMStockSearchHistoryDefault];
        }
    }
}


#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CurrentcyInfo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CurrentcyInfo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    [self.operationQueue addOperationWithBlock:^{
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }];
}

- (void)writeDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate date] forKey:dataTime];
}

- (NSDate *)readDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:dataTime];
}

- (void)writeHistorySearch:(NSString *)str{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readHistorySearch] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }

    for (NSString *string in array) {
        if ([string isEqualToString:str]) {
            [array removeObject:str];
            [array insertObject:str atIndex:0];
            NSArray *saveArray = [NSArray arrayWithArray:array];
            [userDefault setObject:saveArray forKey:lang_SearchHistory];
            return;
        }
    }
     [array insertObject:str atIndex:0];
     NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:lang_SearchHistory];
}

- (NSArray *)readHistorySearch{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:lang_SearchHistory];
}

- (void)writeHistoryXianhuoSearch:(NSString *)str{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readHistoryXianhuoSearch] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    //    if ([array containsObject:str]) {
    //        return;
    //    }
    for (NSString *string in array) {
        if ([string isEqualToString:str]) {
            return;
        }
    }
    [array insertObject:str atIndex:0];
    NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:lang_SearchXianhuoHistory];
}

- (NSArray *)readHistoryXianhuoSearch{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:lang_SearchXianhuoHistory];
}

- (void)writeHistoryQihuoSearch:(NSString *)str{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readHistoryQihuoSearch] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    //    if ([array containsObject:str]) {
    //        return;
    //    }
    for (NSString *string in array) {
        if ([string isEqualToString:str]) {
            return;
        }
    }
    [array insertObject:str atIndex:0];
    NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:lang_SearchQihuoHistory];
}

- (NSArray *)readHistoryQihuoSearch{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:lang_SearchQihuoHistory];
}

- (void)writeHistorySYTJSearch:(NSString *)str {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readHistorySYTJSearch] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    
    for (NSString *string in array) {
        if ([string isEqualToString:str]) {
            return;
        }
    }
    [array insertObject:str atIndex:0];
    NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:lang_SearchSYTJHistory];
}

- (NSArray *)readHistorySYTJSearch {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:lang_SearchSYTJHistory];
}
- (void)clearSearchHistory{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *arr = @[];
    [userDefault setObject:arr forKey:lang_SearchHistory];
}

- (void)clearSearchXianhuoHistory{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *arr = @[];
    [userDefault setObject:arr forKey:lang_SearchXianhuoHistory];
}

- (void)clearSearchQihuoHistory{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *arr = @[];
    [userDefault setObject:arr forKey:lang_SearchQihuoHistory];
}

- (void)clearSearchSYTJHistory {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *arr = @[];
    [userDefault setObject:arr forKey:lang_SearchSYTJHistory];
}

- (void)writeUserOption:(NSArray *)array{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:lang_UserOption];
}

- (NSArray *)readUserOption{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:lang_UserOption];
}
-(void)writeExchangeAuthorized:(BTExchangeModel *)model {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readExchangeAuthorized] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    BOOL isExist = NO;
    for (int i = 0; i < array.count; i++) {
        
        BTExchangeModel *exModel = array[i];
        if (ISStringEqualToString(exModel.exchangeName, model.exchangeName)&&ISStringEqualToString(exModel.userId, model.userId)) {
            isExist = YES;
            
            [array replaceObjectAtIndex:i withObject:[NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil]];
        }else {
            
            [array replaceObjectAtIndex:i withObject:[NSJSONSerialization JSONObjectWithData:exModel.modelToJSONData options:NSJSONReadingMutableContainers error:nil]];
        }
    }
    if(!isExist){
        [array insertObject:[NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil] atIndex:0];
    }
    
    NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:BTExchangeAuthorized];
}
-(NSArray *)readExchangeAuthorized {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefault objectForKey:BTExchangeAuthorized];
    NSMutableArray *modelArray= [[NSArray array] mutableCopy];
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dict = array[i];
        BTExchangeModel *model = [BTExchangeModel objectWithDictionary:dict];
        [modelArray addObject:model];
    }
    return [NSArray arrayWithArray:modelArray];
}

- (NSArray*)readExchangeAuthorizedWithUserId:(NSString*)userId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefault objectForKey:BTExchangeAuthorized];
    NSMutableArray *modelArray= [[NSArray array] mutableCopy];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        BTExchangeModel *model = [BTExchangeModel objectWithDictionary:dict];
        if([userId isEqualToString:model.userId]){
            [modelArray addObject:model];
        }
        
    }
    
    return [NSArray arrayWithArray:modelArray];
}

-(BOOL)readExchangeAuthorizedWithExchangeName:(NSString *)exchangeName userId:(NSString *)userId{
    
    NSArray *array = [self readExchangeAuthorized];
    for (int i = 0; i < array.count; i++) {
        
        BTExchangeModel *exModel = array[i];
        if (ISStringEqualToString(exModel.exchangeName, exchangeName)&&ISStringEqualToString(exModel.userId, userId)) {
            
            return YES;
        }
    }
    
    return NO;
}
-(BTExchangeModel *)readExchangeAuthorizedBackWithExchangeName:(NSString *)exchangeName {
    
    NSArray *array = [self readExchangeAuthorized];
    for (int i = 0; i < array.count; i++) {
        
        BTExchangeModel *exModel = array[i];
        if (ISStringEqualToString(exModel.exchangeName, exchangeName)) {
            
            return exModel;
        }
    }
    
    return nil;
}
-(void)clearExchangeAuthorized {
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSArray *arr = @[];
//    [userDefault setObject:arr forKey:BTExchangeAuthorized];
}
-(void)writeBTSplashScreenModel:(BTSplashScreenModel *)model {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (!model) {
        return;
    }
    [userDefault setObject:[NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil] forKey:BTSplashScreenInfo];
    [userDefault synchronize];
}
-(BTSplashScreenModel *)readBTSplashScreenModel {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    BTSplashScreenModel *model = [BTSplashScreenModel objectWithDictionary:[userDefault objectForKey:BTSplashScreenInfo]];
   
    if (!model) {
        
        return nil;
    }
    return model;
}
-(void)clearBTSplashScreenModel {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:BTSplashScreenInfo];
    [userDefault synchronize];
}
- (void)writeBTSplashScreenDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate date] forKey:BTSplashScreenDatatime];
}

- (NSDate *)readBTSplashScreenDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:BTSplashScreenDatatime];
}
- (void)clearBTSplashScreenDatatime {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:BTSplashScreenDatatime];
}


-(void)writeSheQuHistoryRead:(FastInfomationObj *)model {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[self readSheQuHistoryRead] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    BOOL isExist = NO;
    for (int i = 0; i < array.count; i++) {
        
        FastInfomationObj *exModel = array[i];
        if ((exModel.infoID.integerValue == model.infoID.integerValue) && (exModel.type == model.type)) {
            isExist = YES;
            
            [array replaceObjectAtIndex:i withObject:[NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil]];
        }else {
            
            [array replaceObjectAtIndex:i withObject:[NSJSONSerialization JSONObjectWithData:exModel.modelToJSONData options:NSJSONReadingMutableContainers error:nil]];
        }
    }
    if(!isExist){
        [array insertObject:[NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil] atIndex:0];
    }
    
    NSArray *saveArray = [NSArray arrayWithArray:array];
    [userDefault setObject:saveArray forKey:SheQuHistoryRead];
}
-(NSArray *)readSheQuHistoryRead {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefault objectForKey:SheQuHistoryRead];
    NSMutableArray *modelArray= [[NSArray array] mutableCopy];
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dict = array[i];
        FastInfomationObj *model = [FastInfomationObj objectWithDictionary:dict];
        model.infoID = dict[@"infoID"];
        [modelArray addObject:model];
    }
    return [NSArray arrayWithArray:modelArray];
}
-(BOOL)readSheQuHistoryReadWithInfoID:(NSString *)infoID type:(NSInteger)type{
    
    NSArray *array = [self readSheQuHistoryRead];
    for (int i = 0; i < array.count; i++) {
        
        FastInfomationObj *exModel = array[i];
        if ((exModel.infoID.integerValue == infoID.integerValue) && (exModel.type == type)) {
            
            return YES;
        }
    }
    
    return NO;
}
-(void)clearSheQuHistoryRead {
    
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *arr = @[];
        [userDefault setObject:arr forKey:SheQuHistoryRead];
}
@end
