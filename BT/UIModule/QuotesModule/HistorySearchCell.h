//
//  HistorySearchCell.h
//  BT
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HistorySearchType) {
    HistorySearchTypeXianHuo = 1,
    HistorySearchTypeQihuo = 2
};
typedef void(^SearchBlock)(NSString *str);

@interface HistorySearchCell : UITableViewCell

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, copy) SearchBlock searchBlock;

@property (nonatomic, assign) HistorySearchType type;

+ (instancetype)shareInstance;

- (void)createView;

+ (CGFloat)cellHeight;

@end
