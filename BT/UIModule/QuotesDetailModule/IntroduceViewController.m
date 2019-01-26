//
//  IntroduceViewController.m
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IntroduceViewController.h"
#import "IntrodueceRequest.h"

#import "BTJianjieModel.h"
#import "IntroduceModel.h"
#import "JianjieContentCell.h"
#import "JianjieHeaderTableViewCell.h"
#import "TagsViewCell.h"//标签
#import "DetailHelper.h"
#import "JianjieConceptCell.h"
#import "BTJianjieShengMingCell.h"
#import "BTPaimingTableViewCell.h"
#import "BTIntroWebsiteCell.h"
#import "BTCoinDistriPieCell.h"

static NSString *const identifierJianjieHeader = @"JianjieHeaderTableViewCell";
static NSString *const identifierJianjieContent = @"JianjieContentCell";
static NSString *const identifierShengmingContent =@"BTJianjieShengMingCell";
static NSString *const identifierPaiming = @"BTPaimingTableViewCell";
static NSString *const identifierWebsite = @"BTIntroWebsiteCell";
static NSString *const identifierCoinDist = @"BTCoinDistriPieCell";

@interface IntroduceViewController ()<UITableViewDelegate,UITableViewDataSource,TagsViewCellDelegate,JianjieConceptCellDelegate>{
    TagsFrame *tagFrame;
}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IntroduceModel *introduceModel;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *conceptArr;


@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    //    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:nil];
}

- (void)loadData{
    [self requestIntroduce];
    _conceptArr = @[].mutableCopy;
}

