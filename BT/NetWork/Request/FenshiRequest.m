//
//  FenshiRequest.m
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FenshiRequest.h"

@implementation FenshiRequest{
    NSString *_kind;
    long _startTimeMilis;
    NSString *_exchangeCode;
}

- (instancetype)initWithKind:(NSString *)kind{
    self = [super init];
    if (self) {
        _kind = kind;
    }
    return self;
}

- (instancetype)initWithStartTimeMilis:(long)startTimeMilis Kind:(NSString *)kind{
    self = [super init];
    if (self) {
        _startTimeMilis = startTimeMilis;
        _kind = kind;
    }
    return self;
}

- (instancetype)initWithStartTimeMilis:(long)startTimeMilis Kind:(NSString *)kind exchangeCode:(NSString*)exchangeCode{
    self = [super init];
    if (self) {
        _startTimeMilis = startTimeMilis;
        _kind = kind;
        _exchangeCode = exchangeCode;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return FENSHI_URL;
}

- (id)requestArgument{
    if([_exchangeCode isEqualToString:k_Net_Code]){
        return @{@"kind":_kind,@"startTimeMilis":@(_startTimeMilis)};
    }else{
        return @{@"kind":_kind,@"startTimeMilis":@(_startTimeMilis),@"exchangeCode":SAFESTRING(_exchangeCode)};
    }
//    return @{@"kind":_kind,@"startTimeMilis":@(_startTimeMilis)};
////    return @{@"kind":_kind};
}

@end
