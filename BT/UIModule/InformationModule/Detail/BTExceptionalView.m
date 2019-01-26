//
//  BTExceptionalView.m
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExceptionalView.h"

@implementation BTExceptionalView

+ (void)showWithRecordModel:(NSArray *)exceptionals completion:(BTExceptionalCompletionBlock)block {
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTExceptionalView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    alertView.layer.cornerRadius =4.0f;
    alertView.layer.masksToBounds = YES;
    alertView.block = block;
    alertView.exceptionas = exceptionals;
    NSArray *viewArray = @[alertView.view1,alertView.view2,alertView.view3,alertView.view4];
    NSArray *labelArray = @[alertView.labelNub1,alertView.labelNub2,alertView.labelNub3,alertView.labelNub4];
    NSArray *buttonArray = @[alertView.button1,alertView.button2,alertView.button3,alertView.button4];
    for (int i = 0; i < viewArray.count; i++) {
        UIView  *view    = viewArray[i];
        UILabel *label   = labelArray[i];
        UIButton *button = buttonArray[i];
        label.text       = [NSString stringWithFormat:@"%@TP",exceptionals[i]];
        button.tag       = 100+i;
        ViewBorderRadius(view, 2, 1, kHEXCOLOR(0xDDDDDD));
        if (i == 0) {
            button.selected = YES;
            label.textColor = KWhiteColor;
            view.backgroundColor = MainBg_Color;
            alertView.exceptionalNuber = exceptionals[i];
            ViewBorderRadius(view, 2, 0, kHEXCOLOR(0x108EE9));
            //ViewBorderRadius(view, 2, 1, kHEXCOLOR(0x108EE9));
        }
    }
    
    [alertView show];
}

+ (CGRect)frameOfAlert{
    CGFloat width = 300;
    return CGRectMake(0, 0, width, 282);
}

- (IBAction)dashangBtnClick:(UIButton *)sender {
    
    NSArray *viewArray = @[self.view1,self.view2,self.view3,self.view4];
    NSArray *labelArray = @[self.labelNub1,self.labelNub2,self.labelNub3,self.labelNub4];
    NSArray *buttonArray = @[self.button1,self.button2,self.button3,self.button4];
    
    for (int i = 0; i < buttonArray.count; i++) {
        
        UIView   *view    = viewArray[i];
        UILabel  *label   = labelArray[i];
        UIButton *button  = buttonArray[i];
        if (i == sender.tag - 100) {//说明现在被选中的
           
            button.selected   = !button.selected;
            if (button.selected) {//代表被选中
              
                self.exceptionalNuber = self.exceptionas[i];
                label.textColor = KWhiteColor;
                view.backgroundColor = MainBg_Color;
                ViewBorderRadius(view, 2, 0, kHEXCOLOR(0x108EE9));
//                label.textColor = kHEXCOLOR(0x108EE9);
//                ViewBorderRadius(view, 2, 1, kHEXCOLOR(0x108EE9));
            }else {
                
                self.exceptionalNuber = @"";
                label.textColor = SecondDayColor;
                view.backgroundColor = KWhiteColor;
                ViewBorderRadius(view, 2, 1, kHEXCOLOR(0xDDDDDD));
//                label.textColor = kHEXCOLOR(0x333333);
//                ViewBorderRadius(view, 2, 1, kHEXCOLOR(0xDDDDDD));
            }
        }else {
            button.selected   = NO;
            label.textColor = SecondDayColor;
            view.backgroundColor = KWhiteColor;
            ViewBorderRadius(view, 2, 1, kHEXCOLOR(0xDDDDDD));
        }
    }
    
}


- (IBAction)cancel:(id)sender {
    [self __hide];
}
- (IBAction)confirm:(id)sender {

    if (ISNSStringValid(self.exceptionalNuber)) {
        [self __hide];
        if (self.block) {
            self.block(self.exceptionalNuber);
        }
    }else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"qingxuanzedashangshuliang"] wait:YES];
    }
    
}
@end
