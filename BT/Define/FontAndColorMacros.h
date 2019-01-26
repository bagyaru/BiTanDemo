//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//


//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h


#pragma mark -  间距区

//默认间距
#define KNormalSpace 12.0f

#pragma mark -  颜色区
//主题色 导航栏颜色
#define CNavBgColor isNightMode?[UIColor colorWithHexString:@"222229"] : [UIColor colorWithHexString:@"ffffff"]

#define CNavBgFontColor  [UIColor colorWithHexString:@"20212A"]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"ffffff"]

#define CWhiteColor  [UIColor colorWithHexString:@"ffffff"] //  [UIColor whiteColor]

#define CCommonRedColor [UIColor colorWithHexString:@"C52B18"]
//标题色
#define CBlackColor FirstColor

#define CGrayColor [UIColor colorWithHexString:@"ADADBD"]

#define CSearchBarColor [UIColor colorWithHexString:@"F2F2F2"]

#define CGraySecionColor [UIColor colorWithHexString:@"F9FBFC"]

#define CGBorderColor [UIColor colorWithHexString:@"6F6F6F"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"F4F4F4"]

#define CFillColor  [UIColor colorWithHexString:@"268AB7"]

#define CBlueColor [UIColor colorWithHexString:@"4E5896"]

#define CShowPriceColor [UIColor colorWithHexString:@"3C3D4B"]//3C3D4B

#define CTbarColor [UIColor colorWithHexString:@"#20212A"]

#define SeparateColor  (isNightMode?[UIColor colorWithHexString:@"363644"]:[UIColor colorWithHexString:@"dddddd"])

#define MainTextColor [UIColor colorWithHexString:@"151419"]

#define SecondTextColor [UIColor colorWithHexString:@"999999"]

#define LineColor [UIColor colorWithHexString:@"F4F4F4"]

#define TextColor [UIColor colorWithHexString:@"111210"]

#define CGreenBackgroundImage isRedRise?[UIImage imageNamed:@"redgradient.png"]:[UIImage imageNamed:@"greengradient.png"]

#define CRedBackgroundImage isRedRise?[UIImage imageNamed:@"greengradient.png"]:[UIImage imageNamed:@"redgradient.png"]

#define CRedColor    isRedRise?GreenBTColor:RedBTColor

#define CGreenColor isRedRise?RedBTColor:GreenBTColor
//涨时的绿色
#define CRiseColor  isRedRise?RedBTColor:GreenBTColor
//跌时的红色
#define CFallColor  isRedRise?GreenBTColor:RedBTColor
//不红不绿时的灰色
#define CNoChangeColor ThirdColor
//[UIColor colorWithHexString:@"AAAAAA"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]
//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]

#define CFontColor3 [UIColor colorWithHexString:@"323232"]

#define CFontColor4 [UIColor colorWithHexString:@"F4F5F7"]

#define CFontColor5 [UIColor colorWithHexString:@"344254"]

#define CFontColor6 [UIColor colorWithHexString:@"F9FBFC"]

#define CFontColor7 [UIColor colorWithHexString:@"F5f5f5"]

#define CFontColor8 [UIColor colorWithHexString:@"151419"]

#define CFontColor9 [UIColor colorWithHexString:@"F9F9F9"]

#define CFontColor10 [UIColor colorWithHexString:@"C52B18"]

#define CFontColor11 [UIColor colorWithHexString:@"999999"]

#define CFontColor12 [UIColor colorWithHexString:@"00AC1E"]

#define CFontColor13 [UIColor colorWithHexString:@"0174FF"]

#define CFontColor14 [UIColor colorWithHexString:@"4C4C4C"]

#define CFontColor15 [UIColor colorWithHexString:@"333333"]

#define CFontColor16 [UIColor colorWithHexString:@"666666"]

#pragma mark -  字体区

#define FONTOFSIZE(s) [UIFont systemFontOfSize:s]
#define LargeFont [UIFont systemFontOfSize:17.0f]

#define MediumFont [UIFont systemFontOfSize:15.0f]

#define BoldMediunFont [UIFont boldSystemFontOfSize:15.0f]

#define SmallFont [UIFont systemFontOfSize:12.0f]

#define LastSmallFont [UIFont systemFontOfSize:10.0f]

#define MainTextFont [UIFont systemFontOfSize:16.0f]

//字体名
#define PF_MEDIUM @"PingFangSC-Medium"
#define PF_REGULAR @"PingFangSC-Regular"


////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////模式切换 颜色定义
#define MainBg_Color [UIColor colorWithHexString:@"108ee9"] //主色调蓝

#define GreenDayColor [UIColor colorWithHexString:@"18C051"]
#define GreenNightColor [UIColor colorWithHexString:@"38B763"]
#define GreenBTColor (isNightMode?GreenNightColor:GreenDayColor)

#define RedDayColor [UIColor colorWithHexString:@"E63A1A"]
#define RedNightColor [UIColor colorWithHexString:@"E63F53"]
#define RedBTColor (isNightMode?RedNightColor:RedDayColor)

#define YellowColor [UIColor colorWithHexString:@"FF9800"] //辅助

#define FirstDayColor [UIColor colorWithHexString:@"333333"] //主要颜色
#define FirstNightColor [UIColor colorWithHexString:@"BACDE6"]
#define FirstColor (isNightMode?FirstNightColor:FirstDayColor)
#define SecondDayColor [UIColor colorWithHexString:@"666666"]//二级字体颜色
#define SecondNightColor [UIColor colorWithHexString:@"6B86A8"]
#define SecondColor (isNightMode?SecondNightColor:SecondDayColor)


#define ThirdDayColor [UIColor colorWithHexString:@"999999"]//字体辅助颜色
#define ThirdNightColor [UIColor colorWithHexString:@"576D87"]
#define ThirdColor (isNightMode?ThirdNightColor:ThirdDayColor)

#define SeparateLineDayColor [UIColor colorWithHexString:@"dddddd"]//
#define SeparateLineNightColor [UIColor colorWithHexString:@"363644"]

#define ViewBGDayColor [UIColor colorWithHexString:@"F5F5F5"]//页面背景
#define ViewBGNightColor [UIColor colorWithHexString:@"1A1A20"]
#define ViewBGColor (isNightMode?ViewBGNightColor:ViewBGDayColor)

#define ViewContentBgColor [UIColor colorWithHexString:@"222229"]

#define ArticleDayColor [UIColor colorWithHexString:@"4c4c4c"]//文章 快讯正文颜色
#define ArticleNightColor [UIColor colorWithHexString:@"89A4C7"]

#define TableViewCellNightColor [UIColor colorWithHexString:@"222229"]//cell的背景色
//borderColor

#define BtnDayBorderColor [UIColor colorWithHexString:@"E5E5E5"]//页面背景
#define BtnNightBorderColor [UIColor colorWithHexString:@"363644"]
#define BtnBorderColor (isNightMode?BtnNightBorderColor:BtnDayBorderColor)


#endif /* FontAndColorMacros_h */
