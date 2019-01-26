//
//  AddToGroupAlert.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddToGroupAlert.h"
#import "AlertTableViewCell.h"
#import "NewCreateGroupAlert.h"

#import "BTAddGroupRequest.h"
@interface AddToGroupAlert()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BTLabel *titleLabel;

@property(nonatomic,strong) BTButton *confimBtn;//

@property(nonatomic,strong) BTButton *createBtn;//



@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) AddToGroupAlertBlock block;

@end

@implementation AddToGroupAlert

+ (void)showWithArr:(NSArray *)arr completion:(AddToGroupAlertBlock)block{
    AddToGroupAlert *alert = [[AddToGroupAlert alloc]initWithFrame:[self frameOfAlert]];
    alert.confimBtn.fixTitle =@"cancel";
    alert.titleLabel.fixText =@"addToGroup";
    alert.createBtn.fixTitle = @"newCreate";
//    NSMutableArray *mutaArr = @[].mutableCopy;
//    BTGroupListModel *model = [[BTGroupListModel alloc] init];
//    model.groupName = [APPLanguageService sjhSearchContentWith:@"newCreate"];
//    [mutaArr addObject:model];

    alert.dataArray = arr;
    alert.block =  block;
    [alert.mTableView reloadData];
    [alert show];
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, ScreenWidth, 44*6 + 5);
}

- (void)createView{
    self.layer.cornerRadius = 1.0f;
    self.layer.masksToBounds = YES;
    
    _titleLabel = [[BTLabel alloc]initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.textColor = kHEXCOLOR(0x999999);
    
    _confimBtn =[BTButton buttonWithType:UIButtonTypeCustom];
    _confimBtn.titleLabel.font = MainTextFont;
    [_confimBtn setTitleColor:TextColor forState:UIControlStateNormal];
    
    WS(weakSelf)
    [_confimBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _createBtn =[BTButton buttonWithType:UIButtonTypeCustom];
    _createBtn.titleLabel.font = MainTextFont;
    [_createBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
    
    [_createBtn bk_addEventHandler:^(id  _Nonnull sender) {
        if(self.block){
            self.block(nil);
        }
        [self __hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_createBtn];
    
    [self addSubview:_titleLabel];
    [self addSubview:_confimBtn];
    [self addSubview:self.mTableView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(44.0f);
    }];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *ivLine = [UIView new];
    ivLine.backgroundColor = SeparateLineDayColor;
    [_titleLabel addSubview:ivLine];
    [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(_titleLabel).offset(-0.5);
    }];
    [_confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
    }];
    
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.height.mas_offset(44.0f);
        make.top.equalTo(self);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:bgView];
    bgView.backgroundColor = kHEXCOLOR(0xF5F5F5);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(_confimBtn.mas_top);
        make.height.mas_equalTo(5);
    }];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.bottom.equalTo(self).offset(-49);
    }];
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
        _mTableView.backgroundColor = kHEXCOLOR(0xF5F5F5);
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        [_mTableView registerNib:[UINib nibWithNibName:@"AlertTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlertTableViewCell"];
        _mTableView.separatorColor = kHEXCOLOR(0xdddddd);
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
        _mTableView.tag = 1000001;
    }
    return _mTableView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlertTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moedl = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

//选中 类型
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BTGroupListModel *model = self.dataArray[indexPath.row];
    if(model){
        if(self.block){
            self.block(SAFESTRING(model.groupName));
            [self __hide];
        }
    }
    
}

- (void)setInfoViewFrame:(BOOL)isDown{
    
    NSInteger count = self.dataArray.count;
    if(self.dataArray.count >4){
        count = 4 ;
    }
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if(isDown == NO){
        [window addSubview:self.viewControl];
        [window addSubview:self];
        self.frame = CGRectMake(0, ScreenHeight, self.frame.size.width, 44 *(count + 2) +5);
        
        //self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:0.35 animations:^{
            self.frame = CGRectMake(0, ScreenHeight - self.frame.size.height , self.frame.size.width, 44 *(count + 2) +5);
        }];
    }
    else{
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.frame = CGRectMake(0, ScreenHeight, self.frame.size.width, 44 *(count + 2) +5);
                             
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 [self.viewControl removeFromSuperview];
                                 [self removeFromSuperview];
                             }
                             
                         }];
    }
    
}
@end
