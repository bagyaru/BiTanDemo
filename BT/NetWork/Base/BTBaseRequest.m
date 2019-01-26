//
//  BTBaseRequest.m
//  BT
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"
#import "BTConfig.h"

@implementation BTBaseRequest

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    NSString *stringLanguage;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        stringLanguage = @"cn";
    }else{
        stringLanguage = @"en";
    }
    return @{ApplicationId:ApplicationIdValue,
             ApplicationClientType:ApplicationClientTypeValue,
             DeviceUUID:
                 GetUUID,
             Token:[BTGetUserInfoDefalut sharedManager].userInfo.token.length > 0 ? [BTGetUserInfoDefalut sharedManager].userInfo.token : @"",
             UserID:[BTGetUserInfoDefalut sharedManager].userInfo.userId > 0 ? @([BTGetUserInfoDefalut sharedManager].userInfo.userId).stringValue:@"0",
             langLanguageType:stringLanguage,
             legalTendeType:ISNSStringValid([APPLanguageService readLegalTendeType]) ? [APPLanguageService readLegalTendeType] : @"1",
             UserFrom:UserFromValue,
             AppVersion:AppVersionValue,
             BuildVersion:VersionNumber
             
             };
}

- (void)requestWithCompletionBlockWithSuccess:(BTRequestCompletionBlock)success failure:(BTRequestCompletionBlock)failure{
//    [self startWithCompletionBlockWithSuccess:success failure:failure];
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        self.ServerTime = [dic objectForKey:@"ServerTime"];
        self.code = [[dic objectForKey:@"code"] longValue];
        self.resultMsg = [dic objectForKey:@"resultMsg"];
        BOOL isSuccess = [[dic objectForKey:@"success"] boolValue];
        BOOL hasNext = [[dic objectForKey:@"hasNext"] boolValue];
        NSInteger totalPage = [[dic objectForKey:@"totalPage"] integerValue];
        self.isSuccess = isSuccess;
        self.hasNext   = hasNext;
        self.totalPage = totalPage;
        if (isSuccess) {
            self.data = [dic objectForKey:@"data"];
            if ([self.data isKindOfClass:[NSNull class]] || self.data == nil || self.data == [NSNull null]) {
                
                self.data = @[];
            }
            if (success) {
                success(self);
            }
        }else{
            
            if (![self.requestUrl isEqualToString:XianHuoDetailHangQingUrl] && ![self.requestUrl isEqualToString:SavaErrorLogUrl]&&!ISStringEqualToString(dic[@"resultMsg"], @"服务器开了小差，请稍候重试")&&!ISStringEqualToString(dic[@"resultMsg"], @"网络服务不稳定")&&!ISStringEqualToString(dic[@"resultMsg"], @"该交易所数据不存在")) {
                
                if ([self.requestUrl isEqualToString:Exceotional_TP_Url]) {
                    
                    if (self.code != 1011 && self.code != 2000) {
                        
                        [MBProgressHUD showMessageIsWait:dic[@"resultMsg"] wait:YES];
                    }
                }else {
                    //禁言
                    if(self.code == 6001){
                        [MBProgressHUD showMessageIsWait:[APPLanguageService sjhSearchContentWith:@"jinyandesc"] wait:YES];
                        
                    }else{
                        [MBProgressHUD showMessageIsWait:dic[@"resultMsg"] wait:YES];
                    }
                    
                }
            }
            if (ISStringEqualToString(dic[@"resultMsg"], @"服务器开了小差，请稍候重试")) {
                
                if (self.isShowMessage) {
                    [MBProgressHUD showMessageIsWait:dic[@"resultMsg"] wait:YES];
                }
            }
            if (failure) {
                failure(self);
            }
            if (self.code == 4002) {
                
                [getUserCenter loginoutPullView];
                [getUserCenter loginout];
            }
            if ((self.code != 0) && ![self.requestUrl isEqualToString:SavaErrorLogUrl]) {//错误上报
                
                [getUserCenter saveErrorLogToServiceWith:self.requestUrl errorMsg:dic[@"resultMsg"]];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.resultMsg = [self errorMsgWith:request];
        if (![self.resultMsg isKindOfClass:[NSNull class]]) {
            if (self.resultMsg.length > 0 && ![self.requestUrl isEqualToString:SavaErrorLogUrl]) {
                [MBProgressHUD showMessageIsWait:[self errorMsgWith:request] wait:YES];
            }
        }
        
        if (failure) {
            failure(self);
        }
        if (![self.requestUrl isEqualToString:SavaErrorLogUrl]) {
            
           [getUserCenter saveErrorLogToServiceWith:self.requestUrl errorMsg:self.resultMsg];
        }
        
    }];
}

- (NSString *)errorMsgWith:(YTKBaseRequest *)request{
    if (kNetworkNotReachability) {
       return [APPLanguageService sjhSearchContentWith:@"nonetwork"];
    }
    NSDictionary *dic = request.responseObject;
    return dic[@"resultMsg"];
}

- (NSURLRequest *)bodyRequestWithDic:(id)dic{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].domain,self.requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:ApplicationIdValue forHTTPHeaderField:ApplicationId];
    [request addValue:ApplicationClientTypeValue forHTTPHeaderField:ApplicationClientType];
    [request addValue:GetUUID forHTTPHeaderField:DeviceUUID];
    [request addValue:VersionNumber forHTTPHeaderField:BuildVersion];
    NSString *stringLanguage;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        stringLanguage = @"cn";
    }else{
        stringLanguage = @"en";
    }
    [request addValue:stringLanguage forHTTPHeaderField:langLanguageType];
    [request addValue:[APPLanguageService readLegalTendeType] forHTTPHeaderField:legalTendeType];
    [request addValue:[BTGetUserInfoDefalut sharedManager].userInfo.token.length > 0 ? [BTGetUserInfoDefalut sharedManager].userInfo.token : @"" forHTTPHeaderField:Token];
    [request addValue:[BTGetUserInfoDefalut sharedManager].userInfo.userId > 0 ? @([BTGetUserInfoDefalut sharedManager].userInfo.userId).stringValue:@"0" forHTTPHeaderField:UserID];
    [request addValue:UserFromValue forHTTPHeaderField:UserFrom];
    [request addValue:AppVersionValue forHTTPHeaderField:AppVersion];
    [request setHTTPBody:data];
    return request;
}


@end
