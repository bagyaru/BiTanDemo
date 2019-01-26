//
//  DetailHelper.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DetailHelper.h"
#import "BTJianjieModel.h"
#import "YKLineEntity.h"

@implementation DetailHelper

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (SAFESTRING(jsonString).length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    if(dic.count == 0) return nil;
    return dic;
}

+ (NSArray*)baseInfoWithModel:(IntroduceModel*)model{
    NSMutableArray *_introduceArr = @[].mutableCopy;
    //处理数据
    NSArray *nameArr =@[
                        @"faxingshijian",
                        @"faxingjiage",
                        @"faxingzhangdie",
                        @"bankuaigainian",
                        @"hexinsuanfa",
                        @"leixing",
                        @"gongshijizhi",
                        @"xiangmuqidongriqi"
                        ];
    NSDictionary *dict = model.baseInfoObj;//[self dictionaryWithJsonString:model.baseInfo];
    if(dict ==nil ||dict.count == 0) return @[];
    
    NSString *returnsStr;
    NSMutableArray *muta = @[].mutableCopy;
    NSDictionary *returns = model.baseInfoObj[@"returns"];
    if(returns.count == 0){
        returnsStr = @"";
    }else{
        NSDictionary *dict = @{@"usd":[APPLanguageService sjhSearchContentWith:@"fabijijia"],@"btc":[APPLanguageService sjhSearchContentWith:@"btcjijia"],@"eth":[APPLanguageService sjhSearchContentWith:@"ethjijia"]};
        
        NSArray *afterSortKeyArray = [returns.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  obj1, NSString* obj2) {
            NSComparisonResult resuest = [obj1 compare:obj2];
            return resuest;
        }];
        
        for(NSString *key in afterSortKeyArray){
            NSString *content = [NSString stringWithFormat:@"%@%@",returns[key],dict[key]];
            [muta addObject:content];
        }
        returnsStr = [muta componentsJoinedByString:@"\n"];
    }
    
    
    NSArray *contentArr = @[SAFESTRING(dict[@"Issuetime"]),SAFESTRING(dict[@"Issueprice"]),SAFESTRING(returnsStr),SAFESTRING(dict[@"RelevantIdea"]),SAFESTRING(dict[@"CoinAlgorithm"]),SAFESTRING(dict[@"type"]),SAFESTRING(dict[@"mechanism"]),SAFESTRING(dict[@"projecttime"])];
    for(NSUInteger i =0; i<nameArr.count;i++){
        BTJianjieModel *model = [[BTJianjieModel alloc] init];
        model.name = nameArr[i];
        model.content = contentArr[i];
        if(SAFESTRING(model.content).length ==0){
            model.content =@"--";
        }
        [_introduceArr addObject:model];
    }
    return _introduceArr;
}

+ (NSArray*)privateInfoWithModel:(IntroduceModel*)model{
    NSMutableArray *_introduceArr = @[].mutableCopy;
    //处理数据
    
    NSArray *nameArr =@[
                        @"privateTime",
                        @"zongchoujiage",
                        @"mujizijin",
                        @"icozongliang",
                        @"daibifenpei",
                        ];
    
   
    NSDictionary *dict = model.privateInfoObj;//[self dictionaryWithJsonString:model.privateInfo];
    NSString *tokensStr =@"";
    NSArray *tokens = dict[@"Tokens"];
    if(tokens.count == 0){
        tokensStr = @"";
    }else{
        NSMutableArray *mutaArr = @[].mutableCopy;
        for(NSDictionary *info in tokens){
            NSString *str = [NSString stringWithFormat:@"%@%@%%",SAFESTRING(info[@"ico"]),SAFESTRING(info[@"foundation"])];
            [mutaArr addObject:str];
        }
        tokensStr = [mutaArr componentsJoinedByString:@","];
    }
    if(dict ==nil ||dict.count == 0) return @[];
    NSArray *contentArr = @[SAFESTRING(dict[@"RecruitTime"]),SAFESTRING(dict[@"RecruitPrice"]),SAFESTRING(dict[@"Recruittotal"]),SAFESTRING(dict[@"ICOtotal"]),SAFESTRING(tokensStr)];
    for(NSUInteger i =0; i<nameArr.count;i++){
        BTJianjieModel *model = [[BTJianjieModel alloc] init];
        model.name = nameArr[i];
        model.content = contentArr[i];
       
        if([model.name isEqualToString:@"daibifenpei"]){
            if(SAFESTRING(model.content).length ==0){
                
            }else{
                [_introduceArr addObject:model];
            }
        }else{
            //排除为空的数据
            if(SAFESTRING(model.content).length ==0){
                model.content =@"--";
            }
            [_introduceArr addObject:model];
        }
       
    }
    return _introduceArr;
}

