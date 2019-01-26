//
//  SelectMemberWithSearchView.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConatctModel.h"

@protocol SelectMemberWithSearchViewDelegate <NSObject>
// 点击collection cell取消选中
- (void)removeMemberFromSelectArray:(ConatctModel *)member
                          indexPath:(NSIndexPath *)indexPath;
@end

@interface SelectMemberWithSearchView : UIView
@property (nonatomic, weak) id<SelectMemberWithSearchViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textfield;

// 当选中人数发生改变时 更改collection view UI
- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray;

@end
