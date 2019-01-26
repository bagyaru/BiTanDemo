//
//  HistorySectionView.h
//  BT
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearBlock)(void);

typedef NS_ENUM(NSInteger,SectionViewType) {
    SectionViewTypeHistory,
    SectionViewTypeHot,
    SectionViewTypeResult
};

@interface HistorySectionView : UITableViewHeaderFooterView

@property (nonatomic, assign) SectionViewType type;

@property (nonatomic, copy) ClearBlock clearBlock;

@end
