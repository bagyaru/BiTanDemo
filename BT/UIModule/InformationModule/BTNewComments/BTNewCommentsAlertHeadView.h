//
//  BTNewCommentsAlertHeadView.h
//  BT
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTNewCommentsAlertHeadView : BTView
@property (nonatomic,assign)NSInteger number;
@property (nonatomic, assign) BOOL isSearch;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
