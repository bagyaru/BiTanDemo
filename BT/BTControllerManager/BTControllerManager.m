//
//  BTControllerManager.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTControllerManager.h"
#import "BTViewControllerSetting.h"
#import "BTTabBarController.h"
#import "BTNavigationViewController.h"

@interface BTControllerManager ()

@property (nonatomic, copy) NSDictionary *ctrlDict;//控制器路由

@property (nonatomic, strong) UITabBarController *rootTabBarCtrl;

@property (nonatomic, strong) UINavigationController  *presentNavCtrl;

@end

@implementation BTControllerManager

+ (instancetype)sharedManager{
    static BTControllerManager *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];;
    });
    
    return sInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.ctrlDict = BTViewControllerMap();
    }
    return self;
}

#pragma mark - first page

- (void)setupBtNibObject: (BTTabBarController *)ctrl{
    if (self.rootTabBarCtrl == nil) {
        self.rootTabBarCtrl = ctrl;
    }
}


- (void)pushViewControllerWithName:(NSString *)name andParams:(NSDictionary *)params completion:(UIViewController_block_returnParameters)completion{
    if ([self fixedRootingForName: name]) {
        return;
    }
    UIViewController *ctrl = [self viewControllerForName: name withParams: params];
    [ctrl bk_associateCopyOfValue:completion withKey:UIViewController_block_parameters];
    ctrl.hidesBottomBarWhenPushed = YES;
    if (ctrl) {
        [self pushViewController: ctrl];
    }
}

- (void)pushViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params{
    if ([self fixedRootingForName: name]) {
        return;
    }
    UIViewController *ctrl = [self viewControllerForName: name withParams: params];
    ctrl.hidesBottomBarWhenPushed = YES;
    if (ctrl) {
        [self pushViewController: ctrl];
    }
}

- (BOOL)fixedRootingForName:(NSString *)fixedName{
    //检查是否为tabbar最前页
    if([fixedName isEqualToString:BTHomeCtrl]){
        [self home];
        return YES;
    }
    return NO;
}

- (void)home{
    [self tabRootAtIndex: 0];
}

- (void)tabRootAtIndex: (NSInteger)index{
    self.rootTabBarCtrl.selectedIndex = index;
    [self tabRoot];
}

- (UIViewController*)topViewController{
    UINavigationController *navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
    return navCtrl.viewControllers.firstObject;
}

- (void)tabRoot{
    UINavigationController *navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
    [navCtrl popToRootViewControllerAnimated: YES];
}

- (void)pushViewController:(id)ctrl{
    [self pushViewController: ctrl animated: YES];
}

- (void)popViewController:(id)ctrl{
    [self popViewController:ctrl animated:YES];
}
-(void)popRootViewController:(id)ctrl {
    
    [self popRootViewController:ctrl animated:YES];
}
- (void)pushViewController:(id)ctrl animated:(BOOL)animated{
    if (self.presentNavCtrl) {
        [self.presentNavCtrl pushViewController: ctrl animated: animated];
    }else{
        UINavigationController *navCtrl = (UINavigationController *)self.rootTabBarCtrl.selectedViewController;
        [navCtrl pushViewController: ctrl animated: YES];
    }
}

- (void)popViewController:(id)ctrl animated: (BOOL)animated{
    UINavigationController *navCtrl = nil;
    if (self.presentNavCtrl) {
        navCtrl = self.presentNavCtrl;
    }else{
        navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
    }
    if (ctrl == nil) {
        [navCtrl popViewControllerAnimated: animated];
    }else{
        [navCtrl popToViewController: ctrl animated: animated];
    }
}
- (void)popRootViewController:(id)ctrl animated: (BOOL)animated{
    UINavigationController *navCtrl = nil;
    if (self.presentNavCtrl) {
        navCtrl = self.presentNavCtrl;
    }else{
        navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
    }
    if (ctrl == nil) {
        [navCtrl popToRootViewControllerAnimated: animated];
    }else{
        [navCtrl popToViewController: ctrl animated: animated];
    }
}
- (id)instanceWithControllerName: (NSString *)name{
    Class ctrlClass = [self classForControllerName: name];
    return [self instanceWithClassName: ctrlClass];
}

- (void)popViewControllerToClass: (Class)ctrlClass animated: (BOOL)animated{
    id foundCtrl = [self instanceWithClassName: ctrlClass];
    if (foundCtrl) {
        UINavigationController *navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
        [navCtrl popToViewController: foundCtrl animated: animated];
    }
}

