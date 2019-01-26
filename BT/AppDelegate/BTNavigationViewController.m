//
//  BTNavigationViewController.m
//  BT
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNavigationViewController.h"

@interface BTNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BTNavigationViewController

//APP生命周期中 只会执行一次
//+ (void)initialize{
//    //导航栏主题 title文字属性
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    //导航栏背景图
////        [navBar setBackgroundImage:[UIImage imageNamed:@"tabBarBj"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setBarTintColor:CNavBgColor];
//    [navBar setTintColor:CNavBgFontColor];
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :CNavBgFontColor, NSFontAttributeName : [UIFont systemFontOfSize:16]}];
//    //CNavBgColor
//    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage imageWithColor:CLineColor size:CGSizeMake(ScreenWidth, 0.5)]];
//    //[navBar setShadowImage:[UIImage new]];//去掉阴影线
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏夜间模式
    UINavigationBar *navBar = self.navigationBar;
    //导航栏背景图
    //        [navBar setBackgroundImage:[UIImage imageNamed:@"tabBarBj"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setBarTintColor:CNavBgColor];
//    [navBar setTintColor:FirstColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :FirstColor, NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    //CNavBgColor
    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:SeparateColor size:CGSizeMake(ScreenWidth, 0.5)]];
    
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}

//根视图禁用右划返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (iPhoneX) {
        CGRect fra = self.tabBarController.tabBar.frame;
        if (fra.origin.y < ScreenHeight -  83) {
            fra.origin.y = ScreenHeight - 83;
            self.tabBarController.tabBar.frame = fra;
            UIOffset offset = UIOffsetMake(0, -5);
            self.tabBarController.tabBarItem.titlePositionAdjustment = offset;
        }
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    //如果在UITableViewCell上就关闭
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO; //返回NO 表示 系统左滑返回失效
//    }
//    return  YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
