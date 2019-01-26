//
//  BTLabel.m
//  BT
//
//  Created by vikey on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLabel.h"

@implementation BTLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFixText:(NSString *)fixText{
    if (fixText.length == 0) {
        return;
    }
    _fixText = fixText;
    self.text = [APPLanguageService sjhSearchContentWith:fixText];
}

- (void)setLocalText:(NSString *)localText{
    if (localText.length == 0) {
        return;
    }
    _localText = localText;
    self.text = [APPLanguageService wyhSearchContentWith:localText];
}
@end
