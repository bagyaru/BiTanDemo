//
//  ChooseJYDViewController.m
//  BT
//
//  Created by admin on 2018/3/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChooseJYDViewController.h"
#import "HistoryResultCell.h"
#import "BTTitleView.h"
#import "BTSearchService.h"
static NSString *const identifier = @"HistoryResultCell";
@interface ChooseJYDViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewNoData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrResult;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation ChooseJYDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewNoData.hidden = YES;
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
+ (id)createWithParams:(NSDictionary *)params{
    ChooseJYDViewController *vc = [[ChooseJYDViewController alloc] init];
    [vc.dataArray addObjectsFromArray:[params objectForKey:@"resultArray"]];
    CurrentcyModel *M1 = [[CurrentcyModel alloc] init];
    M1.currencySimpleName = @"USD";
    [vc.dataArray insertObject:M1 atIndex:0];
    CurrentcyModel *M2 = [[CurrentcyModel alloc] init];
    M2.currencySimpleName = @"CNY";
    [vc.dataArray insertObject:M2 atIndex:0];
    [vc.arrResult addObjectsFromArray:vc.dataArray];
    return vc;
}
-(void)creatUI {
   
    [self configSearchBar];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HistoryResultCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CWhiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectionView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)changeCollectionView:(NSNotification *)noti{
    CGRect endFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (endFrame.origin.y == ScreenHeight) {
        self.constraintBottom.constant = 0;
    }else{
        self.constraintBottom.constant = endFrame.size.height;
    }
    
}
- (void)configSearchBar{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-10, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [APPLanguageService wyhSearchContentWith:@"sousuojiaoyidui"];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
    self.searchBar.tintColor = [UIColor blueColor];
    for (UIView *view in self.searchBar.subviews) {
        for (id v in view.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [v removeFromSuperview];
            }else if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
                UITextField *textField = (UITextField *)v;
                textField.font = MediumFont;
                [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
                textField.backgroundColor = CSearchBarColor;
                textField.layer.masksToBounds = YES;
                textField.layer.cornerRadius  = 18;
            }else if ([v isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)v;
                [btn setTitle:[APPLanguageService wyhSearchContentWith:@"fanhui"] forState:UIControlStateNormal];
                [btn setTitleColor:CGrayColor forState:UIControlStateNormal];
            }
        }
    }
    
    //5. 设置搜索Icon
    [self.searchBar setImage:[UIImage imageNamed:@"search"]
            forSearchBarIcon:UISearchBarIconSearch
                       state:UIControlStateNormal];
    
    
    BTTitleView *ivTitle = [[BTTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-10, 44)];
    
    [ivTitle addSubview:self.searchBar];
    
    self.navigationItem.titleView = ivTitle;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrResult.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HistoryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.arrResult[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        CurrentcyModel *model = self.arrResult[indexPath.row];
        //发送通知 回到上一个页面的时候刷新数据 保持数据准确
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_chooseJYDSuccess object:nil userInfo:@{@"model":model}];
        [BTCMInstance popViewController:nil];
}
#pragma mark - UISearchBar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [BTCMInstance popViewController:nil];
}
- (BOOL)searchBar:(UISearchBar *)SearchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.tableView.userInteractionEnabled = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        self.viewNoData.hidden = YES;
        [self.arrResult removeAllObjects];
        [self.arrResult addObjectsFromArray:self.dataArray];
        [self.tableView reloadData];
        self.tableView.userInteractionEnabled = YES;
    }
    NSString *searchString = [self searchDeletewhitespaceWithString:searchBar.text];
    if (searchString.length > 0) {
        WS(ws)
        [[BTSearchService sharedService] searchJYDWithArray:self.dataArray withInput:searchString result:^(NSArray *resultArray) {
            [ws.arrResult removeAllObjects];
            if (resultArray == nil) {
                ws.viewNoData.hidden = NO;
                [ws.tableView reloadData];
                ws.tableView.userInteractionEnabled = YES;
                return ;
            }
            ws.viewNoData.hidden = YES;
            [ws.arrResult addObjectsFromArray:resultArray];
            [ws.tableView reloadData];
            ws.tableView.userInteractionEnabled = YES;
        }];
    }
    
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (NSString *)searchDeletewhitespaceWithString:(NSString *)text{
    if (text.length == 0) {
        return text;
    }
    NSString *searchText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    return searchText;
}
#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)arrResult{
    if (!_arrResult) {
        _arrResult = [NSMutableArray array];
    }
    return _arrResult;
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
