//
//  NSRegularExpression+SHY_GetValues.m
//  NSRegularExpressionGetValues
//
//  Created by Shenry on 2017/10/19.
//  Copyright © 2017年 Shenry. All rights reserved.
//

#import "NSRegularExpression+SHY_GetValues.h"

@implementation NSRegularExpression (SHY_GetValues)

+ (BOOL)isMatchRegularExpression:(NSString *)regex checkString:(NSString *)checkString {
    if (!checkString) {
        return NO;
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error];
    
    NSTextCheckingResult *result =
    [regularExpression firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    return result != nil;
}

+ (NSString *)partStringOfCheckStringWithRegularExpression:(NSString *)regex checkString:(NSString *)checkString {
    if (!checkString) {
        return nil;
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error];
    NSTextCheckingResult *result =
    [regularExpression firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    return result ? [checkString substringWithRange:result.range] : nil;
}

+ (void)arrayOfCheckStringWithRegularExpression:(NSString *)regex expression:(NSString *)regex_two checkString:(NSString *)checkString completion:(CheckingResultBlock)completion{
    if (!checkString) {
        return;
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error];
//    NSTextCheckingResult *result = [regularExpression firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    
     NSArray<NSTextCheckingResult *> *result = [regularExpression matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, checkString.length)];
    
    NSMutableArray *aitStrArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *jingStrArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *aitRangeArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *jingRangeArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSError *error_two = NULL;
    NSRegularExpression *regularExpression_two = [NSRegularExpression regularExpressionWithPattern:regex_two
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error_two];
//    NSTextCheckingResult *result = [regularExpression_two firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    
    NSArray<NSTextCheckingResult *> *result_two = [regularExpression_two matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, checkString.length)];
    
   
    for (NSInteger i = 0; i < result.count; i++) {
        NSString *matchString;
         NSTextCheckingResult *res = result[i];
         NSRange range = res.range;
        
        if (range.location != NSNotFound) {
            matchString = [checkString substringWithRange:range];
        } else {
            matchString = @"";
        }
        [aitStrArr addObject:matchString];
        [aitRangeArr addObject:[NSValue valueWithRange:range]];
    }
    for (NSInteger i = 0; i < result_two.count; i++) {
        NSString *matchString;
        NSTextCheckingResult *res = result_two[i];
        NSRange range = res.range;
        
        if (range.location != NSNotFound) {
            matchString = [checkString substringWithRange:range];
        } else {
            matchString = @"";
        }
        [jingStrArr addObject:matchString];
        [jingRangeArr addObject:[NSValue valueWithRange:range]];
    }
    
    if (completion) {
        completion(aitStrArr,aitRangeArr,jingStrArr,jingRangeArr);
    }
    
}

@end
