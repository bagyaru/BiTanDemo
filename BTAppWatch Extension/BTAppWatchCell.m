//
//  BTAppWatchCell.m
//  BTAppWatch Extension
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAppWatchCell.h"
#import <WatchKit/WatchKit.h>
#define CRedColor  [UIColor colorWithHexString:@"00AC1E"]

#define CGreenColor [UIColor colorWithHexString:@"C52B18"]
@interface BTAppWatchCell()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *szL;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *zdfL;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *enL;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *cnL;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *backColor;
@end
@implementation BTAppWatchCell
- (void)setCellContent:(BTAppWatchModel *)content {

    [self.szL setText:content.kind];
    if (content.rose <  0) {
        [self.zdfL setText:[NSString stringWithFormat:@"%@%%",@(content.rose).p2fString]];
    }else {
        [self.zdfL setText:[NSString stringWithFormat:@"+%@%%",@(content.rose).p2fString]];
    }
    if ([content.priceCNY doubleValue] > 1) {
        self.cnL.text =
        [NSString stringWithFormat:@"¥%@",@([content.priceCNY doubleValue]).p2fString];
    }else if([content.priceCNY doubleValue] < 1){
        self.cnL.text = [NSString stringWithFormat:@"¥%@",@([content.priceCNY doubleValue]).p8fString];
    }else{
        self.cnL.text = [NSString stringWithFormat:@"¥%@",content.priceCNY];
    }
    if ([content.priceUSD doubleValue] > 1) {
        self.enL.text =
        [NSString stringWithFormat:@"$%@",@([content.priceUSD doubleValue]).p2fString];
    }else if([content.priceUSD doubleValue] < 1){
        self.enL.text = [NSString stringWithFormat:@"$%@",@([content.priceUSD doubleValue]).p8fString];
    }else{
        self.enL.text = [NSString stringWithFormat:@"$%@",content.priceUSD];
    }
    
    //设置变动颜色
    switch (content.type) {
        case 0:
            //self.coinPriceL.textColor = CBlackColor;
            self.cnL.textColor = [UIColor whiteColor];
            self.enL.textColor = [UIColor whiteColor];
            
            break;
        case 1:
            //self.coinPriceL.textColor = CGreenColor;
            self.cnL.textColor = [UIColor colorWithRed:4/255.0 green:222/255.0 blue:113/255.0 alpha:1.0];
            self.enL.textColor = [UIColor colorWithRed:4/255.0 green:222/255.0 blue:113/255.0 alpha:1.0];
            //[self.backColor setBackgroundColor:[UIColor redColor]];
            break;
        case 2:
            //self.coinPriceL.textColor = CRedColor;
            self.cnL.textColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:48/255.0 alpha:1.0];
            self.enL.textColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:48/255.0 alpha:1.0];
            //[self.backColor setBackgroundColor:[UIColor redColor]];
            break;
            
        default:
            break;
    }
}
@end
