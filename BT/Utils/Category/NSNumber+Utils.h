//
//  NSNumber+Utils.h
//  YZOuterDisc
//
//  Created by wangminhong on 15/9/8.
//  Copyright (c) 2015年 cqjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Utils)

@property (nonatomic, strong, readonly) NSString *p0fString;/*无格式，不带小数点*/
@property (nonatomic, strong, readonly) NSString *p01fString;/*无格式，精确一位小数，补0*/
@property (nonatomic, strong, readonly) NSString *p02fString;/*无格式，精确两位小数，补0*/
@property (nonatomic, strong, readonly) NSString *p03fString;/*无格式，精确三位小数，补0*/
@property (nonatomic, strong, readonly) NSString *p2fString;/*无格式，精确两位小数，不补0， 四舍五入*/
@property (nonatomic, strong, readonly) NSString *p8fString;/*无格式，精确8位小数，不补0， 四舍五入*/

@property (nonatomic, strong, readonly) NSString *p6fString;/*无格式，精确8位小数，不补0， 四舍五入*/



@property (nonatomic, strong, readonly) NSString *decimalP2fString;/*带分隔符(,)的格式化，带2位小数, 不补0*/
@property (nonatomic, strong, readonly) NSString *decimalP02fString;/*带分隔符(,)的格式化，带2位小数, 补0*/

@property (nonatomic, strong, readonly) NSString *unitString;/*大于万，以万为单位；大于亿，以亿为单位， 不带小数*/
@property (nonatomic, strong, readonly) NSString *unitP2fString;/*带2位小数点的 YZNumberFormatUnit格式*/

@property (nonatomic, strong, readonly) NSString *rfString;/*无格式，抹去小数*/
@property (nonatomic, strong, readonly) NSString *r2fString;/*无格式，抹去小数两位之后的数据，小数位不补0，如2.1，2.12*/
@property (nonatomic, strong, readonly) NSString *r4fString;/*无格式，抹去小数四位之后的数据，小数位不补0，如2.1999999 = 2.2*/



@property (nonatomic, strong, readonly) NSString *upP2fString;
@property (nonatomic, strong, readonly) NSString *upP8fString;
@property (nonatomic, strong, readonly) NSString *downP2fString;
@property (nonatomic, strong, readonly) NSString *downP8fString;


/**
 *  比较是否等于
 *
 *  @param number
 *
 *  @return
 */
- (BOOL)isEqualWithDouble:(double)number;

/**
 *  是否大于等于
 *
 *  @param number
 *
 *  @return
 */
- (BOOL)isEqualGreaterThanDouble:(double)number;

/**
 *  是否大于
 *
 *  @param number
 *
 *  @return
 */
- (BOOL)isGreaterThanDouble:(double)number;

- (double)convertChargeFee;

@end
