//
//  DigitalHelper.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DigitalHelper.h"
#import "NSNumber+Utils.h"

@implementation DigitalHelper

+ (instancetype)shareInstance{
    static DigitalHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DigitalHelper alloc] init];
    });
    return helper;
}

- (NSString*)analyseTransformWith:(double)number{
    //
    if (kIsCNY) {
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).p2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).p2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).p2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).p8fString;
        }
        return @(number).p0fString;
    }else{
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).p2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).p2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).p2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).p8fString;
        }
        return @(number).p0fString;
    }
}


- (NSString *)downTransformWith:(double)number{
    if (kIsCNY) {
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).downP2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).downP2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).downP2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).downP2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).downP2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).downP8fString;
        }
        return @(number).downP2fString;
    }else{
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).downP2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).downP2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).downP2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).downP2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).downP2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).downP8fString;
        }
        return @(number).downP2fString;
    }
    
    
    
}

//
- (NSString *)upTransformWith:(double)number{
    if (kIsCNY) {
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).upP2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).upP2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).upP2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).upP2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).upP2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).upP8fString;
        }
        return @(number).upP2fString;
    }else{
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).upP2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).upP2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).upP2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).upP2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).upP2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).upP8fString;
        }
        return @(number).upP2fString;
    }
}


- (NSString *)transformWith:(double)number{
    if (kIsCNY) {
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).p2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).p2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).p2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).p8fString;
        }
        return @(number).p2fString;
    }else{
        
        if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
            
            if (ABS(number) / 100000000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 100000000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"yi"]];
            }
            if (ABS(number) / 10000 >= 1) {
                return [NSString stringWithFormat:@"%@%@",@(number / 10000.0).p2fString,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        } else {
            
            if (ABS(number) >= 1000000000) {
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000000001).p2fString,[APPLanguageService sjhSearchContentWith:@"shiyi"]];
            }
            if (ABS(number) >= 1000000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.000001).p2fString,[APPLanguageService sjhSearchContentWith:@"baiwan"]];
            }
            if (ABS(number) >= 1000) {//美元数量
                return [NSString stringWithFormat:@"%@%@",@(number * 0.001).p2fString,[APPLanguageService sjhSearchContentWith:@"qian"]];
            }
        }
        if(ABS(number) < 1){
            return @(number).p8fString;
        }
        return @(number).p2fString;
    }
    
}

- (NSString *)isTransformWithDouble:(double)dobuleNumber{
    if (fabs(dobuleNumber) > 1) {
        return @(dobuleNumber).p2fString;
    }else if (fabs(dobuleNumber) < 1){
        return @(dobuleNumber).p8fString;
    }else{
        return @(dobuleNumber).stringValue;
    }
}

- (NSString*)iskLineDataWithDouble:(double)doubleNumber{
    if (fabs(doubleNumber) > 1) {
        return @(doubleNumber).p2fString;
    }else if (fabs(doubleNumber) < 1){
        return @(doubleNumber).p6fString;
    }else{
        return @(doubleNumber).stringValue;
    }
}

- (NSString *)isp6DataWithDouble:(double)doubleNumber{
    if (fabs(doubleNumber) > 1) {
        return @(doubleNumber).p6fString;
    }else if (fabs(doubleNumber) < 1){
        return @(doubleNumber).p6fString;
    }else{
        return @(doubleNumber).stringValue;
    }
}

- (NSString*)isp8DataWithDouble:(double)doubleNumber{
    if (fabs(doubleNumber) > 1) {
        return @(doubleNumber).p8fString;
    }else if (fabs(doubleNumber) < 1){
        return @(doubleNumber).p8fString;
    }else{
        return @(doubleNumber).stringValue;
    }
}
- (double)transformXiaoshuWith:(double)dobuleNumber{
    if (dobuleNumber *100 > 0.055 ) {
        return dobuleNumber *100;
    }else if (dobuleNumber * 1000 > 0.055){
        return dobuleNumber * 1000;
    }else if (dobuleNumber * 10000 > 0.055){
        return dobuleNumber * 10000;
    }else if (dobuleNumber *100000 > 0.055){
         return dobuleNumber * 100000;
    }else if (dobuleNumber *1000000 > 0.055){
        return dobuleNumber * 1000000;
    }else if (dobuleNumber *10000000 > 0.055){
        return dobuleNumber * 10000000;
    }else if (dobuleNumber *100000000 > 0.055){
        return dobuleNumber * 100000000;
    }
    return 0;
}

- (NSString *)formartScientificNotationWithString:(NSString *)str{
     long double num = [[NSString stringWithFormat:@"%@",str] floatValue];
     NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
     formatter.numberStyle = NSNumberFormatterDecimalStyle;
    if (num < 1.0) {
        return [NSDecimalNumber numberWithDouble:num].p8fString;
    }else{
        return [NSDecimalNumber numberWithDouble:num].p2fString;
    }
    
}


@end
