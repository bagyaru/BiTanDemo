//
//  GroupSideView.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupSideView.h"
#import "GroupMenuCell.h"

@interface GroupSideView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIControl *viewControl;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) BTLabel *nameLabel;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, copy) GroupSideViewBlock block;

@end

static NSString *cellIdentifier = @"GroupMenuCell";
@implementation GroupSideView

+ (void)show{
    GroupSideView *sideView =[[GroupSideView alloc] initWithFrame:[self frameOfAlert]];
    sideView.dataArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    [sideView show];
}

+ (void)showWithArr:(NSArray *)arr completion:(GroupSideViewBlock)block{
    GroupSideView *sideView =[[GroupSideView alloc] initWithFrame:[self frameOfAlert]];
    sideView.dataArray = arr;
    sideView.block = block;
    [sideView show];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self =[super initWithFrame:frame]){
        self.backgroundColor = isNightMode?ViewContentBgColor :[UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self createCommonView];
    [self createView];
}

- (void)createCommonView{
    
}

+ (CGRect)frameOfAlert{
    return CGRectMake(-200,0,200, ScreenHeight);
}

- (void)createView{
    _nameLabel = [[BTLabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = FONTOFSIZE(16.0f);
    _nameLabel.textColor = SecondColor;
    _nameLabel.text = [APPLanguageService wyhSearchContentWith:@"zixuanfenzu"];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(50.0f);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = SeparateColor;
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:btnBgView];
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lineLabel.mas_bottom);
        make.height.mas_equalTo(52.0f);
    }];
    
   
    UIImageView *settingimageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settings"]];
    [btnBgView addSubview:settingimageV];
    [settingimageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnBgView.mas_centerY);
        make.left.equalTo(btnBgView).offset(20);
    }];
    UILabel *manageLabel = [[BTLabel alloc] initWithFrame:CGRectZero];
    manageLabel.font = FONTOFSIZE(16.0f);
    manageLabel.textColor = FirstColor;
    manageLabel.text = [APPLanguageService sjhSearchContentWith:@"manageGroup"];
    [btnBgView addSubview:manageLabel];
    [manageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(settingimageV.mas_right).offset(10);
        make.centerY.equalTo(btnBgView.mas_centerY);
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"R箭头"]];
    [btnBgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnBgView.mas_centerY);
        make.right.equalTo(btnBgView.mas_right).offset(-20);
    }];
    UILabel *lineLabel1 = [[UILabel alloc] init];
    lineLabel1.backgroundColor = SeparateColor;
    [self addSubview:lineLabel1];
    [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBgView.mas_bottom);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    
//    //
    _manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _manageBtn.backgroundColor = [UIColor clearColor];
    //管理分组
    WS(weakSelf)
    [_manageBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [BTCMInstance pushViewControllerWithName:@"manageGroup" andParams:nil];
        [weakSelf __hide];

    } forControlEvents:UIControlEventTouchUpInside];

    [btnBgView addSubview:_manageBtn];
    [_manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(btnBgView);
    }];
    
    [self addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(btnBgView.mas_bottom).offset(10);
    }];
    
}
//取消
- (void)cancel:(UIButton*)btn{
    [self __hide];
}

#pragma mark -
-(UIControl*)viewControl{
    if(!_viewControl){
        _viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [_viewControl setBackgroundColor:kHEXCOLOR(0x000000)];
        [_viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        [_viewControl addSubview:self];
    }
    return _viewControl;
}

- (void)show{
    self.viewControl.alpha = 0.5f;
    [self setInfoViewFrame:NO];
}

- (void)shut{
    [self __hide];
}
//
- (void)__hide{
    [self setInfoViewFrame:YES];
}

- (void) controlPressed{
    [self __hide];
}

- (void)setInfoViewFrame:(BOOL)isDown{
    UIView *window=[UIApplication sharedApplication].keyWindow;
    if(isDown == NO){
        [window addSubview:self.viewControl];
        [window addSubview:self];
        [UIView animateWithDuration:0.35 animations:^{
            self.frame =CGRectMake(0, 0, 200.0f, ScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.frame =CGRectMake(0, 0, -200.0f, ScreenHeight);
                             
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 [self.viewControl removeFromSuperview];
                                 [self removeFromSuperview];
                             }
                             
                         }];
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
    }
    return _mTableView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42.0f;
}

//选中 类型
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTGroupListModel *model = self.dataArray[indexPath.row];
    if(self.block){
        self.block(model);
    }
    [self __hide];
}

@end
