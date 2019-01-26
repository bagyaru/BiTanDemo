//
//  UpdateBookKeepingRequest.m
//  BT
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UpdateBookKeepingRequest.h"

@implementation UpdateBookKeepingRequest{
    BOOL      _buy;
    BOOL      _currency;
    NSString *_dealCount;
    NSString *_dealTotal;
    NSString *_dealUnitPrice;
    NSString *_dealDate;
    NSString *_kind;
    NSInteger _legalType;
    NSString *_note;
    NSInteger _dealSource;
    NSString *_dealSourceInfo;
    NSInteger _bookkeepingId;
}

-(instancetype)initWithBuy:(BOOL)buy currency:(BOOL)currency dealCount:(NSString *)dealCount dealDate:(NSString *)dealDate dealTotal:(NSString *)dealTotal dealUnitPrice:(NSString *)dealUnitPrice kind:(NSString *)kind legalType:(NSInteger)legalType note:(NSString *)note dealSource:(NSInteger)dealSource dealSourceInfo:(NSString *)dealSourceInfo bookkeepingId:(NSInteger)bookkeepingId{
    
    self = [super init];
    if (self) {
        
        _buy           = buy;
        _currency      = currency;
        _dealCount     = dealCount;
        _dealDate      = dealDate;
        _dealTotal     = dealTotal;
        _dealUnitPrice = dealUnitPrice;
        _kind          = kind;
        _legalType     = legalType;
        _note          = note;
        _dealSource    = dealSource;
        _dealSourceInfo= dealSourceInfo;
        _bookkeepingId = bookkeepingId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return UPDATE_BOOKKEEPING;
}

- (id)requestArgument {
    return @{
             @"BookkeepingVO":@{@"buy":@(_buy),
                                @"currency":@(_currency),
                                @"dealCount":_dealCount,
                                @"dealDate":_dealDate,
                                @"dealTotal":_dealTotal,
                                @"dealUnitPrice":_dealUnitPrice,
                                @"kind":_kind,
                                @"legalType":@(_legalType),
                                @"note":_note,
                                @"dealSource":@(_dealSource),
                                @"dealSourceInfo":_dealSourceInfo,
                                @"bookkeepingId":@(_bookkeepingId)
                                }
             };
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"buy":@(_buy),
                          @"currency":@(_currency),
                          @"dealCount":_dealCount,
                          @"dealDate":_dealDate,
                          @"dealTotal":_dealTotal,
                          @"dealUnitPrice":_dealUnitPrice,
                          @"kind":_kind,
                          @"legalType":@(_legalType),
                          @"note":_note,
                          @"dealSource":@(_dealSource),
                          @"dealSourceInfo":_dealSourceInfo,
                          @"bookkeepingId":@(_bookkeepingId)
                          };
    NSLog(@"%@",dic);
    return  [self bodyRequestWithDic:dic];
}


@end
