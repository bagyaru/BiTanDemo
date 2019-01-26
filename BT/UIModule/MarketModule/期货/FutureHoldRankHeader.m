//
//  FutureHoldRankHeader.m
//  BT
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureHoldRankHeader.h"

@interface FutureHoldRankHeader()
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UILabel *centerL;
@property (weak, nonatomic) IBOutlet UILabel *rightL;

@end

@implementation FutureHoldRankHeader

- (void)setData:(NSArray *)data{
    _data = data;
    if(data){
        NSString *str1 = self.data[0];
        NSString *str2 = self.data[1];
        NSString *str3 = self.data[2];
        
        NSString *date1 = [str1 substringWithRange:NSMakeRange(5, 11)];
        NSString *date2 = [str2 substringWithRange:NSMakeRange(5, 11)];
        NSString *date3 = [str3 substringWithRange:NSMakeRange(5, 11)];
       
        self.leftL.text = date1;
        self.centerL.text = date2;
        self.rightL.text = date3;
    }
}

@end
