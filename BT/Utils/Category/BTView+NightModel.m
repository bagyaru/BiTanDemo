//
//  BTView+NightModel.m
//  BT
//
//  Created by admin on 2018/11/2.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTView+NightModel.h"

@implementation BTView (NightModel)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(layoutSubviews);//原始方法
        SEL swizzledSelector = @selector(xdd_layoutSubViews);// 要替换的方法
        Method originalMethod = class_getInstanceMethod([BTView class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([BTView class], swizzledSelector);
        BOOL didAddMethod = class_addMethod([BTView class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod([BTView class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}
//全局改变BTView夜间模式
- (void)xdd_layoutSubViews{
    [self xdd_layoutSubViews];
    [self backgroundView_backColor:self];
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [self setColorWithView:view];
            
        }else if([view isMemberOfClass:[UIView class]]){
            for (UIView *subView in view.subviews){
                if([subView isKindOfClass:NSClassFromString(@"ZJUnFoldView")]){
                    [self backgroundView_backColor:subView];
                    for (UIView *subsubView in subView.subviews){
                        [self setColorWithView:subsubView];
                    }
                    
                }else if([subView isMemberOfClass:[UIView class]]){
                    [self backgroundView_backColor:subView];
                    for (UIView *subsubView in subView.subviews){
                        [self setColorWithView:subsubView];
                        if([subsubView isMemberOfClass:[UIView class]]){
                            [self backgroundView_backColor:subsubView];
                        }
                        
                    }
                    
                }else if([subView isKindOfClass:[UILabel class]]){
                    [self setColorWithView:subView];
                }else {
                    
                    [self setColorWithView:subView];
                }
                
            }
            [self backgroundView_backColor:view];
        }else{// 针对button textField  等
            [self setColorWithView:view];
        }
    }
}


- (void)setColorWithView:(UIView*)view{
    if([view isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel*)view;
        if([label isKindOfClass:NSClassFromString(@"ZJUnFoldLabel")]){
            
            
        }else{
            if([label.textColor.hexString isEqualToString:@"111210"] || [label.textColor.hexString isEqualToString:@"333333"]|| [label.textColor.hexString isEqualToString:@"151419"]|| [label.textColor.hexString.uppercaseString isEqualToString:@"BACDE6"]){
                if (label.tag != 87541512) {
                   label.textColor = FirstColor;
                }
            }
            
            if([label.textColor.hexString isEqualToString:@"666666"]||[label.textColor.hexString.uppercaseString isEqualToString:@"6B86A8"]){
                label.textColor = SecondColor;
                
            }
            if([label.textColor.hexString isEqualToString:@"999999"]||[label.textColor.hexString.uppercaseString isEqualToString:@"576D87"]){
                
                if(label.tag == 11111){
                    
                }else{
                    if (label.tag != 87541510 && label.tag != 87541511) {
                        label.textColor = ThirdColor;
                    }
                }
                
            }
            //自定义分割线处理
            if([label.backgroundColor.hexString isEqualToString:@"363644"]||[label.backgroundColor.hexString.uppercaseString isEqualToString:@"DDDDDD"]){
                
                label.backgroundColor = SeparateColor;
                
            }
            if ([label.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[label.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
                label.backgroundColor = ViewBGColor;
            }
            
        }
        
    }else if([view isMemberOfClass:[UIView class]]){
        [self backgroundView_backColor:view];
        
    }else if([view isKindOfClass:[UIButton class]]){
        UIButton *btn = (UIButton*)view;
        if([btn.titleLabel.textColor.hexString isEqualToString:@"111210"] || [btn.titleLabel.textColor.hexString isEqualToString:@"333333"]|| [btn.titleLabel.textColor.hexString isEqualToString:@"151419"] || [btn.titleLabel.textColor.hexString.uppercaseString isEqualToString:@"BACDE6"]){
            [btn setTitleColor:FirstColor forState:UIControlStateNormal];
        }
        if([btn.titleLabel.textColor.hexString isEqualToString:@"666666"]||[btn.titleLabel.textColor.hexString.uppercaseString isEqualToString:@"6B86A8"]){
            [btn setTitleColor:SecondColor forState:UIControlStateNormal];
        }
        if([btn.titleLabel.textColor.hexString isEqualToString:@"999999"]||[btn.titleLabel.textColor.hexString.uppercaseString isEqualToString:@"576D87"]){
            [btn setTitleColor:ThirdColor forState:UIControlStateNormal];
        }
        if ([btn.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[btn.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
            [btn setBackgroundColor:ViewBGColor];
        }
        
    }else if([view isKindOfClass:[UITextField class]]){
        
        UITextField *textField = (UITextField*)view;
        if([textField.textColor.hexString isEqualToString:@"111210"] || [textField.textColor.hexString isEqualToString:@"333333"]|| [textField.textColor.hexString isEqualToString:@"151419"] || [textField.textColor.hexString.uppercaseString isEqualToString:@"BACDE6"]){
            textField.textColor = FirstColor;
        }
        if([textField.textColor.hexString isEqualToString:@"666666"]||[textField.textColor.hexString.uppercaseString isEqualToString:@"6B86A8"]){
            textField.textColor = SecondColor;
        }
        if([textField.textColor.hexString isEqualToString:@"999999"]||[textField.textColor.hexString.uppercaseString isEqualToString:@"576D87"]){
            textField.textColor = ThirdColor;
        }
        if ([textField.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[textField.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
            textField.backgroundColor = ViewBGColor;
        }
        [textField setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
        
    }else if([view isKindOfClass:[UITextView class]]){
        UITextView *textView= (UITextView*)view;
        if([textView.textColor.hexString isEqualToString:@"111210"] || [textView.textColor.hexString isEqualToString:@"333333"]|| [textView.textColor.hexString isEqualToString:@"151419"] || [textView.textColor.hexString.uppercaseString isEqualToString:@"BACDE6"]){
            textView.textColor = FirstColor;
        }
        if([textView.textColor.hexString isEqualToString:@"666666"]||[textView.textColor.hexString.uppercaseString isEqualToString:@"6B86A8"]){
            textView.textColor = SecondColor;
        }
        
        textView.backgroundColor = isNightMode ?ViewContentBgColor :CWhiteColor;
    }
    
}

-(void)backgroundView_backColor:(UIView *)view {
    //主色调不变
    if ([view.backgroundColor.hexString.uppercaseString isEqualToString:@"108EE9"]){
        return;
    }
    if (!CGColorEqualToColor(KClearColor.CGColor, view.backgroundColor.CGColor)) {
        if ([view.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
            view.backgroundColor = ViewBGColor;
        }else {
            if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"DDDDDD"]||[view.backgroundColor.hexString isEqualToString:@"363644"]){
                view.backgroundColor = SeparateColor;
            }else{
                view.backgroundColor = isNightMode ? TableViewCellNightColor : CWhiteColor;
            }
        }
    }
}
    
@end
