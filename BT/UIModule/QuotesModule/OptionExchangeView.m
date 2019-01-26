//
//  OptiontimeView.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OptionExchangeView.h"
#import "ExchangeSelectCell.h"
@interface OptionExchangeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *ivAlpha;

@property (weak, nonatomic) IBOutlet UIView *viewBG;

@property (nonatomic, strong) UITableView *mTableView;

@end

static NSString *cellIdentifier = @"ExchangeSelectCell";
@implementation OptionExchangeView{
    UIButton *pribtn;
    NSArray *_arr;
    UIView *_parentView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.ivAlpha = [[UIView alloc] init];
    self.ivAlpha.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.ivAlpha addGestureRecognizer:tap];
    
    self.viewBG.backgroundColor =  [kHEXCOLOR(0x000000) colorWithAlphaComponent:0.7];
    [self.viewBG addSubview:self.mTableView];
    self.viewBG.layer.cornerRadius = 3.0f;
    self.viewBG.layer.masksToBounds = YES;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.viewBG).offset(16.0f);
    }];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray =dataArray;
    [self.mTableView reloadData];
}

- (void)clickedBtn:(UIButton *)btn{
    
}

/////////////////////
- (void)showInParentView:(UIView *)parentView relativeView:(UIView *)relativeView{
    if ([self superview]) {
        if (![self.viewRotation isEqual:parentView] && self.viewRotation) {
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
            [parentView addSubview:self.ivAlpha];
            [parentView addSubview:self];
            [self.ivAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(parentView).insets(insets);
            }];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(relativeView.mas_bottom);
                make.left.equalTo(relativeView).offset(15);
                make.width.mas_equalTo(150.0f);
                make.height.mas_equalTo(346.0f);
            }];
            _parentView = parentView;
            [self show];
            return;
        }else{
            [self show];
        }
    }
    if (parentView && relativeView) {
        _parentView = parentView;
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        [parentView addSubview:self.ivAlpha];
        [parentView addSubview:self];
        [self.ivAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView).insets(insets);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(relativeView.mas_bottom);
            make.left.equalTo(relativeView).offset(15);
            make.width.mas_equalTo(150.0f);
            make.height.mas_equalTo(346.0f);
        }];
        
    }
}

- (void)show{
    self.hidden = NO;
    self.ivAlpha.hidden = NO;
}

- (void)hiddenView{
    if (self.hiddenblock) {
        self.hiddenblock();
    }
    self.hidden = YES;
    self.ivAlpha.hidden = YES;
    if (self.optionTypeBlock) {
        self.optionTypeBlock(nil);
    }
}

- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self;
        _mTableView.dataSource=self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        [_mTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
        _mTableView.backgroundColor = [UIColor clearColor];
    }
    return _mTableView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExchangeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}

//选中 类型
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTExchangeListModel *model = self.dataArray[indexPath.row];
    if (self.optionTypeBlock) {
        self.optionTypeBlock(model);
    }
    [self hiddenView];
    
}

- (void)setSelectModel:(BTExchangeListModel *)selectModel{
    if(selectModel){
        for(BTExchangeListModel *model in self.dataArray){
            if([model.exchangeCode isEqualToString:selectModel.exchangeCode]){
                model.isSelected =YES;
            }
        }
        [self.mTableView reloadData];
        
    }
}


@end
