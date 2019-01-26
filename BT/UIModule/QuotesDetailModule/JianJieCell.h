//
//  JianJieCell.h
//  BT
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroduceModel.h"
typedef void(^WhiteAddressBlock)(NSString *str);

typedef void(^WebSiteAddressBlock)(NSString *str);

typedef void(^QukuaiAddressBlock)(NSString *str);
@interface JianJieCell : UITableViewCell

@property (nonatomic, copy) WhiteAddressBlock whiteAddressBlock;

@property (nonatomic, copy) WebSiteAddressBlock webSiteAddressBlock;

@property (nonatomic, copy) QukuaiAddressBlock qukuaiAddressBlock;

- (void)configWith:(IntroduceModel *)model;

+ (CGFloat)cellHeightWith:(IntroduceModel *)model;
@end
