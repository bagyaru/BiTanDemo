//
//  CommentDetailFootView.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "YYKit.h"

@interface CommentDetailFootView : BTView <UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet BTButton *fasongBtn;
@property (weak, nonatomic) IBOutlet BTLabel *placeL;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEdit;

@property (strong, nonatomic) NSString *replayContent;
@property (strong, nonatomic) YYTextView *textV;


@end
