//
//  BTCandyMainCell.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyMainCell.h"
#import "BTCandyItemView.h"

@interface BTCandyMainCell()

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation BTCandyMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mScrollView.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
}

- (void)setItemView:(NSArray*)arr{
    for(UIView *view in self.mScrollView.subviews){
        [view removeFromSuperview];
    }
    self.maxWidth = 15;
    NSArray *titles = arr;
    for(NSInteger i = 0 ; i< titles.count ; i++){
        BTCandyItemView *itemView = [BTCandyItemView loadFromXib];
        [itemView layoutIfNeeded];
        CGFloat w = 200;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            FastInfomationObj *model = titles[i];
            [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.infoID,
                                                                                      @"whereVC":@"tg"
                                                                                      }];
            [MobClick event:@"candy_rotation"];
        }];
        [itemView addGestureRecognizer:tap];
        itemView.frame = CGRectMake(self.maxWidth, 5, w, 167.0f +40.0f);
        itemView.model = titles[i];
        [self.mScrollView addSubview:itemView];
        self.maxWidth += w + 12;
    }
    self.mScrollView.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    
}
@end
