//
//  BTFutureIntroduceVC.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureIntroduceVC.h"
#import "BTFutureIntroduceApi.h"
#import "BTJianjieShengMingCell.h"
#import "QiHuoDetailCell.h"
#import "BTFutureIntroModel.h"

@interface BTFutureIntroduceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) NSMutableArray *conceptArr;

@property (nonatomic, strong) BTFutureIntroModel *introduceModel;

@end


static NSString *const identifierQihuoDetail = @"QiHuoDetailCell";
static NSString *const identifierShengmingContent =@"BTJianjieShengMingCell";

@implementation BTFutureIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}

- (void)loadData{
    [self.loadingView showLoading];
    BTFutureIntroduceApi *api = [[BTFutureIntroduceApi alloc] initWithFutureCode:SAFESTRING(_futureCode) code:SAFESTRING(_code)];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(![request.data isKindOfClass:[NSDictionary class]]){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            self.introduceModel = [BTFutureIntroModel objectWithDictionary:request.data];
            [self.mTableView reloadData];
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    //    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:nil];
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.tag = 1102;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        _mTableView.separatorColor = SeparateColor;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QiHuoDetailCell class]) bundle:nil] forCellReuseIdentifier:identifierQihuoDetail];
        
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTJianjieShengMingCell class]) bundle:nil] forCellReuseIdentifier:identifierShengmingContent];
        
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        if(self.introduceModel.explain.length == 0){
            return 0;
        }
        return 1;
    }else if(section == 1){
        NSArray *arr = self.introduceModel.detailInfo;
        if([arr isKindOfClass:[NSArray class]]){
            return arr.count;
        }
        return 0;
    }else{
        self.introduceModel.memo = [self.introduceModel.memo stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(self.introduceModel.memo.length == 0){
            return 0;
        }
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSString *content = [self getStrWithTrimHtml:self.introduceModel.explain];
        CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
        return height1+8.0f +10.0f; //加上行间距
    }else if(indexPath.section == 1){
        
        NSArray *arr = self.introduceModel.detailInfo;
        NSDictionary *dict = arr[indexPath.row];
        CGFloat titleW = [SAFESTRING(dict[@"key"]) sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
        CGFloat contentH = [getUserCenter customGetContactHeight:SAFESTRING(dict[@"value"]) FontOfSize:12 LabelMaxWidth:ScreenWidth- titleW - 30 jianju:4.0];
        NSLog(@"%.0f %.0f",titleW,contentH);
        CGFloat height = contentH + 14;
        if(height < 30){
            height = 30;
        }
        return height;
        
    }else{
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSString *content = [self getStrWithTrimHtml:self.introduceModel.memo];;
        CGFloat height1 = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
        return height1+8.0f +10.0f; //加上行间距
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        BTJianjieShengMingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShengmingContent forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *content = self.introduceModel.explain;
        
        content = [self getStrWithTrimHtml:content];
        
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content attributes:wordDic];
        
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle } documentAttributes:nil error:nil];
//        textView.attributedText = attributedString;
        
      
        cell.titleLabel.attributedText = wordLabelAttStr;
        
        return cell;
        
        
    }else if(indexPath.section == 1){
        QiHuoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierQihuoDetail];
        NSArray *arr = self.introduceModel.detailInfo;
        NSDictionary *dict = arr[indexPath.row];
        cell.titleL.text = SAFESTRING(dict[@"key"]);
        cell.contentL.text = [SAFESTRING(dict[@"value"]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        BTJianjieShengMingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShengmingContent forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *content = self.introduceModel.memo;
        content = [self getStrWithTrimHtml:content];
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 8.0f;
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:wordStyle};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:content attributes:wordDic];
        cell.titleLabel.attributedText = wordLabelAttStr;
        return cell;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr = @[SAFESTRING(self.introduceModel.explainTitle),[APPLanguageService sjhSearchContentWith:@"heyuexiangqing"],SAFESTRING(self.introduceModel.memoTitle)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40.0f)];
    headerView.backgroundColor = isNightMode ?ViewBGNightColor :CWhiteColor;
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(14) textColor:FirstColor];
    titleLabel.text = arr[section];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    if(section == 0){
        if(self.introduceModel.explain.length == 0){
            return nil;
        }
        [AppHelper addLeftLineWithParentView:headerView];
        return headerView;
    }else if(section == 1){
        UIView *ivLine = [[UIView alloc] init];
        ivLine.backgroundColor = SeparateColor;
        [headerView addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
            make.height.mas_equalTo(0.5);
        }];
        [AppHelper addLeftLineWithParentView:headerView];
        return headerView;
    }else{
        self.introduceModel.memo = [self.introduceModel.memo stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(self.introduceModel.memo.length == 0){
            return nil;
        }
        [AppHelper addLeftLineWithParentView:headerView];
        UIView *ivLine = [[UIView alloc] init];
        ivLine.backgroundColor = SeparateColor;
        [headerView addSubview:ivLine];
        [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
            make.height.mas_equalTo(0.5);
        }];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if(self.introduceModel.explain.length == 0){
            return 0.01;
        }
        return 40.0f;
    }else if(section == 1){
        return 40.0f;
    }else{
        self.introduceModel.memo = [self.introduceModel.memo stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(self.introduceModel.memo.length == 0){
            return 0.01;
        }
        return 40.0f;
    }
}

- (NSString*)getStrWithTrimHtml:(NSString*)htmlStr{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<(?!br).*?>|&nbsq |&mdash|&ldquo|&rdquo" options:0 error:nil];
    NSString *string =[regularExpretion stringByReplacingMatchesInString:htmlStr options:NSMatchingReportProgress range:NSMakeRange(0, htmlStr.length) withTemplate:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
     string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    //    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除字符串中所有得空格及控制字符
    return string;
}

@end
