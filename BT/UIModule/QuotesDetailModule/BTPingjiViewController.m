//
//  BTPingjiViewController.m
//  BT
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPingjiViewController.h"
#import "BTJianjieShengMingCell.h"
#import "BTPingjiDetailCell.h"

@interface BTPingjiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

static NSString *const identifierShengmingContent = @"BTJianjieShengMingCell";
static NSString *const identifierPingji = @"BTPingjiDetailCell";


@implementation BTPingjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService sjhSearchContentWith:@"EtherscanPingjiDesc"];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorColor = SeparateColor;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData{
    self.dataArray = @[ [APPLanguageService sjhSearchContentWith:@"pingji6"], [APPLanguageService sjhSearchContentWith:@"pingji5"], [APPLanguageService sjhSearchContentWith:@"pingji4"], [APPLanguageService sjhSearchContentWith:@"pingji3"], [APPLanguageService sjhSearchContentWith:@"pingji2"], [APPLanguageService sjhSearchContentWith:@"pingji1"], [APPLanguageService sjhSearchContentWith:@"pingji0"]].mutableCopy;
    [self.mTableView reloadData];
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPingjiDetailCell class]) bundle:nil] forCellReuseIdentifier:identifierPingji];
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTJianjieShengMingCell class]) bundle:nil] forCellReuseIdentifier:identifierShengmingContent];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = self.dataArray[indexPath.row];
    if(indexPath.row == 0){
        BTJianjieShengMingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShengmingContent];
       
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:wordStyle};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content  attributes:wordDic];
        cell.titleLabel.attributedText = wordLabelAttStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    BTPingjiDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierPingji];
    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    wordStyle.lineSpacing = 8.0f;
    NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle};
    NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content  attributes:wordDic];
    cell.contentL.attributedText = wordLabelAttStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rateView.currentScore = 6 - indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = self.dataArray[indexPath.row];
    if(indexPath.row == 0) {
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
        return height1+8.0f +24.0f; //加上行间距
    }
    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    wordStyle.lineSpacing = 8.0f;
    CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
    return height1+8.0f +10.0f +40.0f;
}

@end
