//
//  BTMainViewController.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTabBarController.h"
#import "BTNavigationViewController.h"
#import "UserCenterViewController.h"
#import "UIViewController+MKExtension.h"
@interface BTTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger  indexFlag;
@end

@implementation BTTabBarController

- (instancetype)init{
    self = [super init];
    if(self){
        [BTCMInstance setupBtNibObject: self];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad) name:NSNotification_SwitchLanguage object:nil];
    [UITabBar appearance].translucent = NO;
    [self.tabBar setBarTintColor:isNightMode?ViewContentBgColor:CWhiteColor];
    if(isNightMode){
        [self.tabBar setShadowImage:[[UIImage alloc]init]];
        [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
        self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.tabBar.layer.shadowOffset = CGSizeMake(0, -0);
        self.tabBar.layer.shadowOpacity = 0.31;
    }
}

- (void)createView{
    NSArray *arrVcs = @[@"home",@"quotes",@"infomation",@"DiscoveryMain",@"user"];
    NSArray *tabPageNames = @[@"home",@"quotes",@"infomation",@"market",@"user"];
    NSArray *tabbarName = @[[APPLanguageService wyhSearchContentWith:@"home"],[APPLanguageService sjhSearchContentWith:@"quotes"],[APPLanguageService sjhSearchContentWith:@"infomation"],[APPLanguageService wyhSearchContentWith:@"market"],[APPLanguageService wyhSearchContentWith:@"user"]];
    NSMutableArray *tabNavCtlrs = [NSMutableArray array];
    for (NSInteger i = 0; i < arrVcs.count; i++) {
        NSString *pageName = arrVcs[i];
        UIViewController *pageCtrl = [BTCMInstance viewControllerForName: pageName withParams: nil];
        if ([pageName isEqualToString:@"user"]) {
    
            pageCtrl = [UserCenterViewController create];
        }
        if (pageCtrl) {
            BTNavigationViewController *navCtrl = [[BTNavigationViewController alloc] initWithRootViewController: pageCtrl];
            navCtrl.navigationItem.title = tabbarName[i];
             NSString *imageName = [@"icon_tabbar_" stringByAppendingString:tabPageNames[i]];
            NSString *highImageNamge = [imageName stringByAppendingString: @"_high"];
            UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarName[i] image: [[UIImage imageNamed: imageName] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] selectedImage: [[UIImage imageNamed: highImageNamge] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainBg_Color} forState:UIControlStateSelected];
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:ThirdColor} forState:UIControlStateNormal];
            UIOffset offset = UIOffsetMake(0, -2);
            tabBarItem.titlePositionAdjustment = offset;
            navCtrl.tabBarItem = tabBarItem;
            [tabNavCtlrs addObject: navCtrl];
        }
    }
    self.viewControllers = tabNavCtlrs;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//回到首页
- (void)guideToHome {
    
    [self setSelectedIndex:0];
}
//回到行情
- (void)guideToQuotes {
    
    [self setSelectedIndex:1];
}
//回到社区
- (void)guideToInfomation {
    
    [self setSelectedIndex:2];
}
//回到发现
- (void)guideToDiscoveryMain {
    
    [self setSelectedIndex:3];
}
//回到我的
- (void)guideToUserCenter {
    
    [self setSelectedIndex:4];
}
#pragma mark - UITabBarControllerDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //放大效果，并回到原位
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        //速度控制函数，控制动画运行的节奏
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.duration = 0.5;       //执行时间
//        animation.repeatCount = 1;      //执行次数
//        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
//        animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
//        animation.toValue = [NSNumber numberWithFloat:3.0];     //结束伸缩倍数
//        [[arry[index] layer] addAnimation:animation forKey:nil];
        
        self.indexFlag = index;
    }
}
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
