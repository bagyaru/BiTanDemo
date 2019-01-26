//
//  BTPromptUpdateView.h
//  BT
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "THFVersionObj.h"
typedef void (^BTPromptUpdateViewCompletionBlock)(THFVersionObj*model);
@interface BTPromptUpdateView : BaseAlertView


@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *downView;

@property (nonatomic, copy) BTPromptUpdateViewCompletionBlock block;

@property (nonatomic, strong)THFVersionObj *model;

+ (void)showWithRecordModel:(THFVersionObj *)model completion:(BTPromptUpdateViewCompletionBlock)block;

@end