// 简介
- (void)requestIntroduce{
    //简介接口
    [self.loadingView showLoading];
    NSString *kind;
    if([SAFESTRING(self.kindCode) containsString:@"/"]){
        kind = [[SAFESTRING(self.kindCode) componentsSeparatedByString:@"/"] firstObject];
    }else{
        kind = SAFESTRING(self.kindCode);
    }
    IntrodueceRequest *request = [[IntrodueceRequest alloc] initWithCurrencySimpleName:kind];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if(![request.data isKindOfClass:[NSDictionary class]]){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        [self.loadingView hiddenLoading];
        IntroduceModel *model  = [IntroduceModel modelWithJSON:request.data];
        self.introduceModel = model;
        if(self.introduceModel.conceptInfo){
            _conceptArr = @[].mutableCopy;
            for(NSString *key in self.introduceModel.conceptInfo){
                NSString *name = self.introduceModel.conceptInfo[key];
                [self.conceptArr addObject:@{@"key":SAFESTRING(key),@"name":SAFESTRING(name)}];
            }
        }
        
        self.dataArray =  [DetailHelper introduceArrWithModel:model].mutableCopy;
        
        [self.mTableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        //简介没有
        [self.loadingView showErrorWith:request.resultMsg];
    }];
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
        _mTableView.tag = 1100;
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JianjieHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifierJianjieHeader];
        
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JianjieContentCell class]) bundle:nil] forCellReuseIdentifier:identifierJianjieContent];
        [_mTableView registerNib:[UINib nibWithNibName:@"BTIntroWebsiteCell" bundle:nil] forCellReuseIdentifier:identifierWebsite];
        
        [_mTableView registerNib:[UINib nibWithNibName:@"BTCoinDistriPieCell" bundle:nil] forCellReuseIdentifier:identifierCoinDist];
        
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTJianjieShengMingCell class]) bundle:nil] forCellReuseIdentifier:identifierShengmingContent];
         [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPaimingTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifierPaiming];
        _mTableView.separatorColor = SeparateColor;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.dataArray.count;
        
    }else if(section == 1){//基本信息
        return [DetailHelper baseInfoWithModel:self.introduceModel].count;
        
        
    }else if(section == 2){//募集/私募情况
        return [DetailHelper privateInfoWithModel:self.introduceModel].count;
        
    }else if(section == 3){//团队介绍
        return [DetailHelper teamInfoWithModel:self.introduceModel].count;
        
    }else if(section == 4){//GitHub开发情况
        return [DetailHelper githubInfoWithModel:self.introduceModel].count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        BTJianjieModel *model = self.dataArray[indexPath.row];
        if(SAFESTRING(model.name).length  ==0){
            BTJianjieModel *model = self.dataArray[indexPath.row];
            NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
            wordStyle.lineSpacing = 8.0f;
            CGFloat height1 = [model.content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
            return height1+8.0f +24.0f; //加上行间距
        }else{
            //
            if([SAFESTRING(model.name) isEqualToString:@"xiangguanwangzhan"]){
//                return tagFrame.tagsHeight;
                NSArray *arr = @[];
                if([self.introduceModel.webInfo isKindOfClass:[NSArray class]]){
                    arr = self.introduceModel.webInfo;
                }
                if(arr.count >0){
                    return 86.0f;
                }
                return 0.01;
                
            }else if([model.name isEqualToString:@"concept"]){
                if(self.conceptArr.count>0){
                    return 35.0f;
                }else{
                    return 0.01;
                }
            }else{
                
//                if([model.name isEqualToString:@"zhichiqianbao"]){
                    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
                    wordStyle.lineSpacing = 0.0f;
                    NSString *content = model.content;
                    CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 100, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
                    
                    if(height1 +10 < 38){
                        return 38.0f;
                    }
                    return height1 + 10.0f; //加上行间距
                    
                    
//                }else{
//                    return 28;
//                }
               
            }
        }
        
    }
//    else if(indexPath.section == 5){
//        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
//        wordStyle.lineSpacing = 8.0f;
//        NSString *content = [APPLanguageService sjhSearchContentWith:@"shengming"];
//        CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
//        return height1+8.0f +10.0f; //加上行间距
    else {
        //算一下高度
        NSArray *arr;
        if(indexPath.section == 1){
            arr = [DetailHelper baseInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 2){
            arr = [DetailHelper privateInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 3){
            arr = [DetailHelper teamInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 4){
            arr = [DetailHelper githubInfoWithModel:self.introduceModel];
        }
        BTJianjieModel *model = arr[indexPath.row];
        //代币分配
        if([model.name isEqualToString:@"daibifenpei"]){
            //if(self.introduceModel.privateInfoObj)
            NSArray *tokens = self.introduceModel.privateInfoObj[@"Tokens"];
            NSArray *arr = @[];
            if([tokens isKindOfClass:[NSArray class]]){
                arr = tokens;
            }
            if(arr.count == 0){
                return 0.01;
            }
            return 130.0f;
        }
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 0.0f;
        NSString *content = model.content;
        CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 100, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
        
        if(height1 +10 < 38){
            return 38.0f;
        }
        return height1 + 10.0f; //加上行间距
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        BTJianjieModel *model = self.dataArray[indexPath.row];
        if(SAFESTRING(model.name).length == 0){
            JianjieContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierJianjieContent forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            return cell;
        }else{
            if([SAFESTRING(model.name) isEqualToString:@"xiangguanwangzhan"]){
                
                
//                TagsViewCell *cell = [[TagsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//                tagFrame = [[TagsFrame alloc] init];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.delegate = self;
//                tagFrame.title = model.name;
//                tagFrame.tagsArray = self.introduceModel.webInfo;
//                cell.tagsFrame = tagFrame;
                BTIntroWebsiteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierWebsite];
                NSArray *arr = @[];
                if([self.introduceModel.webInfo isKindOfClass:[NSArray class]]){
                    arr = self.introduceModel.webInfo;
                }
                cell.websites = arr;
                return cell;
            }else if([SAFESTRING(model.name) isEqualToString:@"concept"]){
                JianjieConceptCell *cell = [JianjieConceptCell loadFromXib];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.model = model;
                cell.info = self.conceptArr;
                return cell;
                
            }else{
                if([SAFESTRING(model.name) isEqualToString:@"paiming"]){
                    BTPaimingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierPaiming forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = model;
                    return cell;
                }
                JianjieHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierJianjieHeader forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                return cell;
            }
            
        }
        
    }
    //    else if(indexPath.section == 5){
    //        BTJianjieShengMingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShengmingContent forIndexPath:indexPath];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        NSString *content = [APPLanguageService sjhSearchContentWith:@"shengming"];
    //        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    //        wordStyle.lineSpacing = 8.0f;
    //        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle};
    //        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content attributes:wordDic];
    //         cell.titleLabel.attributedText = wordLabelAttStr;
    //        return cell;
    else{
        NSArray *arr;
        if(indexPath.section == 1){
            arr = [DetailHelper baseInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 2){
            arr = [DetailHelper privateInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 3){
            arr = [DetailHelper teamInfoWithModel:self.introduceModel];
        }
        if(indexPath.section == 4){
            arr = [DetailHelper githubInfoWithModel:self.introduceModel];
        }
        BTJianjieModel *model = arr[indexPath.row];
        if([model.name isEqualToString:@"daibifenpei"]){
            BTCoinDistriPieCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCoinDist];
            NSArray *tokens = self.introduceModel.privateInfoObj[@"Tokens"];
            NSArray *arr = @[];
            if([tokens isKindOfClass:[NSArray class]]){
                arr = tokens;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labels = arr;
            return cell;
        }
        JianjieHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierJianjieHeader forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = arr[indexPath.row];
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) return nil;
    NSArray *arr = @[[APPLanguageService sjhSearchContentWith:@"jibenxinxi"],[APPLanguageService sjhSearchContentWith:@"privateXinxi"],[APPLanguageService sjhSearchContentWith:@"tuanduijieshao"],[APPLanguageService sjhSearchContentWith:@"githubqingkuang"],[APPLanguageService sjhSearchContentWith:@"mianzeshengming"]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28.0f)];
    headerView.backgroundColor = isNightMode ? ViewBGNightColor:ViewBGDayColor;
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:SecondColor];
    titleLabel.text = arr[section - 1];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    if(section == 1){//基本信息
        NSDictionary *dict  = self.introduceModel.baseInfoObj;
        if(dict == nil ||dict.count == 0){
            return nil;
        }
        
    }else if(section == 2){//募集/私募情况
        NSDictionary *dict  = self.introduceModel.privateInfoObj;
        if(dict == nil ||dict.count == 0){
            return nil;
        }
        
    }else if(section == 3){//团队介绍
        NSArray *arr  = self.introduceModel.teamInfoObj;
        if(arr.count == 0){
            return nil;
        }
        
    }else if(section == 4){//GitHub开发情况
        NSDictionary *dict  = self.introduceModel.gitHubInfoObj;
        if(dict == nil ||dict.count == 0){
            return nil;
        }
        
    }
//    else{//免责声明
//        return headerView;
//    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0.01;
    if(section == 1){//基本信息
        NSDictionary *dict  = self.introduceModel.baseInfoObj;
        if(dict == nil ||dict.count == 0){
             return 0.01;
        }
    }else if(section == 2){//募集/私募情况
        NSDictionary *dict  = self.introduceModel.privateInfoObj;
        if(dict == nil ||dict.count == 0){
            return 0.01;
        }
        
    }else if(section == 3){//团队介绍
        NSArray *arr  = self.introduceModel.teamInfoObj;
        if(arr.count == 0){
            return 0.01;
        }
        
    }else if(section == 4){//GitHub开发情况
        NSDictionary *dict  = self.introduceModel.gitHubInfoObj;
        if(dict == nil){
            return 0.01;
        }
    }
    return 38.0f;
}
//
- (void)tapConcept:(NSInteger)index{
    if(self.conceptArr.count>0){
        NSDictionary *dict =self.conceptArr[index];
        NSString *key = dict[@"key"];
        NSString *name = dict[@"name"];
        [BTCMInstance pushViewControllerWithName:@"PayConceptVC" andParams:@{@"conceptId":SAFESTRING(key),@"conceptClassifyName":SAFESTRING(name)}];
    }
}

- (void)TagsViewCellClickIndex:(NSInteger)index{
    NSArray *arr = self.introduceModel.webInfo;
    NSDictionary *dict = arr[index];
    NSString *url = SAFESTRING(dict[@"url"]);
    H5Node *node = [[H5Node alloc] init];
    node.webUrl = url;
    node.isNoLanguage = NO;
    H5ViewController *h5Vc = [[H5ViewController alloc] init];
    h5Vc.node = node;
    [self.navigationController pushViewController:h5Vc animated:YES];
}
//设置不同的分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, ScreenWidth, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, ScreenWidth, 0, 0)];
            }
        }else if(indexPath.row == 1){
            if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }else{
            if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
        }
        
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
}

@end

