//
//  BTZFFBDetailViewController.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTZFFBDetailViewController.h"
#import "BTZFFBDetailCell.h"
#import "InformationModuleRequest.h"
#import "BTZFFFModel.h"
#import "BannersRequest.h"
#import "BTZFFBDetailSetionView.h"
static NSString *const identifier = @"BTZFFBDetailCell";
@interface BTZFFBDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTZFFBDetailSetionView *setionView;
@end

@implementation BTZFFBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = self.parameters[@"dataArray"];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.pageIndex = 1;
    self.title = [APPLanguageService wyhSearchContentWith:@"zhangfufenbu"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTZFFBDetailCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.dataArray[section] objectForKey:@"arr"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger total = [[self.dataArray[section] objectForKey:@"total"] integerValue];
    BTZFFBDetailSetionView *setionView = [BTZFFBDetailSetionView loadFromXib];
    setionView.backgroundColor = kHEXCOLOR(0xF5F5F5);
    setionView.setion = section;
    setionView.total = total;
    return setionView;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTZFFFModel *model = [self.dataArray[indexPath.section] objectForKey:@"arr"][indexPath.row];
    NSLog(@"%ld----%@------%ld",model.riseDistributionType,model.qujian,model.number);
    BTZFFBDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BTZFFFModel *model = [self.dataArray[indexPath.section] objectForKey:@"arr"][indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ %@(%@)",indexPath.section > 0 ? [APPLanguageService wyhSearchContentWith:@"diefu"] : [APPLanguageService wyhSearchContentWith:@"zhangfu"],indexPath.row > 0 ? @"" : @">",model.qujian];
    [BTCMInstance pushViewControllerWithName:@"BTZFFBDetailDetail" andParams:@{@"riseDistributionType":@(model.riseDistributionType),@"title":title}];
    if (indexPath.section == 0) {//涨幅
        if (indexPath.row == 0) {
            [MobClick event:@"rise_10"];
        }else {
            NSString *s = [model.qujian stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSArray *a  = [s componentsSeparatedByString:@"-"];
            [MobClick event:[NSString stringWithFormat:@"rise_%@_%@",a[0],a[1]]];
        }
    }else {
        
        if (indexPath.row == 0) {
            [MobClick event:@"fall_10"];
        }else {
            NSString *s = [model.qujian stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSArray *a  = [s componentsSeparatedByString:@"-"];
            [MobClick event:[NSString stringWithFormat:@"fall_%@_%@",a[0],a[1]]];
        }
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
