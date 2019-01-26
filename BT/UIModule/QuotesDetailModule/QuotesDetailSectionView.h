//
//  QuotesDetailSectionView.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleIndexBlock)(NSInteger index);

@interface QuotesDetailSectionView : UIView

@property (nonatomic, copy) HandleIndexBlock handleIndexBlock;

@end
