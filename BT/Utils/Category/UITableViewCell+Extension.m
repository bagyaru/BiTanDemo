//
//  UITableViewCell+Extension.m
//  BT
//
//  Created by apple on 2018/11/2.
//  Copyright © 2018 apple. All rights reserved.
//

#import "UITableViewCell+Extension.h"
#import "ZJUnFoldView.h"
#import "DVPieChart.h"
@implementation UITableViewCell (Extension)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(layoutSubviews);//原始方法
        SEL swizzledSelector = @selector(xdd_layoutSubViews);// 要替换的方法
        Method originalMethod = class_getInstanceMethod([UITableViewCell class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([UITableViewCell class], swizzledSelector);
        BOOL didAddMethod = class_addMethod([UITableViewCell class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod([UITableViewCell class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

//全局改变tableview的背景底色
- (void)xdd_layoutSubViews{
    [self xdd_layoutSubViews];
    if([self isKindOfClass:NSClassFromString(@"UIPickerTableViewWrapperCell")]) return;
    if([self isKindOfClass:NSClassFromString(@"AlertTableViewCell")]) return;
    if([self isKindOfClass:NSClassFromString(@"UIPickerTableViewTitledCell")]) return;
    
    self.backgroundColor = isNightMode? ViewContentBgColor :[UIColor whiteColor];
//    self.contentView.backgroundColor = isNightMode? ViewContentBgColor :[UIColor whiteColor];
    if ([self.contentView.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[self.contentView.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
        [self.contentView setBackgroundColor:ViewBGColor];
    }else{
        self.contentView.backgroundColor = isNightMode? ViewContentBgColor :[UIColor whiteColor];
    }
    for(UIView *view in self.contentView.subviews){
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
                            for (UIView *subsubsubView in subsubView.subviews){
                                [self setColorWithView:subsubsubView];
                            }
                        }
                        
                    }
                }else if([subView isKindOfClass:[UILabel class]]){
                    [self setColorWithView:subView];
                }else if([subView isKindOfClass:[UIButton class]]){
                    [self setColorWithView:subView];
                }
            }
            [self backgroundView_backColor:view];
        }else{//view 的子类
            // 单独处理一下，防止出现其他问题
            [self setColorWithView:view];
            if([view isKindOfClass:NSClassFromString(@"DVPieChart")]){
                view.backgroundColor = isNightMode? ViewContentBgColor :[UIColor whiteColor];
            }
        }
    }
}


- (void)setColorWithView:(UIView*)view{
    if([view isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel*)view;
        if([label isKindOfClass:NSClassFromString(@"ZJUnFoldLabel")]){
            
        }else{
            if([label.textColor.hexString isEqualToString:@"111210"] || [label.textColor.hexString isEqualToString:@"333333"]|| [label.textColor.hexString isEqualToString:@"151419"] || [label.textColor.hexString.uppercaseString isEqualToString:@"BACDE6"]){
                
                label.textColor = isNightMode ? FirstNightColor :FirstDayColor;
            }
            
            if([label.textColor.hexString isEqualToString:@"666666"]||[label.textColor.hexString.uppercaseString isEqualToString:@"6B86A8"]){
                label.textColor = isNightMode ? SecondNightColor :SecondDayColor;
                
            }
            if([label.textColor.hexString isEqualToString:@"999999"]||[label.textColor.hexString.uppercaseString isEqualToString:@"576D87"]){
                label.textColor = isNightMode ? ThirdNightColor :ThirdDayColor;
                
            }
            //自定义分割线处理
            if([label.backgroundColor.hexString isEqualToString:@"363644"]||[label.backgroundColor.hexString.uppercaseString isEqualToString:@"DDDDDD"]){
                
                label.backgroundColor = isNightMode ? SeparateLineNightColor :SeparateLineDayColor;
            }
            if([label.backgroundColor.hexString.uppercaseString isEqualToString:@"E4F4FF"]||[label.backgroundColor.hexString isEqualToString:@"363644"]){
                
                label.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"363644"] : [UIColor colorWithHexString:@"E4F4FF"];
                
            }
        }
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
    }
    
}

- (void)backgroundView_backColor:(UIView *)view {
    if (!CGColorEqualToColor(KClearColor.CGColor, view.backgroundColor.CGColor)) {
        if ([view.backgroundColor.hexString.uppercaseString isEqualToString:@"F5F5F5"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"1A1A20"] ) {
            view.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
        }else {
            if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"DDDDDD"]||[view.backgroundColor.hexString isEqualToString:@"363644"]){//分割线
                view.backgroundColor = SeparateColor;
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"E4F4FF"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"373C45"]){//关注边框
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"373C45"] : [UIColor colorWithHexString:@"E4F4FF"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"DDF1FF"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"81AECE"]){//快讯
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"81AECE"] : [UIColor colorWithHexString:@"DDF1FF"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"DDE1FF"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"9198CE"]){//要闻
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"9198CE"] : [UIColor colorWithHexString:@"DDE1FF"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"FFEDC5"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"D8C396"]){//奖励
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"D8C396"] : [UIColor colorWithHexString:@"FFEDC5"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"FFE4D9"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"CFA18E"]){//攻略
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"CFA18E"] : [UIColor colorWithHexString:@"FFE4D9"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"D5E3FF"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"A6B5D4"]){//讨论
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"A6B5D4"] : [UIColor colorWithHexString:@"D5E3FF"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"DDEDFF"]||[view.backgroundColor.hexString.uppercaseString isEqualToString:@"81AECF"]){//探报
                
                view.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"81AECF"] : [UIColor colorWithHexString:@"DDEDFF"];
                
            }else if([view.backgroundColor.hexString.uppercaseString isEqualToString:@"FF9800"]){
                
            }else{
                view.backgroundColor = isNightMode ? TableViewCellNightColor : [UIColor whiteColor];
            }
        }
    }
}

@end