- (void)popViewControllerToControllerName: (NSString *)ctrlName params:(NSDictionary *)params animated: (BOOL)animated{
    Class ctrlClass = [self classForControllerName: ctrlName];
    if ([(NSObject *)ctrlClass respondsToSelector:@selector(popWithParams:)]) {
        [ctrlClass popWithParams:params];
    }
    [self popViewControllerToClass: ctrlClass animated: animated];
}

- (id)instanceWithClassName: (Class)ctrlClass{
    if (ctrlClass) {
        UINavigationController *navCtrl = self.rootTabBarCtrl.viewControllers[self.rootTabBarCtrl.selectedIndex];
        UIViewController *foundCtrl = nil;
        for (UIViewController *current in navCtrl.viewControllers) {
            if (current.class == ctrlClass) {
                foundCtrl = current;
                break;
            }
        }
        return foundCtrl;
    }
    return nil;
}

- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params{
    UIViewController *ctrl = [self viewControllerForName: name withParams: params];
    
    if (ctrl) {
        UINavigationController *navCtrl = [[BTNavigationViewController alloc] initWithRootViewController: ctrl];
        [self presentViewController: navCtrl];
    }
}

- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params animated:(BOOL)animated{
    UIViewController *ctrl = [self viewControllerForName: name withParams: params];
    
    if (ctrl) {
        UINavigationController *navCtrl = [[BTNavigationViewController alloc] initWithRootViewController: ctrl];
        [self presentViewController: navCtrl animated:animated];
    }
}

- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params animated:(BOOL)animated ompletion:(UIViewController_block_returnParameters)completion{
    UIViewController *ctrl = [self viewControllerForName: name withParams: params];
    [ctrl bk_associateCopyOfValue:completion withKey:UIViewController_block_parameters];
    if (ctrl) {
        UINavigationController *navCtrl = [[BTNavigationViewController alloc] initWithRootViewController: ctrl];
        [self presentViewController: navCtrl animated:animated];
    }
    
    
}
- (void)presentViewController:(id)ctrl animated:(BOOL)animated{
    void (^presentBlock)(void) = ^(){
        self.presentNavCtrl = ctrl;
        [self.rootTabBarCtrl presentViewController: ctrl animated: animated completion: nil];
    };
    
    if (self.presentNavCtrl != nil) {
//        [self.presentNavCtrl presentViewController: ctrl animated: animated completion: nil];
        [self.rootTabBarCtrl dismissViewControllerAnimated: animated completion: presentBlock];
    }else{
        presentBlock();
    }
}

- (void)presentViewController: (id)ctrl{
    void (^presentBlock)(void) = ^(){
        self.presentNavCtrl = ctrl;
        [self.rootTabBarCtrl presentViewController: ctrl animated: YES completion: nil];
    };
    
    if (self.presentNavCtrl != nil) {
        [self.rootTabBarCtrl dismissViewControllerAnimated: YES completion: presentBlock];
    }else{
        presentBlock();
    }
}


- (void)dismissViewControllerComplete: (void(^)(void))complete{
    if (self.presentNavCtrl) {
        [self.rootTabBarCtrl dismissViewControllerAnimated: YES completion: complete];
        self.presentNavCtrl = nil;
    }
}

- (void)dismissViewController{
    [self dismissViewControllerComplete: nil];
}

#pragma mark - factory

- (UIViewController *)viewControllerForName: (NSString *)name withParams: (NSDictionary *)params{
    Class ctrlClass = [self classForControllerName: name];
    if (ctrlClass == nil) {
        return nil;
    }
    UIViewController *controller = nil;
    if ([(NSObject *)ctrlClass respondsToSelector: @selector(createWithParams:)]) {
        controller = [ctrlClass createWithParams: params];
        [controller bk_associateValue:params withKey:UIViewController_key_parameters];
    }else{
        controller = [[ctrlClass alloc] init];
        //不用实现的那么麻烦
        [controller bk_associateValue:params withKey:UIViewController_key_parameters];
    }
    return controller;
}

- (Class)classForControllerName: (NSString *)ctrlName{
    NSString *ctrlClassName = self.ctrlDict[ctrlName];
    Class ctrlClass = NSClassFromString(ctrlClassName);
    if (ctrlClass == nil) {
        ctrlClass = NSClassFromString(ctrlName);
    }
    return ctrlClass;
}


@end
