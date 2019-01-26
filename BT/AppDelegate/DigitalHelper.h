//
//  DigitalHelper.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DigitalHelperService [DigitalHelper shareInstance]

@interface DigitalHelper : NSObject

@property (nonatomic, assign) BOOL isCNY;

//+ (double)

+ (instancetype)shareInstance;


- (NSString*)analyseTransformWith:(double)number;

- (NSString *)transformWith:(double)number;

- (NSString *)isTransformWithDouble:(double)dobuleNumber;

- (NSString *)isp8DataWithDouble:(double)doubleNumber;

- (NSString*)iskLineDataWithDouble:(double)doubleNumber;

- (NSString *)isp6DataWithDouble:(double)doubleNumber;


- (double)transformXiaoshuWith:(double)dobuleNumber;

- (NSString *)formartScientificNotationWithString:(NSString *)str;

- (NSString *)upTransformWith:(double)number;
- (NSString *)downTransformWith:(double)number;

@end
