//
//  NSString+Utils.h
//  YZStock
//
//  Created by fenchol on 15/8/24.
//  Copyright (c) 2015年 cqjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)


- (BOOL)yz_isStringOrNumberCharactorString;
- (BOOL)yz_isNumberCharactorString;

- (BOOL)yz_isFloatNumberCharactorString;

- (BOOL)yz_isValidPhoneString;//判断手机号码11位，纯数字

- (BOOL)yz_isValidAmountString;//8位不带小数点的金额
- (BOOL)yz_isValidAmountWithFloatString;//带两位小数的金额，整数部分不超8位
- (BOOL)yz_isValidIDCardString;//验证身份证
- (BOOL)yz_isValidPassword;//验证密码，同时包含字母和字母
- (BOOL)yz_isValidUserName;//验证用户名
- (BOOL)yz_isValidAuthCode;//4位数字验证码校验
- (BOOL)yz_isWithdrawPwdCode;//6位数字
- (BOOL)yz_isValidEmail;    //验证邮箱

//用*格式化手机号
- (NSString *)formatPhone;
//银行卡尾号，4位
- (NSString *)tailNumber;

//姓名格式化
- (NSString *)formatName;

- (NSString *)trimSpace;

- (CGSize)yz_drawAtPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)yz_drawAtPoint:(CGPoint)point withFont:(UIFont *)font color: (UIColor *)color;
- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color: (UIColor *)color;

- (CGSize)yz_sizeWithFont:(UIFont *)font;



- (CGSize)yz_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

- (CGSize)calculateSizeWithFont:(NSInteger)font height:(CGFloat)height;

@end