+ (NSArray*)teamInfoWithModel:(IntroduceModel*)model{
    NSMutableArray *_introduceArr = @[].mutableCopy;
    //处理数据
    
    NSArray *arr = model.teamInfoObj;
    if(arr.count == 0) return @[];
    
//    BTJianjieModel *headerModel = [[BTJianjieModel alloc] init];
//    headerModel.name = @"xingmingmingcheng";
//    headerModel.content = [APPLanguageService sjhSearchContentWith:@"zhiwei"];
//    [_introduceArr addObject:headerModel];
    
    for(NSUInteger i =0; i<arr.count;i++){
        NSDictionary *dict = arr[i];
        BTJianjieModel *model = [[BTJianjieModel alloc] init];
        model.name = SAFESTRING(dict[@"name"]);
        model.content = SAFESTRING(dict[@"job"]);
        model.isNoEn = YES;
        //排除为空的数据
        if(SAFESTRING(model.content).length ==0){
            model.content =@"--";
        }
        [_introduceArr addObject:model];
    }
    return _introduceArr;
}
+ (NSArray*)githubInfoWithModel:(IntroduceModel*)model{
    NSMutableArray *_introduceArr = @[].mutableCopy;
    //处理数据
    NSArray *nameArr =@[
                        @"gengxinshijian",
                        @"zongtijiao",
                        @"gongxianzhe",
                        @"fensishu",
                        @"guanzhushu",
                        ];
    NSDictionary *dict = model.gitHubInfoObj; //[self dictionaryWithJsonString:model.gitHubInfo];
    if(dict ==nil ||dict.count == 0 ) return @[];
    NSArray *contentArr = @[SAFESTRING(dict[@"updatatime"]),SAFESTRING(dict[@"commitnum"]),SAFESTRING(dict[@"cntributors"]),SAFESTRING(dict[@"star"]),SAFESTRING(dict[@"watch"])];
    for(NSUInteger i =0; i<nameArr.count;i++){
        BTJianjieModel *model = [[BTJianjieModel alloc] init];
        model.name = nameArr[i];
        model.content = contentArr[i];
        if(SAFESTRING(model.content).length ==0){
            model.content =@"--";
        }
        [_introduceArr addObject:model];
    }
    return _introduceArr;
}

