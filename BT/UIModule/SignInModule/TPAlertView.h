//
//  TPAlertView.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * AlertTypeNOTSign     未签到
 * AlertTypeSignSucc    签到成功
 * AlertTypeSignAward   连续签到获得奖励
 */
typedef NS_ENUM (NSInteger, AlertType){
    AlertTypeNOTSign = 0,
    AlertTypeSignSucc,
    AlertTypeSignAward
};

typedef void(^BtnClickBlock)(void);
@interface TPAlertView : UIView

@property (nonatomic,assign)AlertType alertType;
/**
 *
 *  type        签到类型
 *  day         连续签到第几天
 *  award       签到奖励
 *  btnBlock    点击按钮回调
 *
 */
+(void)showTPAlertView:(AlertType)type day:(NSInteger)day award:(NSInteger)award btnClick:(BtnClickBlock)btnBlock;

@end
