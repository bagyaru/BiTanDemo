//
//  BTZFFBDetailSetionView.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTZFFBDetailSetionView.h"

@implementation BTZFFBDetailSetionView

-(void)setTotal:(NSInteger)total {
    
    if (total) {
        
        self.titleL.text = [NSString stringWithFormat:@"%@：%@%ld%@",[APPLanguageService wyhSearchContentWith:self.setion > 0 ? @"xiadie" : @"shangzhang"],[APPLanguageService wyhSearchContentWith:@"gong"],total,[APPLanguageService wyhSearchContentWith:@"ge"]];
    }
}

@end
