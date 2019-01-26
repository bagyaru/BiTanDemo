//
//  QuotesSegment.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@class QuotesSegment;

typedef NS_ENUM(NSInteger,QuotesSegmentType) {
    QuotesSegmentTypeFenshi = 0,
    QuotesSegmentTypeRiLine = 10,
    QuotesSegmentTypeWeekLine = 11,
    QuotesSegmentTypeMonthLine = 12
};

typedef void(^SegmentBlock)(NSInteger segmentType,QuotesSegment * segment, BOOL isShowFenshiOption,BOOL isideAlpha);

typedef void(^FullScreenBlock)(void);

@interface QuotesSegment : BTView

@property (nonatomic, assign) QuotesSegmentType type;

@property (nonatomic, copy) SegmentBlock segmentBlock;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSString *fenshiTitle;
//指标标题
@property (nonatomic, strong) NSString *indexTitle;


@property (nonatomic, copy) FullScreenBlock fullScreenBlock;

@property (nonatomic, assign) BOOL isShowFullScreen;

@property (nonatomic, assign) BOOL isHideAlpha;

- (void)showInViewWith:(UIView *)parentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstr;

@end
