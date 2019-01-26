//
//  BTTextView.h
//  BT
//
//  Created by vikey on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE;

@interface BTTextView : UITextView

@property (nonatomic, strong) IBInspectable NSString *fixText;

@property (nonatomic, strong) IBInspectable NSString *localText;

@end
