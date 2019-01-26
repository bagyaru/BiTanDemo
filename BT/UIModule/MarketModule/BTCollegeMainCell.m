//
//  BTCollegeMainCell.m
//  BT
//
//  Created by apple on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTCollegeMainCell.h"
#import "BTColleageItemView.h"
@interface BTCollegeMainCell()

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation BTCollegeMainCell

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
        BTColleageItemView *itemView = [BTColleageItemView loadFromXib];
        [itemView layoutIfNeeded];
        itemView.index = i;
        CGFloat w = 278;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"BTColleageVC" andParams:nil];
            [MobClick event:@"school"];
        }];
        [itemView addGestureRecognizer:tap];
        [itemView setTypes:titles[i]];
        itemView.frame = CGRectMake(self.maxWidth, 5, w, 100);
        //itemView.model = titles[i];
        [self.mScrollView addSubview:itemView];
        self.maxWidth += w + 12;
    }
    self.mScrollView.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    
}




@end
