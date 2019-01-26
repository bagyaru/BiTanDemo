//
//  BTRefreshHeader.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRefreshHeader.h"

@implementation BTRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare{
    [super prepare];
    // 设置普通状态的动画图片
   
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSInteger i = 0; i < 25; i++) {
        [idleImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loadingdown_%zd",i]]];
    }
    [self setImages:idleImages duration:idleImages.count*0.04 forState:MJRefreshStateIdle];
    
    NSMutableArray *PullingImages = [NSMutableArray array];
    UIImage* image = [UIImage imageNamed:@"Loadingdown_24"];
    [PullingImages addObject:image];
    [self setImages:PullingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 24; i < 49+24; i++) {
        if (i > 48) {
            
             [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loadingdown_%zd",i-48]]];
            
        }else {
            
            [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loadingdown_%zd",i]]];
        }
    }
    
    [self setImages:refreshingImages duration:refreshingImages.count*0.04 forState:MJRefreshStateRefreshing];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
//        [self setTitle:[APPLanguageService sjhSearchContentWith:@"xialashuaxin"] forState:MJRefreshStateIdle];
//        [self setTitle:[APPLanguageService sjhSearchContentWith:@"songkaishuanxin"] forState:MJRefreshStatePulling];
//        [self setTitle:[APPLanguageService sjhSearchContentWith:@"shuaxinzhong"] forState:MJRefreshStateRefreshing];
    }
    return self;
}

@end
