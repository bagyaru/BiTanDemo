//
//  BTWebsiteItemView.h
//  BT
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTWebsiteItemView : UIView

@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, copy) void (^completion)(void);


@end
