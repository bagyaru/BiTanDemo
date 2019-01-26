//
//  NewsRequest.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface NewsRequest : BTBaseRequest

- (instancetype)initWithType:(NSInteger)type keyword:(NSString *)keyword excludeBanner:(BOOL)excludeBanner currentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize;
@end
