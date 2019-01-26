//
//  UIColor+Y_StockChart.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "UIColor+Y_StockChart.h"

@implementation UIColor (Y_StockChart)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor{
    return isNightMode?ViewContentBgColor: CWhiteColor;
}
#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor{
    return [UIColor whiteColor];
    return [UIColor colorWithRGBHex:0x1d2227];
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor{
    return CRedColor;
    return [UIColor colorWithRGBHex:0xff5353];
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor{
    return CGreenColor;
    
    return [UIColor colorWithRGBHex:0x00b07c];
}

#pragma mark 主文字颜色
+(UIColor *)mainTextColor{
    return [UIColor colorWithRGBHex:0x108ee9];
    //return [UIColor colorWithRGBHex:0x111210];
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor{
    return SecondColor;
//    return [UIColor colorWithRGBHex:0x777777];
}

#pragma mark 分时线下面的成交量线的颜色
+(UIColor *)timeLineVolumeLineColor{
    return [UIColor colorWithRGBHex:0x2d333a];
}

#pragma mark 分时线界面线的颜色
+(UIColor *)timeLineLineColor{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor{
    return kHEXCOLOR(0x6278A6);
}

+ (UIColor*)longKLineVerticalColor{
//    [UIColor col]
    return [[UIColor colorWithHexString:@"6583A6"] colorWithAlphaComponent:0.15];
    return kHEXCOLOR(0x99A7C5);
}

#pragma mark ma5的颜色
+(UIColor *)ma7Color
{
    return YellowColor;
    return [UIColor colorWithRGBHex:0xffc107];
}

+ (UIColor*)ma10Color{
    return RedBTColor;
    
    return [UIColor colorWithRGBHex:0xc52b18];
}

#pragma mark ma30颜色
+(UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0x108ee9];
}


#pragma mark BOLL_MB的颜色
+(UIColor *)BOLL_MBColor
{
    return [self ma7Color];
}

#pragma mark BOLL_UP的颜色
+(UIColor *)BOLL_UPColor
{
    return [self ma10Color];
   // return [UIColor purpleColor];
}

#pragma mark BOLL_DN的颜色
+(UIColor *)BOLL_DNColor
{
    return [self ma30Color];
    //return [UIColor greenColor];
}

+ (UIColor*)lineColor{
    return SeparateColor;
}
@end
