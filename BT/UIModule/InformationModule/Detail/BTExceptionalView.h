//
//  BTExceptionalView.h
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BTExceptionalCompletionBlock)(NSString *exceptional);
@interface BTExceptionalView : BaseAlertView
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *labelNub1;
@property (weak, nonatomic) IBOutlet UILabel *labelNub2;
@property (weak, nonatomic) IBOutlet UILabel *labelNub3;
@property (weak, nonatomic) IBOutlet UILabel *labelNub4;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;



@property (nonatomic, copy) BTExceptionalCompletionBlock block;
@property (nonatomic, assign) NSString *exceptionalNuber;
@property (nonatomic, copy) NSArray  *exceptionas;
+ (void)showWithRecordModel:(NSArray *)exceptionals completion:(BTExceptionalCompletionBlock)block;
@end

NS_ASSUME_NONNULL_END
