//
//  UITableView+Extension.m
//  BT
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(layoutSubviews);//原始方法
        SEL swizzledSelector = @selector(xdd_layoutSubViews);// 要替换的方法
        Method originalMethod = class_getInstanceMethod([UITableView class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([UITableView class], swizzledSelector);
        BOOL didAddMethod = class_addMethod([UITableViewCell class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod([UITableView class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

//全局改变tableview的背景底色
- (void)xdd_layoutSubViews{
    [self xdd_layoutSubViews];
    
    //兼容UIPickerView
    BOOL isExist = NO;
    for(UIView *view in self.subviews){
        if([view isKindOfClass:NSClassFromString(@"UIPickerTableViewCell")]){
            isExist = YES;
            break;
        }
    }
    if(!isExist){
        //兼容
        if([self.superview isKindOfClass:NSClassFromString(@"GroupSideView")]){
            self.backgroundColor = isNightMode?ViewContentBgColor:[UIColor whiteColor];
        }else{
            self.backgroundColor = isNightMode?ViewBGNightColor:kHEXCOLOR(0xF5F5F5);
            if (self.tag == 8754159) {
                self.backgroundColor = [UIColor clearColor];
            }
            if(self.tag == 100000){
                 self.backgroundColor = [UIColor clearColor];
            }
            if(self.tag == 1000001){
                self.backgroundColor = [UIColor clearColor];
            }

        }
    }
}

@end
