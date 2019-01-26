//
//  InputAccessoryView.h
//  BT
//
//  Created by admin on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface InputAccessoryView : BTView

@property (weak, nonatomic) IBOutlet BTButton *cancellBtn;
@property (weak, nonatomic) IBOutlet BTButton *submitBtn;
@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
