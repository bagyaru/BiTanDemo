//
//  BTExchangeModel.h
//  BT
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTExchangeModel : BTBaseObject
@property (nonatomic,strong)NSString *exchangeName;
@property (nonatomic,strong)NSString *exchangeCode;
@property (nonatomic,strong)NSString *exchangeKey;
@property (nonatomic,strong)NSString *exchangeSecret;
@property (nonatomic,assign)BOOL      isOrNoAuthorized;
@property (nonatomic, strong) NSString *userId;
@end
