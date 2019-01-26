//
//  BTDiscovMenuView.h
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//


//export NSString *const KFontSize;

#import "BTView.h"

@protocol BTDiscovMenuViewDelegate<NSObject>

- (void)clickWithData:(NSDictionary*)data;

@end

@interface BTDiscovMenuView : BTView

@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, weak) id<BTDiscovMenuViewDelegate> delegate;

@end



@class BTDiscovMenuContainerView;
@protocol BTDiscovMenuContainerViewDelegate<NSObject>
- (void)menuView:(BTDiscovMenuContainerView*)containerView didClickIndex:(NSInteger)index;
@end

@interface BTDiscovMenuContainerView :BTView

@property (nonatomic, copy) NSArray *menus;

@property (nonatomic, weak) id<BTDiscovMenuContainerViewDelegate> deleagte;
@end
