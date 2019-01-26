//
//  UIScrollView+ScrollToTop_Runtime.m
//  BT
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018 apple. All rights reserved.
//

#import "UIScrollView+ScrollToTop_Runtime.h"
#import <objc/runtime.h>
#import "ScrollToTopButton.h"
@implementation UIView (ScrollToTop_Runtime)

+ (void)load {
    Method ori_Method = class_getInstanceMethod([UIView class], @selector(didMoveToSuperview));

    Method ud_Mothod = class_getInstanceMethod([UIView class], @selector(ud_didMoveToSuperview));

    method_exchangeImplementations(ori_Method, ud_Mothod);
}

- (void)ud_didMoveToSuperview {
    [self ud_didMoveToSuperview];
    if (self.superview && ([self isMemberOfClass:[UITableView class]])) {
        //某些页面不需要加 置顶
        if(self.tag == 1100 || self.tag == 1101||self.tag == 1102||self.tag == 1103 ||self.tag == 1104||self.tag == 1105 ||self.tag == 1106||self.tag == 1107){
            
        }else{
            for (UIView *view in self.superview.subviews) {
                if ([view isKindOfClass:[ScrollToTopButton class]]) {
                    return;
                }
            }
            if(self.superview){
                ScrollToTopButton *scrollToTopBtn = [[ScrollToTopButton alloc] initWithFrame:CGRectZero scrollView:(UIScrollView *)self];
                [self.superview addSubview:scrollToTopBtn];
                CGFloat bottom = 49;
                if(self.superview.frame.size.height <= ScreenHeight  - kTabBarHeight){
                    bottom = 10;
                }
                [scrollToTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.superview).offset(-10);
                    make.bottom.equalTo(self).offset(-10);
                    make.width.height.mas_equalTo(48.0f);
                }];
            }
        }
        
    }
}

- (void)configToTop:(UIView_ToTop_Operation)block{
    ScrollToTopButton *btn;
    if (self.superview && ([self isMemberOfClass:[UITableView class]])) {
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[ScrollToTopButton class]]) {
                btn = (ScrollToTopButton*)view;
                break;
            }
        }
        btn.block = block;
    }
}

- (UIView_ToTop_Operation)toTopBlock{
    return [self bk_associatedValueForKey:UIView_block_parameters];
}

- (void)setToTopBlock:(UIView_ToTop_Operation)toTopBlock{
    [self bk_associateCopyOfValue:toTopBlock withKey:UIView_block_parameters];
}

@end
