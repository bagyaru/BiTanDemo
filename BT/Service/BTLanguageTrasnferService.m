//
//  BTLanguageTrasnferService.m
//  BT
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLanguageTrasnferService.h"

@implementation BTLanguageTrasnferService

+ (instancetype)shareInstanceService{
    static BTLanguageTrasnferService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[BTLanguageTrasnferService alloc] init];
    });
    return service;
}

- (instancetype)init{
    if (self) {
        
    }
    return self;
}
-(void)writeIsOrNoEyesType:(NSString *)eyes {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:eyes forKey:IsOrNoEyes];
}
-(NSString *)readIsOrNoEyesType {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    DLog(@"gg:%@",[userDefault objectForKey:IsOrNoEyes]);
    return [userDefault objectForKey:IsOrNoEyes];
}
-(void)writeNewFeatureTipsType:(NSString *)newFeatureTips {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:newFeatureTips forKey:NewFeatureTips];
    
}
-(NSString *)readNewFeatureTipsType {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    DLog(@"gg:%@",[userDefault objectForKey:NewFeatureTips]);
    return [userDefault objectForKey:NewFeatureTips];
}
- (void)writeIsOrNoPromptType:(NSString *)prompt {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:prompt forKey:promptType];
}
- (NSString *)readIsOrNoPromptType{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    DLog(@"gg:%@",[userDefault objectForKey:promptType]);
    return [userDefault objectForKey:promptType];
}
- (void)writeLegalTendeType:(NSString *)legalTende{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:legalTende forKey:legalTendeType];
}
- (NSString *)readLegalTendeType{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    DLog(@"gg:%@",[userDefault objectForKey:legalTendeType]);
    return [userDefault objectForKey:legalTendeType];
}

- (void)switchOfTestLanguage:(BOOL)on{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:on forKey:lang_SwitchLanguage];
}

- (BOOL)readSwitchOfTestLanguage{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:lang_SwitchLanguage];
}

- (void)checkLanguage{
    BOOL openTest = [self readSwitchOfTestLanguage];
    if (openTest) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:lang_Language_Zh_Hans]) {//开头匹配
            [self writeLanguage:lang_Language_Zh_Hans];
            [self writeLegalTendeType:@"1"];//人民币
        }else{
            [self writeLanguage:lang_Language_En];
            [self writeLegalTendeType:@"2"];
        }
        return;
    }
    if (![self readLanguage]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:lang_Language_Zh_Hans]) {//开头匹配
            [self writeLanguage:lang_Language_Zh_Hans];
            [self writeLegalTendeType:@"1"];//人民币
        }else{
            [self writeLanguage:lang_Language_En];
            [self writeLegalTendeType:@"2"];
        }
    }
}

- (NSString *)sjhSearchContentWith:(NSString *)name{
    NSString *languageString = [self readLanguage];
    if ([lang_Language_Zh_Hans isEqualToString:languageString]) {
        NSDictionary *dic =  [self dicFromZSJson];
        return [dic objectForKey:name];
    }else{
        NSDictionary *dic =  [self dicFromESJson];
        return [dic objectForKey:name];
    }
}

- (NSString *)wyhSearchContentWith:(NSString *)name{
    NSString *languageString = [self readLanguage];
    if ([lang_Language_Zh_Hans isEqualToString:languageString]) {
        NSDictionary *dic =  [self dicFromZWJson];
        return [dic objectForKey:name];
    }else{
        NSDictionary *dic =  [self dicFromEWJson];
        return [dic objectForKey:name];
    }
}

- (void)writeLanguage:(NSString *)language{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:language forKey:lang_Language];
}

- (NSString *)readLanguage{
   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   return  [userDefault objectForKey:lang_Language];
}

- (NSDictionary *)dicFromZSJson{
    return [self dicFromJsonFileName:@"Zh-Hans_DeveloperSjh"];
}

- (NSDictionary *)dicFromZWJson{
    return [self dicFromJsonFileName:@"Zh-Hans_DeveloperWyh"];
}

- (NSDictionary *)dicFromESJson{
    return [self dicFromJsonFileName:@"English_DeveloperSjh"];
}

- (NSDictionary *)dicFromEWJson{
    return [self dicFromJsonFileName:@"English_DeveloperWyh"];
}

- (NSDictionary *)dicFromJsonFileName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}


@end
