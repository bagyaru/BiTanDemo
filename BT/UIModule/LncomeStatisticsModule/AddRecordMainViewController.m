//
//  AddRecordMainViewController.m
//  BT
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddRecordMainViewController.h"
#import "AddRecordNavView.h"
#import "BTNewAddRecordViewController.h"
#import "QiHuoMainViewController.h"
@interface AddRecordMainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)AddRecordNavView *navView;
@end

@implementation AddRecordMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.titleView = self.navView;
    
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    self.scrollView.delegate = self;
    //self.scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.scrollView];
    
    //现货
    BTNewAddRecordViewController *orderListVC1 = [[BTNewAddRecordViewController alloc] init];
    orderListVC1.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight-kTopHeight);
    //期货
    QiHuoMainViewController *orderListVC2 = [[QiHuoMainViewController alloc] init];
    
    orderListVC2.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, ScreenHeight-kTopHeight);
    
    [self addChildViewController:orderListVC1];
    [self addChildViewController:orderListVC2];
    [self.scrollView addSubview:orderListVC1.view];
    [self.scrollView addSubview:orderListVC2.view];
    // Do any additional setup after loading the view from its nib.
}

-(AddRecordNavView *)navView {
    
    if (!_navView) {
        
        _navView = [AddRecordNavView loadFromXib];
        _navView.frame = CGRectMake(0, 0, 160, 30);
        _navView.intrinsicContentSize = CGSizeMake(160, 30);
        ViewBorderRadius(_navView.sdtjBtn, 4, 1, kHEXCOLOR(0x108ee9));
        ViewBorderRadius(_navView.sqdrBtn, 4, 1, kHEXCOLOR(0x108ee9));
    }
    return _navView;
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
