//
//  BTICODetailViewController.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICODetailViewController.h"
#import "BTICOHeaderView.h"
#import "BTICOFooterView.h"
#import "BTICOContentView.h"

#import "BTICODetailApi.h"
#import "BTICODetailModel.h"

@interface BTICODetailViewController ()<BTLoadingViewDelegate>

@property (nonatomic, strong) BTICOHeaderView *headerView;
@property (nonatomic, strong) UIView *bgFootView;

@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTICOFooterView *footerView;
@property (nonatomic, strong) BTICOContentView *contentView;

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) BTICODetailModel *detailModel;

@end

@implementation BTICODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 169 +90 +40 +186 +48 +5)];
    [headerBgView addSubview:self.headerView];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 169 +90 +40 +186 +48 +5);
    self.mTableView.tableHeaderView = headerBgView;
    
    self.contentView.frame = CGRectMake(0, 0, ScreenWidth, 55 + 334 +5 +12);
    [self.bgFootView addSubview:self.contentView];
    [self.bgFootView addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgFootView);
        make.top.equalTo(self.contentView.mas_bottom);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
}

- (void)loadData{
    [self requestContent];
}

- (void)requestContent{
    [self.loadingView showLoading];
    BTICODetailApi *api = [[BTICODetailApi alloc] initWithId:SAFESTRING(self.parameters[@"id"])];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            BTICODetailModel *detailModel = [BTICODetailModel objectWithDictionary:request.data];
            self.headerView.detailModel = detailModel;
            self.title = detailModel.icoCode;
            if([detailModel.otherLinksInfo isKindOfClass:[NSArray class]]){
                [self.footerView setLink:detailModel.otherLinksInfo];
            }
            if([detailModel.relatedShotInfo isKindOfClass:[NSArray class]]){
                [self.footerView setPhoto:detailModel.relatedShotInfo];
            }
            //
            self.detailModel = detailModel;
            [self.contentView setContent:self.detailModel.datasInfo];
            self.contentView.frame = CGRectMake(0, 0, ScreenWidth, 60 + self.detailModel.datasInfo.count *30.0f + 10 +12);
            
            if(![detailModel.otherLinksInfo isKindOfClass:[NSArray class]] &&![detailModel.relatedShotInfo isKindOfClass:[NSArray class]]){
                self.bgFootView.frame = CGRectMake(0, 0, ScreenWidth, VIEW_H(self.contentView));
                self.footerView.hidden = YES;
            }else{
                if(![detailModel.otherLinksInfo isKindOfClass:[NSArray class]]){
                    self.bgFootView.frame = CGRectMake(0, 0, ScreenWidth, VIEW_H(self.contentView) + 190+55 +22.0f);
                    self.footerView.linkHeaderView.hidden = YES;
                    self.footerView.linkScrollView.hidden = YES;
                    
                }else if(![detailModel.relatedShotInfo isKindOfClass:[NSArray class]]){
                    self.bgFootView.frame = CGRectMake(0, 0, ScreenWidth, VIEW_H(self.contentView) + 62+28+22);
                    self.footerView.photoHeaderView.hidden = YES;
                    self.footerView.photoScrollView.hidden = YES;
                    self.footerView.linkTopCons.constant = 0;
                }else{
                    self.bgFootView.frame = CGRectMake(0, 0, ScreenWidth, VIEW_H(self.contentView) + 190+55+62+28+22);
                }
            }
            self.mTableView.tableFooterView = self.bgFootView;
            
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (BTICOHeaderView*)headerView{
    if(!_headerView){
        _headerView = [BTICOHeaderView loadFromXib];
    }
    return _headerView;
}

- (BTICOFooterView*)footerView{
    if(!_footerView){
        _footerView = [BTICOFooterView loadFromXib];
    }
    return _footerView;
}

- (BTICOContentView*)contentView{
    if(!_contentView){
        _contentView = [BTICOContentView loadFromXib];
    }
    return _contentView;
}

- (UIView*)bgFootView{
    if(!_bgFootView){
        _bgFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 190+55+62+28+22 + 55 + 334 +5)];
    }
    return _bgFootView;
}
#pragma mark --Customer Accessor
- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        [_mTableView registerNib:[UINib nibWithNibName:@"BTICODetailCell" bundle:nil] forCellReuseIdentifier:@"BTICODetailCell"];
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}
#pragma mark -- loading
- (void)refreshingData{
    [self requestContent];
}

@end

