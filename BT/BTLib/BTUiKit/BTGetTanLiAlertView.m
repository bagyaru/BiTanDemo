//
//  BTGetTanLiAlertView.m
//  BT
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGetTanLiAlertView.h"

@implementation BTGetTanLiAlertView

-(void)setDict:(NSDictionary *)dict {
    
    if (dict) {
        _dict = dict;
        self.label_TP.text = dict[@"tp"];
        self.titleL.text   = dict[@"name"];
        ViewRadius(self, 4);
    }
}

@end
