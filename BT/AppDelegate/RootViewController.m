//
//  RootViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "BTBitaneIndexModel.h"
#import "BTZFFFModel.h"
#import "BTRecordModel.h"
#import "BTExchangeListModel.h"
@interface RootViewController ()

@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation RootViewController

//获取上个页面传过来的参数
-(id)parameters{
    id object = objc_getAssociatedObject(self, UIViewController_key_parameters);
    return object;
}

- (UIViewController_block_returnParameters)returnParamsBlock{
    return [self bk_associatedValueForKey:UIViewController_block_parameters];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return _StatusBarStyle;
//}
//
////动态更新状态栏颜色
//-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
//    _StatusBarStyle=StatusBarStyle;
//    [self setNeedsStatusBarAppearanceUpdate];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
    NSLog(@"%@",[self parameters]);
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
//    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLayoutSubviews{

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self recordHistoryVCNameAndParameter];//记录当前页面的类名和参数
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    if (isNightMode) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self removeHistoryVCNameAndParameter];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
//     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)showLoadingAnimation{
   
}

- (void)stopLoadingAnimation{
   
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}


/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"back"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked{
//    if (self.presentingViewController) {
//        [BTCMInstance dismissViewController];
//    }else{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_loginSuccess
                                                  object:nil];
    [BTCMInstance popViewController:nil];
//    }
}


#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView   *photoView = [[UIView alloc] init];
        if ([imageName hasPrefix:@"http"]) {
            
            [btn setImage:[self getImageFromURL:imageName] forState:UIControlStateNormal];
            ViewRadius(btn.imageView, 15);
        }else {
            if (ISStringEqualToString(imageName, @"morentouxiang")) {
                [btn setImage:[self getNewImageFromImage:IMAGE_NAMED(imageName)] forState:UIControlStateNormal];
            }else {
                [btn setImage:IMAGE_NAMED(imageName) forState:UIControlStateNormal];
            }
            
        }
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        }
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] init];
        if ([imageName hasPrefix:@"http"] || ISStringEqualToString(imageName, @"morentouxiang")) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            photoView.frame = CGRectMake(0, 0, 30, 30);
            [photoView addSubview:btn];
            [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:imageName andImageView:btn.imageView andAuthStatus:self.authStatus andAuthType:self.authType addSuperView:photoView];
            item.customView = photoView;
        }else {
         
            item.customView = btn;
        }
        //UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}
-(UIImage *)getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, scale);
    [result drawInRect:CGRectMake(0,0,30,30)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage *)getNewImageFromImage:(UIImage *)im {
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, scale);
    [im drawInRect:CGRectMake(0,0,30,30)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags whereVC:(NSString *)vc
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        if (ISStringEqualToString(vc, @"资讯")) {
            
            btn.titleLabel.font = FONT(@"PingFangSC-Medium", 20);
            [btn setTitleColor:ThirdColor forState:UIControlStateNormal];
            
        }else if (ISStringEqualToString(vc, @"我的竞猜")){
            
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:ThirdColor forState:UIControlStateNormal];
        }else if (ISStringEqualToString(vc, @"我的探力")){
            
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        }else {
            
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:FirstColor forState:UIControlStateNormal];
        }
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    //return buttonArray;
}
/**
 导航栏添加消息View
 
 @param imageName 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tag tags数组 回调区分用
 */
