//
//  IntroduceCell.h
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceModel.h"

typedef void(^WhiteAddressBlock)(NSString *str);

typedef void(^WebSiteAddressBlock)(NSString *str);

typedef void(^QukuaiAddressBlock)(NSString *str);

@interface IntroduceCell : UITableViewCell

@property (nonatomic, copy) WhiteAddressBlock whiteAddressBlock;

@property (nonatomic, copy) WebSiteAddressBlock webSiteAddressBlock;

@property (nonatomic, copy) QukuaiAddressBlock qukuaiAddressBlock;


+ (instancetype)shareInstance;

- (void)configWith:(IntroduceModel *)model;

+ (CGFloat)cellHeightWith:(IntroduceModel *)model;

@end
