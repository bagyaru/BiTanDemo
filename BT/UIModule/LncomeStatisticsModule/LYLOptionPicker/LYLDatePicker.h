//
//  LYLDatePicker.h
//  LYLOptionPickerDemo
//
//  Created by Rainy on 2017/10/17.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYLDatePicker : NSObject
+ (instancetype)sharedDatePicker;
@property (nonatomic,assign)NSInteger type;
+ (void)showDateDetermineChooseInView:(UIView *)view
                      determineChoose:(void(^)(NSString *dateString))determineChoose;

@end
