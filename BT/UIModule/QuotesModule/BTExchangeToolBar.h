//
//  BTExchangeToolBar.h
//  BT
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@class BTExchangeToolBar;

@protocol BTExchangeToolBarDelegate<NSObject>
- (void)menuView:(BTExchangeToolBar*)containerView didClickIndex:(NSInteger)index;

@end

@interface BTExchangeToolBar : BTView

@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, weak) id<BTExchangeToolBarDelegate>delegate;

- (void)itemSelectIndex:(NSInteger)index;

@end



@class BTExchangeToolMenuView;
@protocol BTExchangeToolMenuViewDelegate<NSObject>

- (void)clickView:(BTExchangeToolMenuView*)menu withData:(NSDictionary*)data;

@end

@interface BTExchangeToolMenuView : UIView

@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, weak) id<BTExchangeToolMenuViewDelegate> delegate;
@property (nonatomic, assign) BOOL isSelected;

@end

