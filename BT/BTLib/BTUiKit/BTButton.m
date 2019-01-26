//
//  BTButton.m
//  BT
//
//  Created by vikey on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTButton.h"

@implementation BTButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFixTitle:(NSString *)fixTitle{
    if (fixTitle.length == 0) {
        return;
    }
    _fixTitle = fixTitle;
    [self setTitle:[APPLanguageService sjhSearchContentWith:fixTitle] forState:UIControlStateNormal];
}

- (void)setLocalTitle:(NSString *)localTitle{
    if (localTitle.length == 0) {
        return;
    }
    _localTitle = localTitle;
    [self setTitle:[APPLanguageService wyhSearchContentWith:localTitle] forState:UIControlStateNormal];
}

@end
