//
//  CommentDetailFootView.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentDetailFootView.h"
#import "WBStatusComposeTextParser.h"
@interface CommentDetailFootView()<YYTextViewDelegate>
@property (nonatomic, strong) UIView *blackBackView;

@end

@implementation CommentDetailFootView{
    CGFloat  _keyboardHeight;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageViewEdit.image = IMAGE_NAMED(@"edit-74");
    _textV = [YYTextView new];
//    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textV.textContainerInset = UIEdgeInsetsMake(14, 5, 5, 5);
    _textV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textV.showsVerticalScrollIndicator = NO;
    _textV.alwaysBounceVertical = YES;
    _textV.allowsCopyAttributedString = NO;
    _textV.font = [UIFont systemFontOfSize:16];
    _textV.textColor = FirstColor;
    WBStatusComposeTextParser *textParser = [WBStatusComposeTextParser new];
    textParser.textColor =  FirstColor;
    textParser.highlightTextColor = MainBg_Color;
    _textV.textParser = textParser;
    _textV.delegate = self;
    _textV.inputAccessoryView = [UIView new];
    [self.bgView addSubview:self.textV];
    [_textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    NSString *placeholderPlainText = nil;
    placeholderPlainText = [APPLanguageService sjhSearchContentWith:@"fatieplaceholder"];
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = ThirdColor;
        atr.font = [UIFont systemFontOfSize:16];
        _textV.placeholderAttributedText = atr;
    }
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)setReplayContent:(NSString *)replayContent {
    
    self.textV.placeholderText = replayContent;
}

#pragma mark UITextViewDelegeta
-(void)textViewDidChange:(YYTextView*)textView {
    
//    self.placeL.hidden = self.textV.text.length > 0;
    [self.fasongBtn setTitleColor:self.textV.text.length > 0 ? MainBg_Color : ThirdColor forState:UIControlStateNormal];
    static CGFloat maxHeight = 73.0f;
    
    CGRect frame = textView.frame;
    
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    CGSize size = [textView sizeThatFits:constraintSize];
    
    NSLog(@"前======%.0f %.0f",size.height,frame.size.height);
    if (size.height >= maxHeight) {
        
        size.height = maxHeight;
        textView.scrollEnabled = YES;  // 允许滚动
        
    }else{
        
        textView.scrollEnabled = YES;    // 不允许滚动
    }
    NSLog(@"后======%.0f %.0f",size.height,frame.size.height);
    self.textV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    self.frame = CGRectMake(0, ScreenHeight-_keyboardHeight-50-(size.height-35), ScreenWidth, 15+size.height);
    if (textView == self.textV) {
        
        if ([self.textV.text length] > CommentsMaxLength) {
            self.textV.text = [self.textV.text substringWithRange:NSMakeRange(0, CommentsMaxLength)];
            [self.textV.undoManager removeAllActions];
            [self.textV becomeFirstResponder];
            return;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;
//    self.blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    self.frame = CGRectMake(0, ScreenHeight-height-50, ScreenWidth, 50);
//    if(!self.superview){
//        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    //    }
    YYTextView *textView = self.textV;
    if(textView.text.length >0){
        CGRect frame = textView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        
        CGSize size = [textView sizeThatFits:constraintSize];
        static CGFloat maxHeight = 73.0f;
        NSLog(@"前======%.0f %.0f",size.height,frame.size.height);
        if (size.height >= maxHeight) {
            size.height = maxHeight;
            textView.scrollEnabled = YES;  // 允许滚动
        }else{
            textView.scrollEnabled = YES;    // 不允许滚动
        }
        NSLog(@"后======%.0f %.0f",size.height,frame.size.height);
        self.textV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        self.frame = CGRectMake(0, ScreenHeight-_keyboardHeight-50-(size.height-35), ScreenWidth, 15+size.height);
    }
}
    

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    //获取键盘的高度
    NSLog(@"当键退出");
//    self.blackBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
//    [self.blackBackView removeFromSuperview];
//    [self removeFromSuperview];
//    [self.textV resignFirstResponder];
}


//- (void)keyboardWillHide:(NSNotification *)notification{
////    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
//
//    [self.blackBackView removeFromSuperview];
//    [self removeFromSuperview];
//    [self.textV resignFirstResponder];
//}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //输入@时候弹出选人页面
    if([text isEqualToString:@"@"]){
        [BTCMInstance pushViewControllerWithName:@"BTSelectPersonVC" andParams:nil completion:^(id obj) {
            NSString *str =(NSString*)obj;
            if(str.length == 0){
                [self.textV becomeFirstResponder];
            }else{
                [self.textV becomeFirstResponder];
                NSInteger index = self.textV.selectedRange.location;
                NSString *insertString = [NSString stringWithFormat:@"%@ ",obj];
                [self.textV replaceRange:self.textV.selectedTextRange withText:insertString];
                self.textV.selectedRange = NSMakeRange(index + insertString.length, 0);
            }
        }];
    }
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView *)blackBackView {
    
    if (!_blackBackView) {
        
        _blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _blackBackView.backgroundColor = [UIColor blackColor];
        _blackBackView.alpha = 0.5;
    }
    return _blackBackView;
}
@end
