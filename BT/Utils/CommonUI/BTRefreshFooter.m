//
//  BTRefreshFooter.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRefreshFooter.h"

@implementation BTRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setTitle:[APPLanguageService sjhSearchContentWith:@"shanglajiazia"] forState:MJRefreshStateIdle];
        [self setTitle:[APPLanguageService sjhSearchContentWith:@"jiazaizhong"] forState:MJRefreshStateRefreshing];
        [self setTitle:[APPLanguageService sjhSearchContentWith:@"meiyougengduoshuju"] forState:MJRefreshStateNoMoreData];
    }
    return self;
}

@end
