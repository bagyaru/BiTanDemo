//
//  LineViewTableViewCell.h
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FutureLineViewCellDelegate<NSObject>

- (void)refreshDataWithType:(NSInteger)type;

@end

@interface FutureLineViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *info;

@property (nonatomic,weak) id<FutureLineViewCellDelegate>delegate;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, assign)BOOL isHoldCount;


@end
