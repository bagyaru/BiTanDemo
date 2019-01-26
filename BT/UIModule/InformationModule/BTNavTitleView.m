//
//  BTNavTitleView.m
//  BT
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNavTitleView.h"

@implementation BTNavTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}

@end
