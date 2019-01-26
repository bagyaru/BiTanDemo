//
//  NSString+Utils.m
//  YZStock
//
//  Created by fenchol on 15/8/24.
//  Copyright (c) 2015年 cqjr. All rights reserved.
//

#import "NSString+Utils.h"

#define kNUMBERS @"0123456789"

@implementation NSString (Utils)

- (BOOL)yz_isFloatNumberCharactorString
{
    NSArray *commponents = [self componentsSeparatedByString: @"."];
    if (commponents.count > 2) {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: @".0123456789"] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [self isEqualToString:filtered];
}

- (BOOL)yz_isStringOrNumberCharactorString{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [self isEqualToString:filtered];
}

- (BOOL)yz_isNumberCharactorString
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: @"0123456789"] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [self isEqualToString:filtered];
}

- (BOOL)yz_isValidPhoneString{
    
    NSString *regex = @"^1[34578]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}


- (BOOL)yz_isValidAmountString{
    
    NSString *regex = @"\\d{0,8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)yz_isValidAmountWithFloatString{
    
    NSString *regex = @"\\d{0,8}(\\.\\d{0,2})?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)yz_isValidIDCardString{
    
    NSString *regex = @"[0-9Xx]{0,18}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)yz_isValidPassword {
    
    NSString *regex = @"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

- (BOOL)yz_isValidUserName {
    
    NSString *regex = @"^[\u4e00-\u9fa5]{2,8}$|^[\\d\\w]{3,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

- (BOOL)yz_isValidAuthCode {
    
    NSString *regex = @"\\d{4,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

- (BOOL)yz_isWithdrawPwdCode {
    
    NSString *regex = @"\\d{6,6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

- (BOOL)yz_isValidEmail {
    
    NSString *regex = @"^[0-9a-zA-Z_\\.\\-]+@[0-9a-zA-Z_\\-]+\\.\\w{1,5}(\\.\\w{1,5})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

- (NSString *)trimSpace{
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

- (CGSize)yz_drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    
    NSDictionary *attr = @{NSFontAttributeName: font};
    [self drawAtPoint: point withAttributes: attr];
    return CGSizeZero;
    //return [self sizeWithAttributes: attr];
}

- (CGSize)yz_drawAtPoint:(CGPoint)point withFont:(UIFont *)font color: (UIColor *)color
{
    NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    [self drawAtPoint: point withAttributes: attr];
    return CGSizeZero;
}

- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = alignment;
    style.lineBreakMode = lineBreakMode;
    NSDictionary *attr = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
    [self drawInRect: rect withAttributes: attr];
    return CGSizeZero;
    //return [self sizeWithAttributes: attr];
}

- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color: (UIColor *)color
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = alignment;
    style.lineBreakMode = lineBreakMode;
    NSDictionary *attr = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: color};
    [self drawInRect: rect withAttributes: attr];
    return CGSizeZero;
}

- (CGSize)yz_sizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes: @{NSFontAttributeName: font}];
}

- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self yz_drawInRect: rect withFont: font lineBreakMode:lineBreakMode alignment: NSTextAlignmentLeft];
}

- (NSString *)formatPhone{
    
    if (self.length > 7) {
        
        return [self stringByReplacingCharactersInRange: NSMakeRange(3, 4) withString: @"****"];
    }
    
    return self;
}

- (NSString *)tailNumber{
    
    if (self.length > 4) {
        
        return [self substringFromIndex:self.length-4];
    }
    
    return self;
}

- (NSString *)formatName{
    
    if (self.length >= 1) {
        
        return [self stringByReplacingCharactersInRange: NSMakeRange(self.length-1, 1) withString: @"*"];
    }
    
    return self;
}

- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    if(startRange.location !=NSNotFound &&endRange.location!=NSNotFound){
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        return [self substringWithRange:range];
    }
    return @"";
    
    
}


- (CGSize)calculateSizeWithFont:(NSInteger)font height:(CGFloat)height{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGRect size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size.size;
}


@end
