//
//  BYConditionBar.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    topViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4
} animateType;


@interface BYListBar : UIScrollView

@property (nonatomic,copy) void(^arrowChange)(void);
@property (nonatomic, assign) BOOL isNotGlobal;
@property (nonatomic, copy) NSString * exchangeCode;
@property (nonatomic,copy) void(^listBarItemClickBlock)(NSString *itemName , NSInteger itemIndex);
@property (nonatomic, assign)BOOL isFuture;
@property (nonatomic, assign)BOOL isSheQu;
@property (nonatomic, assign)BOOL isMessageCenter;
@property (nonatomic,strong) NSMutableArray *visibleItemList;
@property (nonatomic,strong) NSMutableArray *unreadNumList;

@property(nonatomic, assign) CGSize intrinsicContentSize;

-(void)operationFromBlock:(animateType)type itemName:(NSString *)itemName index:(int)index;
-(void)itemClickByScrollerWithIndex:(NSInteger)index;



@end
