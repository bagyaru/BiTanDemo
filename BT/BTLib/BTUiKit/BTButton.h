//
//  BTButton.h
//  BT
//
//  Created by vikey on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE;

@interface BTButton : UIButton

@property (nonatomic, strong) IBInspectable NSString *fixTitle;

@property (nonatomic, strong) IBInspectable NSString *localTitle;


@end
