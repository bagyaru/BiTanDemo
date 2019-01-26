//
//  UITableView+Utils.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UITableView+Utils.h"
#import <objc/runtime.h>

@implementation UITableView (Utils)

+ (void)load{
    Method originMethod = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method newMethod = class_getInstanceMethod([self class], @selector(initNewWithCoder));
    method_exchangeImplementations(originMethod, newMethod);
    
    Method originWriteMethod = class_getInstanceMethod([self class], @selector(initWithFrame:style:));
    Method newWriteMethod = class_getInstanceMethod([self class], @selector(initNewWithFrame:style:));
    method_exchangeImplementations(originWriteMethod, newWriteMethod);
    
    
}

- (instancetype)initNewWithCoder{
    self = [self initNewWithCoder];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    return self;
}

- (instancetype)initNewWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self =  [self initNewWithFrame:frame style:style];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    return self;
}



@end
