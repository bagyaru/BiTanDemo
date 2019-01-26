//
//  BTICOMainCell.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOMainCell.h"
#import "BTICOItemView.h"

@interface BTICOMainCell()

@property (nonatomic, assign) CGFloat maxWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end
@implementation BTICOMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemView:(NSArray*)arr{
    for(UIView *view in self.mScrollView.subviews){
        [view removeFromSuperview];
    }
    self.maxWidth = 15;
    NSArray *titles = arr;
    for(NSInteger i =0 ; i< titles.count ; i++){
        BTICOItemView *itemView = [BTICOItemView loadFromXib];
        itemView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            BTICOListModel *model = titles[i];
            [BTCMInstance pushViewControllerWithName:@"BTICODetailViewController" andParams:@{@"id":SAFESTRING(model.mID)}];
            [MobClick event:@"ico_rotation"];
        }];
        [itemView addGestureRecognizer:tap];
        itemView.model = titles[i];
        CGFloat w = 200;
        itemView.frame = CGRectMake(self.maxWidth, 5, w, 88.0f);
        [self.mScrollView addSubview:itemView];
        self.maxWidth += w + 12;
    }
    self.mScrollView.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
}

@end
