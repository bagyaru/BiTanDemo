//
//  CountryCodeViewController.m
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CountryCodeViewController.h"
#import "BTSearchBarView.h"
#import "CountryCodeTableViewCell.h"

@interface CountryCodeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BTSearchBarView *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *searchResultArr;

@end

@implementation CountryCodeViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight=0.0;
            _tableView.estimatedSectionFooterHeight=0.0;
        }
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSArray *)searchResultArr{
    if (!_searchResultArr) {
        _searchResultArr = [NSArray array];
    }
    return _searchResultArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择国家/区号";

    [self initUI];
    
}

-(void)initUI{
    
    //搜索界面
    self.searchBar = [[BTSearchBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RELATIVE_WIDTH(48))];
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    
    
    [self.searchBar getSearchResult:^(NSArray *result) {
        NSLog(@"++++++++++");
        self.searchResultArr = result;
        [self.tableView reloadData];
    }];
    
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.searchBar.isSearch) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchBar.isSearch) {
        return self.searchResultArr.count;
    }
    
    if (section == 0) {
        return self.searchBar.hotCountryDataArray.count;
    }else{
        return self.searchBar.countryDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    CountryCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CountryCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.searchBar.isSearch) {
        [cell parseData:self.searchResultArr[indexPath.row]];
    }else{
        if (indexPath.section == 0) {
            [cell parseData:self.searchBar.hotCountryDataArray[indexPath.row]];
        }else{
            [cell parseData:self.searchBar.countryDataArray[indexPath.row]];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(48);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RELATIVE_WIDTH(30);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headerViewID = @"headerViewID";
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewID];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RELATIVE_WIDTH(30))];
        view.backgroundColor = ViewBGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RELATIVE_WIDTH(15), RELATIVE_WIDTH(5), 100, RELATIVE_WIDTH(20))];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        label.textColor = FirstColor;
        label.tag = 1;
    }
    UILabel *countryLabel = (UILabel*)[view viewWithTag:1];
    if (self.searchBar.isSearch) {
        countryLabel.text = [APPLanguageService sjhSearchContentWith:@"sousuojieguo"];
    }else{
        if (section == 0) {
            countryLabel.text = @"常用";
        }else{
            countryLabel.text = @"所有";
        }
    }
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *code;
    
    NSLog(@"+start+++%@++++",[NSDate date]);
    if (self.searchBar.isSearch) {
        
        code = [NSString stringWithFormat:@"+%@",[self.searchResultArr[indexPath.row] componentsSeparatedByString:@"+"].lastObject];

    }else{
        if (indexPath.section == 0) {
            code = [NSString stringWithFormat:@"+%@",[self.searchBar.hotCountryDataArray[indexPath.row] componentsSeparatedByString:@"+"].lastObject];
        }else{
           code = [NSString stringWithFormat:@"+%@",[self.searchBar.countryDataArray[indexPath.row] componentsSeparatedByString:@"+"].lastObject];
        }
    }
    if (self.codeBlock) {
        self.codeBlock(code);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    NSLog(@"+++end++%@++++++",[NSDate date]);
    
}

//滑动退出键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}




- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
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
