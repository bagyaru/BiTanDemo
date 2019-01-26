//
//  BTChooseWalletViewController.m
//  BT
//
//  Created by admin on 2018/5/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTChooseWalletViewController.h"
#import "MyWalletCell.h"
#import "BTMyWalletHistoryRequest.h"
#import "FastInfomationObj.h"
#import "BTChooseWalletFV.h"
#import "MMScanViewController.h"
static NSString *const identifier = @"MyWalletCell";
@interface BTChooseWalletViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTChooseWalletFV *footView;
@property (nonatomic, strong) BTView *backV;
@end

@implementation BTChooseWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.title = [APPLanguageService wyhSearchContentWith:@"xuanzeqianbao"];
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyWalletCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self loadMyWalletData];
}
-(void)loadMyWalletData {
    
    [self.loadingView showLoading];
    BTMyWalletHistoryRequest *api = [[BTMyWalletHistoryRequest alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.dataArray removeAllObjects];
        NSLog(@"%@",request.data);
        if ([request.data count]) {
            
            [self.loadingView hiddenLoading];
        } else {
            
            [self.loadingView showNoDataWith:@"zanwushuju"];
        }
        for (NSString *str in request.data) {
           
            [self.dataArray addObject:str];
            
        }
        [_tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    
    [self loadMyWalletData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.walletL.text = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PasteSuccess object:nil userInfo:@{@"wallet":self.dataArray[indexPath.row]}];
    [BTCMInstance popViewController:nil];
}

- (IBAction)AddWalletBtnClick:(BTButton *)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"qingxuanze"] delegate:self cancelButtonTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] destructiveButtonTitle:nil otherButtonTitles:[APPLanguageService wyhSearchContentWith:@"congjianqiebanzhantie"],[APPLanguageService wyhSearchContentWith:@"saomianerweima"], nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld",buttonIndex);
   
        
        if (buttonIndex == 0) {//粘贴
           
            NSString *jqbStr = [[UIPasteboard generalPasteboard] string];
            if (ISNSStringValid(jqbStr)) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PasteSuccess object:nil userInfo:@{@"wallet":jqbStr}];
                [BTCMInstance popViewController:nil];
            }else {
                
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"jianqiebanweikong"] wait:YES];
            }
            NSLog(@"%@", [[UIPasteboard generalPasteboard] string]);
            
        }else if (buttonIndex == 1){//扫二维码
          
            MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
                if (error) {
                    NSLog(@"error: %@",error);
                    [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"saomiaoshibai"] wait:YES];
                } else {
                    NSLog(@"扫描结果：%@",result);
                    [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"saomiaochenggong"] wait:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PasteSuccess object:nil userInfo:@{@"wallet":result}];
                    [BTCMInstance popViewController:nil];
                }
            }];
            [self.navigationController pushViewController:scanVc animated:YES];
           
        }else {
            
            return;
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
