//
//  BTOneTPTargetView.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTOneTPTargetView.h"

@implementation BTOneTPTargetView

-(void)setModel:(TargetModel *)model {
    
    if (model) {
        _model = model;
    }
}
- (IBAction)goToVCBtnClcik:(UIButton *)sender {
    [MobClick event:@"tanli_task_rotation"];
    NSLog(@"%ld",_model.type);
    if (_model.type == 4) {
        [AnalysisService alaysisMine_invite];
        H5Node *node =[[H5Node alloc] init];
        node.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    }
    if (_model.type == 3 || _model.type == 6) {
        [getMainTabBar guideToInfomation];
    }
}

@end
