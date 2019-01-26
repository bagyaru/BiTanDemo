//
//  MQImageButton.h
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"
@interface MQImageButton : UIButton
@property (nonatomic,copy) void(^deleteButtonClickedBlock)(void);
@property (nonatomic,copy) void(^buttonClickedBlock)(void);
@property (nonatomic,assign) BOOL isAddButton;
@property (nonatomic, strong) JKAssets *asset;

- (BOOL)pointInDeleteButton:(CGPoint)point;

@end