- (void)addNavigationItemViewWithImageNames:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tag:(NSInteger )tag
{
  
    self.messageV.imageIV.image = [UIImage imageNamed:imageName];
    [self.messageV.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.messageV.btn .tag = tag;
    ViewRadius(self.messageV.numBerL, 6);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.messageV];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    // 是否支持旋转
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
-(MessageView *)messageV {
    
    if (!_messageV) {
        
        _messageV = [MessageView loadFromXib];
        _messageV.frame = CGRectMake(0, 0, 40, 40);
        
    }
    return _messageV;
}
-(void)removeHistoryVCNameAndParameter {
    
    
    NSString *self_className = NSStringFromClass([self class]);
    if (ISStringEqualToString(self_className, @"QuotesDetailViewController")||ISStringEqualToString(self_className, @"H5InfomationDetailViewController")||ISStringEqualToString(self_className, @"BTExchangeContainerVC")||ISStringEqualToString(self_className, @"QiHuoListViewController")||ISStringEqualToString(self_className, @"TopicViewController")||ISStringEqualToString(self_className, @"BTPostDetailViewController")) {
        
        [UserDefaults removeObjectForKey:BTClassName];
        [UserDefaults removeObjectForKey:BTClassParameters];
    }
}
-(void)recordHistoryVCNameAndParameter {
    
    NSString *self_className = NSStringFromClass([self class]);
    if (!ISStringEqualToString(self_className, @"HomeViewController")) {
         [UserDefaults setInteger:getMainTabBar.selectedIndex forKey:BTGetMainTabBarSelectedIndex];
    }
    if (ISStringEqualToString(self_className, @"QuotesDetailViewController")||ISStringEqualToString(self_className, @"H5InfomationDetailViewController")||ISStringEqualToString(self_className, @"BTExchangeContainerVC")||ISStringEqualToString(self_className, @"QiHuoListViewController")||ISStringEqualToString(self_className, @"TopicViewController")||ISStringEqualToString(self_className, @"BTPostDetailViewController")) {
        
        if (ISStringEqualToString(self_className, @"BTExchangeContainerVC")) {
            BTExchangeListModel *model = [self parameters][@"model"];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
            [UserDefaults setObject:dict forKey:BTClassParameters];
            [UserDefaults synchronize];
        }else if (ISStringEqualToString(self_className, @"QiHuoListViewController")) {
        
            
            if ([self.parameters isKindOfClass:[NSDictionary class]] && self.parameters != nil) {//带参数 进入期货列表
                
                BTExchangeListModel *model = [self parameters][@"model"];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dict);
                [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
                [UserDefaults setObject:dict forKey:BTClassParameters];
                [UserDefaults synchronize];
                return;
            }else {//不带参数 进入期货列表
                
                [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
                [UserDefaults setObject:[self parameters] forKey:BTClassParameters];
                [UserDefaults synchronize];
                return;
            }
            
        }else {
            
            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
            [UserDefaults setObject:[self parameters] forKey:BTClassParameters];
            [UserDefaults synchronize];
        }
    
    }
    /**暂时去掉 加载慢**/
//    if (ISStringEqualToString(self_className, @"HomeViewController") ||ISStringEqualToString(self_className, @"QuotesViewController") ||ISStringEqualToString(self_className, @"BTNewSheQuMainViewController") || ISStringEqualToString(self_className, @"DiscoveryViewController")) {
//
//
//        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
//    }
//    if (!ISStringEqualToString(self_className, @"HomeViewController") && !ISStringEqualToString(self_className, @"BTNewSheQuMainViewController") && !ISStringEqualToString(self_className, @"DiscoveryViewController") && !ISStringEqualToString(self_className, @"UserCenterViewController") && !ISStringEqualToString(self_className, @"MyOptionViewController") && !ISStringEqualToString(self_className, @"MarketViewController") && !ISStringEqualToString(self_className, @"CurrencyViewController") && !ISStringEqualToString(self_className, @"BTExchangeViewController") && !ISStringEqualToString(self_className, @"NewsViewController") && !ISStringEqualToString(self_className, @"FastInfomationViewController") && !ISStringEqualToString(self_className, @"StrategyViewController") && !ISStringEqualToString(self_className, @"TopicListViewController") && !ISStringEqualToString(self_className, @"UserCenterViewController") && !ISStringEqualToString(self_className, @"LoginAndRegisterViewController") && !ISStringEqualToString(self_className, @"QiHuoListViewController") && !ISStringEqualToString(self_className, @"QiHuoListContentVC") && !ISStringEqualToString(self_className, @"BTExchangeDetailLncomeViewController") && !ISStringEqualToString(self_className, @"ChooseJYDViewController") && !ISStringEqualToString(self_className, @"BTExchangeAuthorizationViewController") && !ISStringEqualToString(self_className, @"EditOptionViewController") && !ISStringEqualToString(self_className, @"PersonSettingViewController") && !ISStringEqualToString(self_className, @"BTNewCommentsAlertViewController") && !ISStringEqualToString(self_className, @"OptionSearchViewController") && !ISStringEqualToString(self_className, @"HistorySearchViewController") && !ISStringEqualToString(self_className, @"QuotesViewController")) {
//
//        if (ISStringEqualToString(self_className, @"BTExchangeContainerVC")) {
//            BTExchangeListModel *model = [self parameters][@"model"];
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dict);
//            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//            [UserDefaults setObject:dict forKey:BTClassParameters];
//            [UserDefaults synchronize];
//            return;
//        }
//        if (ISStringEqualToString(self_className, @"H5ViewController")) {
//            H5Node *node = [self parameters][@"node"];
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:node.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dict);
//            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//            [UserDefaults setObject:dict forKey:BTClassParameters];
//            [UserDefaults synchronize];
//            return;
//        }
//        if (ISStringEqualToString(self_className, @"BTIndexDetailViewController")) {
//            BTBitaneIndexModel *model = [self parameters][@"model"];
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dict);
//            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//            [UserDefaults setObject:dict forKey:BTClassParameters];
//            [UserDefaults synchronize];
//            return;
//        }
//        if (ISStringEqualToString(self_className, @"BTNewAddRecordViewController")) {//币记账
//            NSDictionary *dict = @{};
//            if (self.parameters[@"model"]) {
//                BTRecordModel *model = [self parameters][@"model"];
//                dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
//            }else {
//                dict = self.parameters;
//            }
//            NSLog(@"%@",dict);
//            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//            [UserDefaults setObject:dict forKey:BTClassParameters];
//            [UserDefaults synchronize];
//            return;
//        }
//        if (ISStringEqualToString(self_className, @"BTZFFBDetailViewController")) {
//            NSMutableArray *dataArray = @[].mutableCopy;
//            for (NSDictionary *dic in [self parameters][@"dataArray"]) {
//                NSMutableDictionary *smallDict = @{}.mutableCopy;
//                NSArray *arr = dic[@"arr"];
//                NSMutableArray *smallArr = @[].mutableCopy;
//                for (BTZFFFModel *model in arr) {
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:model.modelToJSONData options:NSJSONReadingMutableContainers error:nil];
//                    [smallArr addObject:dict];
//                }
//                [smallDict setValue:smallArr forKey:@"arr"];
//                [smallDict setValue:dic[@"total"] forKey:@"total"];
//                [dataArray addObject:smallDict];
//            }
//            [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//            [UserDefaults setObject:dataArray forKey:BTClassParameters];
//            [UserDefaults synchronize];
//            return;
//        }
//        [UserDefaults setObject:NSStringFromClass([self class]) forKey:BTClassName];
//        [UserDefaults setObject:[self parameters] forKey:BTClassParameters];
//        [UserDefaults synchronize];
//
//        NSLog(@"BTClassName = %@ and BTClassParameters = %@", [UserDefaults objectForKey:BTClassName], [UserDefaults objectForKey:BTClassParameters]);
//    }else {
//        if (!ISStringEqualToString([UserDefaults objectForKey:BTClassName], @"BTExchangeContainerVC") && !ISStringEqualToString(self_className, @"BTNewCommentsAlertViewController") && !ISStringEqualToString([UserDefaults objectForKey:BTClassName], @"QuotesViewController")) {
//            NSLog(@"%ld",getMainTabBar.selectedIndex);
//            [UserDefaults removeObjectForKey:BTClassName];
//            [UserDefaults removeObjectForKey:BTClassParameters];
//            [UserDefaults setInteger:getMainTabBar.selectedIndex forKey:BTGetMainTabBarSelectedIndex];
//            [UserDefaults synchronize];
//        }else if (!ISStringEqualToString(self_className, @"BTNewCommentsAlertViewController") && !ISStringEqualToString(self_className, @"MyOptionViewController") && !ISStringEqualToString(self_className, @"MarketViewController") && !ISStringEqualToString(self_className, @"CurrencyViewController") && !ISStringEqualToString([UserDefaults objectForKey:BTClassName], @"QuotesViewController")){
//
//            [UserDefaults removeObjectForKey:BTClassName];
//            [UserDefaults removeObjectForKey:BTClassParameters];
//            [UserDefaults setInteger:getMainTabBar.selectedIndex forKey:BTGetMainTabBarSelectedIndex];
//            [UserDefaults synchronize];
//        }
//
//    }
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
