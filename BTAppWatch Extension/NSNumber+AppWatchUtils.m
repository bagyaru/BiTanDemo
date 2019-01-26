//
//  NSNumber+AppWatchUtils.m
//  BTAppWatch Extension
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSNumber+AppWatchUtils.h"

@implementation NSNumber (AppWatchUtils)
static const float unit_ten_thousand = 10000.0;
static const float unit_hundred_million  = 100000000.0;


#pragma mark - Private methods

- (BOOL)isEqualWithDouble:(double)number{
    
    if (fabs([self doubleValue]- number) <= 0.0000000001) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)isEqualGreaterThanDouble:(double)number{
    
    if ([self isEqualWithDouble:number]) {
        
        return YES;
    }
    
    if ([self doubleValue] > number) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)isGreaterThanDouble:(double)number{
    
    if ([self isEqualWithDouble:number]) {
        
        return NO;
    }
    
    if ([self doubleValue] > number) {
        
        return YES;
    }
    
    return NO;
}

- (NSString *)formatDecimal{
    
    return [self formatDecimalWithScale:0];
}

- (NSString *)formatDecimalP2f{
    
    return [self formatDecimalWithScale:2];
}

- (NSString *)formatDecimalP02f{
    NSString *result = [self formatDecimalWithScale:2];
    NSInteger loc = [result rangeOfString: @"."].location;
    if (loc != NSNotFound) {
        NSInteger pointCount = result.length - loc - 1;
        if (pointCount < 2) {
            result = [result stringByAppendingString: @"0"];
        }
    }
    else
    {
        result = [result stringByAppendingString: @".00"];
    }
    
    return result;
}

- (NSString *)formatDecimalWithScale:(int)scale{
    
    NSDecimalNumber *number = [[[NSDecimalNumber alloc] initWithDouble:[self doubleValue]] decimalNumberByRoundingAccordingToBehavior:[self roundBankersWithScale:scale]];
    
    return  [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterDecimalStyle];
}

- (NSString *)formatP0f{
    
    return [NSString stringWithFormat:@"%.0f", [self doubleValue]];
}

- (NSString *)formatP01f{
    
    return [NSString stringWithFormat:@"%.01f", [self doubleValue]];
}

- (NSString *)formatP2f{
    
    return [self roundCeilingStringWithScale:2];
}

- (NSString *)formatP8f{
    return [self roundCeilingStringWithScale:8];
}

- (NSString *)formatP02f{
    
    return [NSString stringWithFormat:@"%.02f", [self doubleValue]];
}

- (NSString *)formatP03f{
    
    return [NSString stringWithFormat:@"%.03f", [self doubleValue]];
}

- (NSString *)formatUnit{
    
    if ([self isEqualGreaterThanDouble:unit_hundred_million]) {
        
        return [NSString stringWithFormat:@"%@亿", @([self doubleValue]/unit_hundred_million).decimalString];
        
    }else if ([self isEqualGreaterThanDouble: unit_ten_thousand]) {
        
        return [NSString stringWithFormat:@"%@万", @([self doubleValue]/unit_ten_thousand).decimalString];
    }
    
    return self.decimalString;
}

- (NSString *)formatUnitP2f{
    
    
    if ([self isEqualGreaterThanDouble:unit_hundred_million]) {
        
        return [NSString stringWithFormat:@"%@亿", @([self doubleValue]/unit_hundred_million).decimalP2fString];
        
    }else if ([self isEqualGreaterThanDouble: unit_ten_thousand]) {
        
        return [NSString stringWithFormat:@"%@万", @([self doubleValue]/unit_ten_thousand).decimalP2fString];
        
    }
    
    return self.decimalP2fString;
}

- (double)convertChargeFee{
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *number = [[[NSDecimalNumber alloc] initWithDouble:[self doubleValue]] decimalNumberByRoundingAccordingToBehavior:handler];
    
    return  [number doubleValue];
}

- (NSDecimalNumberHandler *)roundPlainWithScale:(int)scale{
    
    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
}

- (NSDecimalNumberHandler *)roundDownWithScale:(int)scale{
    
    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
}

- (NSDecimalNumberHandler *)roundBankersWithScale:(int)scale{
    
    return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
}

- (NSString *)p0fString{
    
    return [self formatP0f];
}

- (NSString *)p01fString{
    
    return [self formatP01f];
}

- (NSString *)p2fString{
    NSString *str = [self formatP2f];
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSRange ran = [str rangeOfString:@"."];
        if (str.length - ran.location == 2) {
            str = [NSString stringWithFormat:@"%@0",str];
            return str;
        }
    }else{
        str = [NSString stringWithFormat:@"%@.00",str];
        return str;
    }
    return [self formatP2f];
}

- (NSString *)p8fString{
    return [self formatP8f];
}

- (NSString*)p6fString{
    return [self roundCeilingStringWithScale:6];
    
}
- (NSString *)p02fString{
    
    return [self formatP02f];
}

- (NSString *)p03fString{
    
    return [self formatP03f];
}

- (NSString *)decimalString{
    
    return [self formatDecimal];
}

- (NSString *)decimalP2fString{
    
    return [self formatDecimalP2f];
}

- (NSString *)decimalP02fString{
    
    return [self formatDecimalP02f];
}

- (NSString *)unitString{
    
    return [self formatUnit];
}

- (NSString *)unitP2fString{
    
    return [self formatUnitP2f];
}

- (NSString *)rfString{
    
    return [self roundFloorStringWithScale:0];
}

- (NSString *)r2fString{
    
    return [self roundFloorStringWithScale:2];
}

- (NSString *)r4fString{
    
    return [self roundFloorStringWithScale:4];
}

- (NSString *)roundFloorStringWithScale:(NSInteger)scale{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.roundingMode = kCFNumberFormatterRoundFloor;
    formatter.usesGroupingSeparator = NO;
    formatter.minimumIntegerDigits = 1;
    formatter.maximumFractionDigits = scale;
    
    NSDecimalNumber *number = [[[NSDecimalNumber alloc] initWithDouble:[self doubleValue]] decimalNumberByRoundingAccordingToBehavior:[self roundPlainWithScale:6]];
    
    return [formatter stringFromNumber:number];
}

- (NSString *)roundCeilingStringWithScale:(NSInteger)scale{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundCeiling;
    formatter.usesGroupingSeparator = NO;
    formatter.maximumFractionDigits = scale;
    
    NSDecimalNumber *number = [[[NSDecimalNumber alloc] initWithDouble:[self doubleValue]] decimalNumberByRoundingAccordingToBehavior:[self roundBankersWithScale:scale]];
    
    return [formatter stringFromNumber:number];
}

@end
