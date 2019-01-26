//
//  RootViewController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "UIViewController+AlertViewAndActionSheet.h"
#import "MessageView.h"

/**
 VC 基类
 */
@interface RootViewController : UIViewController

@property (nonatomic, strong) id parameters; // 参数
@property (nonatomic,copy) UIViewController_block_returnParameters returnParamsBlock;

//未读消息view
@property (nonatomic,strong) MessageView* messageV;

//头像＋v
@property (nonatomic,strong) NSString *photoV;
//头像＋v
@property (nonatomic,assign) NSInteger authStatus;
//头像＋v
@property (nonatomic,assign) NSInteger authType;

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;


/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 导航栏添加文本按钮

 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags whereVC:(NSString *)vc;

/**
 导航栏添加图标按钮

 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;
/**
 导航栏添加消息View
 
 @param imageName 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tag tag数组 回调区分用
 */
- (void)addNavigationItemViewWithImageNames:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger )tag;
/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;



@end
