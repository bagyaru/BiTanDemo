//
//  BTHomePageArticleApi.h
//  BT
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTHomePageArticleApi : BTBaseRequest

- (id)initWithUserId:(NSInteger)userId currentPage:(NSInteger)currentPage original:(BOOL)original;

@end
