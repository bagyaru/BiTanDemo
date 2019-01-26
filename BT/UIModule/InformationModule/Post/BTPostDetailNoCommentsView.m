//
//  BTPostDetailNoCommentsView.m
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostDetailNoCommentsView.h"

@implementation BTPostDetailNoCommentsView
-(void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.image = IMAGE_NAMED(@"我的帖子-评论为空");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
