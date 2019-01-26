//
//  FenshiRequest.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface FenshiRequest : BTBaseRequest

- (instancetype)initWithKind:(NSString *)kind;

- (instancetype)initWithStartTimeMilis:(long)startTimeMilis Kind:(NSString *)kind;

- (instancetype)initWithStartTimeMilis:(long)startTimeMilis Kind:(NSString *)kind exchangeCode:(NSString*)exchangeCode;

@end
