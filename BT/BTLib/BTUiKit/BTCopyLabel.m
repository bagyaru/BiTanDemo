//
//  BTCopyLabel.m
//  BT
//
//  Created by admin on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCopyLabel.h"
#import "UILabel+YBAttributeTextTapAction.h"
@implementation BTCopyLabel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self pressAction];
    [self touchUpSelector];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pressAction];
        [self touchUpSelector];
    }
    return self;
}

-(void)setChild_ID:(NSString *)child_ID {
    
    if (child_ID.length == 0) {
        return;
    }
    
    _child_ID = child_ID;
}
-(void)setSuper_ID:(NSString *)super_ID {
    
    if (super_ID.length == 0) {
        return;
    }
    _super_ID = super_ID;
}
-(void)setUserName:(NSString *)userName {
    
    if (userName.length == 0) {
        return;
    }
    _userName = userName;
}
// 初始化设置 长按事件
- (void)pressAction {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [self addGestureRecognizer:longPress];
}
// 点击事件
-(void)touchUpSelector {
//   self.userInteractionEnabled=YES;
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
//    [self addGestureRecognizer:labelTapGestureRecognizer];
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}
//复制
- (void)customCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    self.backgroundColor = KClearColor;
}
//长按 弹出
- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    self.backgroundColor = SeparateColor;
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"fuzhi"] action:@selector(customCopy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
}
-(void)WillHideMenu:(id)sender {
    self.backgroundColor = KClearColor;
}
//点击 事件
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    NSLog(@"%@被点击了id==%@",label.text,self.child_ID);
    if (self.copyBlock) {
        self.copyBlock(self.child_ID,self.userName);
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    BOOL isTouche = [self yb_getTapFrameWithTouchPoint:point result:nil];
    if (!isTouche) {
        if (self.copyBlock) {
            self.copyBlock(self.child_ID,self.userName);
        }
    }
}
@end
