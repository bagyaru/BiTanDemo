//
//  BTLanguageTrasnferService.h
//  BT
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPLanguageService [BTLanguageTrasnferService shareInstanceService]

@interface BTLanguageTrasnferService : NSObject

+ (instancetype)shareInstanceService;

- (void)switchOfTestLanguage:(BOOL)on;

- (NSString *)sjhSearchContentWith:(NSString *)name;

- (NSString *)wyhSearchContentWith:(NSString *)name;

- (void)checkLanguage;

- (void)writeLanguage:(NSString *)language;

- (void)writeLegalTendeType:(NSString *)legalTende;

- (void)writeIsOrNoPromptType:(NSString *)prompt;//写入是否已经引导用户

- (NSString *)readIsOrNoPromptType;//读取是否已经引导用户

- (NSString *)readLegalTendeType;

- (NSString *)readLanguage;

- (NSDictionary *)dicFromZSJson;

- (NSDictionary *)dicFromZWJson;

- (NSDictionary *)dicFromESJson;

- (NSDictionary *)dicFromEWJson;

- (void)writeNewFeatureTipsType:(NSString *)newFeatureTips;//写入是否新功能提示

- (NSString *)readNewFeatureTipsType;//读取是否新功能提示过

- (void)writeIsOrNoEyesType:(NSString *)eyes;//写入是明文还是暗文

- (NSString *)readIsOrNoEyesType;//读取是明文还是暗文
@end
