//
//  BTAddressDetailModel.h
//  BT
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTAddressDetailModel : BTBaseObject

@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * direction;
@property (nonatomic, assign)double price;
@property (nonatomic, assign)double quantity;
@property (nonatomic, assign)double turnover;

@end