//
+ (NSArray*)introduceArrWithModel:(IntroduceModel *)model{
    IntroduceModel *_introduceModel = model;
    NSMutableArray *_introduceArr = @[].mutableCopy;
    NSString *shizhiValue =  @"";
    NSString *liutongValue = @"";
    if (kIsCNY) {
        if (model.costRmb > 0) {
            
            if (model.costRmb >= YI) {
                shizhiValue = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                shizhiValue  = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        }
    }else{
        if (model.costDollar > 0) {
            
            if (model.costDollar >= YI) {
                shizhiValue = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                shizhiValue  = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        }
    }
    
    if (model.currencyAmount > 0) {
        
        if (model.currencyAmount >= YI) {
            liutongValue = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
        }else {
            liutongValue  = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
        }
    }
    //rate
    NSString * shizhiRate = SAFESTRING(model.costRate);
    
    //    if(![SAFESTRING(model.costRate) isEqualToString:@"0"]){
    //        shizhiRate = [NSString stringWithFormat:@"%@",model.costRate];
    //    }
    NSString *liutongRate = SAFESTRING(model.floatRate);
    NSString *changeRate = SAFESTRING(model.changeRate);
    
    //    if(![SAFESTRING(model.floatRate) isEqualToString:@"0"]){
    //        liutongRate = [NSString stringWithFormat:@"%@",model.floatRate];
    //    }
    //
    //    if(![SAFESTRING(model.changeRate) isEqualToString:@"0"]){
    //        changeRate = [NSString stringWithFormat:@"%@",model.changeRate];
    //    }
    //
    NSString *refWebsite = @"";
    if(model.webInfo.count>0){
        refWebsite = @"bitan";
    }
    
    //处理数据
    NSArray *nameArr =@[@"concept",@"",@"paiming",
                        @"shizhi",
                        @"quanqiuzongshizhizhanbi",
                        @"liutongliang",
                        @"liutonglv",
                        @"huanshoulv",
                        @"zongliang",
                        @"zuidaliang",
                        @"shangjiajiaoyisuoshuliang",
                        @"zhichiqianbao",
//                        @"mujichengben",
//                        @"mujishijian",
//                        @"mujizijinliang",
//                        @"yingding",
//                        @"duihuanbili",
//                        @"daibifenpei",
//                        @"zijinshiyong",
                        @"xiangguanwangzhan",
//                        @"tuanduijieshao",
//                        @"xiangmuguwen"
                        ];
    
    NSString *name =[NSString stringWithFormat:@"%@,%@（%@）",SAFESTRING(_introduceModel.currencyChineseName),SAFESTRING(_introduceModel.currencyEnglishName),SAFESTRING(_introduceModel.currencySimpleName)];
    
    //    NSArray *contentArr = @[name,SAFESTRING(model.abstractValue),SAFESTRING(@(model.ranking)),SAFESTRING(shizhiValue),SAFESTRING(shizhiRate),SAFESTRING(liutongValue),SAFESTRING(liutongRate),SAFESTRING(changeRate),SAFESTRING(model.totalAmount),SAFESTRING(model.maxAmount),SAFESTRING(@(model.exchangeAmount)),SAFESTRING(model.supportWallet),SAFESTRING(model.icoCost),SAFESTRING(model.icoTime),SAFESTRING(model.collectFundAmount),SAFESTRING(model.hardTop),SAFESTRING(model.convertRate),SAFESTRING(model.coinDistribute),SAFESTRING(model.fundUse),SAFESTRING(refWebsite),SAFESTRING(model.teamIntro),SAFESTRING(model.counselor)];
    NSArray *contentArr = @[name,SAFESTRING(model.abstractValue),SAFESTRING(@(model.ranking)),SAFESTRING(shizhiValue),SAFESTRING(shizhiRate),SAFESTRING(liutongValue),SAFESTRING(liutongRate),SAFESTRING(changeRate),SAFESTRING(model.totalAmount),SAFESTRING(model.maxAmount),SAFESTRING(@(model.exchangeAmount)),SAFESTRING(model.supportWallet),SAFESTRING(refWebsite)];
    for(NSUInteger i =0; i<nameArr.count;i++){
        BTJianjieModel *model = [[BTJianjieModel alloc] init];
        model.name = nameArr[i];
        model.content = contentArr[i];
        if([model.name isEqualToString:@"concept"]){
            NSDictionary *dict = _introduceModel.conceptInfo;
            if(dict.allKeys.count>0){
                NSString *key = [dict.allKeys firstObject];
                model.detailName = SAFESTRING(dict[key]);
            }
            
        }
        //排除为空的数据 //&&![SAFESTRING(model.content) isEqualToString:@"0"]
        if(SAFESTRING(model.content).length == 0 ||[SAFESTRING(model.content) isEqualToString:@"0"]){
            model.content = @"--";
        }
        model.content = [model.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if([model.name isEqualToString:@"xiangguanwangzhan"]){
            if(_introduceModel.webInfo.count == 0){
                
            }else{
                [_introduceArr addObject:model];
            }
        }else{
            [_introduceArr addObject:model];
        }
        
    }
    
    return _introduceArr;
    
}


//+ (NSArray*)introduceArrWithModel:(IntroduceModel *)model{
//    IntroduceModel *_introduceModel = model;
//    NSMutableArray *_introduceArr = @[].mutableCopy;
//    NSString *shizhiValue =  @"";
//    NSString *liutongValue = @"";
//    if (kIsCNY) {
//        if (model.costRmb > 0) {
//
//            if (model.costRmb >= YI) {
//                shizhiValue = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
//
//            }else {
//
//                shizhiValue  = [NSString stringWithFormat:@"¥%.2f%@",model.costRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
//            }
//        }
//    }else{
//        if (model.costDollar > 0) {
//
//            if (model.costDollar >= YI) {
//                shizhiValue = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
//
//            }else {
//
//                shizhiValue  = [NSString stringWithFormat:@"$%.2f%@",model.costDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
//            }
//
//        }
//    }
//
//    if (model.currencyAmount > 0) {
//
//        if (model.currencyAmount >= YI) {
//            liutongValue = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
//        }else {
//            liutongValue  = [NSString stringWithFormat:@"%.2f%@个",model.currencyAmount/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
//        }
//    }
//    //rate
//    NSString * shizhiRate = @"";
//    if(![SAFESTRING(model.costRate) isEqualToString:@"0"]){
//        shizhiRate = [NSString stringWithFormat:@"%@",model.costRate];
//    }
//
//    NSString *liutongRate = @"";
//    NSString *changeRate = @"";
//    if(![SAFESTRING(model.floatRate) isEqualToString:@"0"]){
//        liutongRate = [NSString stringWithFormat:@"%@",model.floatRate];
//    }
//
//    if(![SAFESTRING(model.changeRate) isEqualToString:@"0"]){
//        changeRate = [NSString stringWithFormat:@"%@",model.changeRate];
//    }
//
//    NSString *refWebsite = @"";
//    if(model.webInfo.count>0){
//        refWebsite = @"bitan";
//    }
//
//    //处理数据
//    NSArray *nameArr =@[@"concept",@"",
//                        @"zhichiqianbao",
//                        @"xiangguanwangzhan"
//                       ];
//
//    //@"paiming",
////    @"shizhi",
////    @"quanqiuzongshizhizhanbi",
////    @"liutongliang",
////    @"liutonglv",
////    @"huanshoulv",
////    @"zongliang",
////    @"zuidaliang",
////    @"shangjiajiaoyisuoshuliang",
//    /*
//     @"mujichengben",
//     @"mujishijian",
//     @"mujizijinliang",
//     @"yingding",
//     @"duihuanbili",
//     @"daibifenpei",
//     @"zijinshiyong",
//     @"tuanduijieshao",
//     @"xiangmuguwen"
//     */
//    NSString *name =[NSString stringWithFormat:@"%@,%@（%@）",SAFESTRING(_introduceModel.currencyChineseName),SAFESTRING(_introduceModel.currencyEnglishName),SAFESTRING(_introduceModel.currencySimpleName)];
//
//    NSArray *contentArr = @[name,SAFESTRING(model.abstractValue),SAFESTRING(model.supportWallet),SAFESTRING(refWebsite)];
//    for(NSUInteger i =0; i<nameArr.count;i++){
//        BTJianjieModel *model = [[BTJianjieModel alloc] init];
//        model.name = nameArr[i];
//        model.content = contentArr[i];
//        if([model.name isEqualToString:@"concept"]){
//            NSDictionary *dict = _introduceModel.conceptInfo;
//            if(dict.allKeys.count>0){
//                NSString *key = [dict.allKeys firstObject];
//                model.detailName = SAFESTRING(dict[key]);
//            }
//        }
//        //排除为空的数据
//        if(SAFESTRING(model.content).length>0&&![SAFESTRING(model.content) isEqualToString:@"0"] ){
//            [_introduceArr addObject:model];
//        }
//    }
//
//    return _introduceArr;
//
//}

+ (NSArray*)fenshiSelectArr{
    //@{@"name":@"4h",@"tag":@"7",@"point":@"More_4h"}
    NSArray* arr = @[@{@"name":@"fenshi",@"tag":@"0",@"point":@"detail_table_time"},@{@"name":@"1fen",@"tag":@"1",@"point":@"More_1min"},@{@"name":@"5fen",@"tag":@"2",@"point":@"More_5min"},@{@"name":@"30fen",@"tag":@"4",@"point":@"More_30min"},@{@"name":@"2h",@"tag":@"6",@"point":@"More_2h"},@{@"name":@"6h",@"tag":@"8",@"point":@"More_6h"},@{@"name":@"12h",@"tag":@"9",@"point":@"More_12h"},@{@"name":@"3d",@"tag":@"13",@"point":@"3days"},@{@"name":@"zhouxian",@"tag":@"11",@"point":@"detail_table_week"},@{@"name":@"yuexian",@"tag":@"12",@"point":@"detail_table_month"},@{@"name":@"jixian",@"tag":@"14",@"point":@"3months"},@{@"name":@"nianxian",@"tag":@"15",@"point":@"1year"}];
    return arr;
}
+ (NSArray *)BTBitaneIndexFenshiSelectArr {
    
    NSArray* arr = @[@{@"name":@"fenshi",@"tag":@"0",@"point":@"detail_table_time"},@{@"name":@"1fen",@"tag":@"1",@"point":@"More_1min"},@{@"name":@"5fen",@"tag":@"2",@"point":@"More_5min"},@{@"name":@"30fen",@"tag":@"4",@"point":@"More_30min"},@{@"name":@"2h",@"tag":@"6",@"point":@"More_2h"},@{@"name":@"4h",@"tag":@"7",@"point":@"More_4h"},@{@"name":@"6h",@"tag":@"8",@"point":@"More_6h"},@{@"name":@"12h",@"tag":@"9",@"point":@"More_12h"}];
    return arr;
}
//主指标
+ (NSArray*)mainIndexArr{
    NSArray* arr = @[@{@"name":@"MA",@"tag":@"105",@"point":@"MA"},@{@"name":@"EMA",@"tag":@"106",@"point":@"EMA"},@{@"name":@"BOLL",@"tag":@"107",@"point":@"BOLL"},@{@"name":@"guanbi",@"tag":@"108",@"point":@"close"},@{@"name":@"MACD",@"tag":@"100",@"point":@"MACD"},@{@"name":@"KDJ",@"tag":@"101",@"point":@"KDJ"},@{@"name":@"RSI",@"tag":@"102",@"point":@"RSI"},@{@"name":@"NetFlow",@"tag":@"103",@"point":@"capital_flow"},@{@"name":@"guanbi",@"tag":@"104",@"point":@"None"}];
    return arr;
}

//异常情况处理
+ (NSString*)processData:(NSString *)originStr{
    if(SAFESTRING(originStr).length ==0 ||[SAFESTRING(originStr) isEqualToString:@"0"]){
        return @"--";
    }
    return SAFESTRING(originStr);
}

+ (NSArray*)updateFromItem:(FenshiModel *)item arr:(NSArray*)klineArr{
    NSMutableArray *arr = [klineArr mutableCopy];
    if (arr == nil) {
        return @[];
    }
    YKLineEntity *lastPreItem = [arr lastObject];
    BOOL isSame = NO;
    NSString *strLastPri =  [[NSDate dateWithTimeIntervalSince1970:lastPreItem.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    NSString *strItem = [[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    if ([strLastPri isEqualToString:strItem]) {
        isSame = YES;
    }
    if (lastPreItem.time < item.time) {
        YKLineEntity *entity = [[YKLineEntity alloc] init];
        entity.close = item.price;
        entity.date = [[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"HH:mm"];
        entity.volume = item.volum -lastPreItem.volume;
        if(entity.volume <0){
            entity.volume = ABS(entity.volume);
        }
        entity.time = item.time;
        entity.open = lastPreItem.close;
        entity.high = item.maxPrice;
        entity.low = item.minPrice;
        
        if (isSame) {
            [arr replaceObjectAtIndex:arr.count -1 withObject:entity];
        }else{
            [arr addObject:entity];
        }
    }
    return arr;
}


+ (NSArray*)updateItem:(FenshiModel *)item arr:(NSArray*)klineArr{
    NSMutableArray *arr = [klineArr mutableCopy];
    if (arr == nil) {
        return @[];
    }
    YKLineEntity *lastPreItem = [arr lastObject];
    BOOL isSame = NO;
    NSString *strLastPri =  [[NSDate dateWithTimeIntervalSince1970:lastPreItem.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    NSString *strItem = [[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    if ([strLastPri isEqualToString:strItem]) {
        isSame = YES;
    }
    if (lastPreItem.time < item.time) {
        YKLineEntity *entity = [[YKLineEntity alloc] init];
        entity.close = item.price;
        entity.date = [[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"HH:mm"];
        entity.volume = 0;
        if(entity.volume <0){
            entity.volume = ABS(entity.volume);
        }
        entity.time = item.time;
        entity.open = lastPreItem.close;
        entity.high = item.maxPrice;
        entity.low = item.minPrice;
        
        if (isSame) {
            [arr replaceObjectAtIndex:arr.count -1 withObject:entity];
        }else{
            [arr addObject:entity];
        }
    }
    return arr;
}



@end
