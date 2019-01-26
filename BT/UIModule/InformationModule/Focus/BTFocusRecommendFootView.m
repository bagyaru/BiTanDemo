//
//  BTFocusRecommendFootView.m
//  BT
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTFocusRecommendFootView.h"

@implementation BTFocusRecommendFootView


-(void)setRecommendIds:(NSMutableArray *)recommendIds {
    
    if (recommendIds) {
        _recommendIds = recommendIds;
    }
}
-(void)setIsFocusAll:(BOOL)isFocusAll {
    
    _isFocusAll = isFocusAll;
    if (isFocusAll) {
        self.labelAllRecommend.localText = @"quanbuquxiao";
        self.labelAllRecommend.textColor = ThirdColor;
        self.imageViewAllRecommend.image = IMAGE_NAMED(@"推荐关注加号");
    }else {
        
        self.labelAllRecommend.localText = @"quanbuguanzhu";
        self.labelAllRecommend.textColor = MainBg_Color;
        self.imageViewAllRecommend.image = IMAGE_NAMED(@"推荐关注全部关注");
    }
}
//换一批
- (IBAction)hypBtnClick:(UIButton *)sender {
    [MobClick event:@"guanzhu_tuijian_exchange"];
    if (self.inABatchBlock) {
        self.inABatchBlock();
    }
}
//全部关注
- (IBAction)recommendAllBtnClick:(UIButton *)sender {
    self.isFocusAll = !self.isFocusAll;
    if (self.isFocusAll) {
        [MobClick event:@"guanzhu_tuijian_allfollow"];
    }else {
        
        [MobClick event:@"guanzhu_tuijian_allunfollow"];
    }
    //到时候添加批量关注接口
    NSDictionary *dict = @{
                           @"userIds":self.recommendIds,
                           @"optType":self.isFocusAll ? @(1) : @(2)
                           };
    BTBatchFollowRequest *api = [[BTBatchFollowRequest alloc] initWithDict:dict];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (self.focusAllBlock) {
            self.focusAllBlock(self.isFocusAll);
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

@end
