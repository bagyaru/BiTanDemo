//
//  CommentsAlertView.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentsAlertView.h"
#import "AlertTableViewCell.h"

@interface CommentsAlertView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BTLabel *titleLabel;

@property (nonatomic, strong) BTButton *confimBtn;//

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) CommentsAlertBlock block;

@end
@implementation CommentsAlertView

+ (void)showWithArr:(NSArray*)arr type:(NSInteger)type completion:(CommentsAlertBlock)block{
    CommentsAlertView *alert = [[CommentsAlertView alloc]initWithFrame:[self frameOfAlert]];
    alert.confimBtn.fixTitle =@"cancel";
    alert.dataArray = arr;
    alert.block =  block;
    alert.type  = type;
    if (alert.type == 1) {
        alert.titleLabel.localText =@"querenshanchucipinglun";
    }else {
        
        alert.titleLabel.localText =@"querenbaocunzhaopian";
    }
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
    
    [self addSubview:_titleLabel];
    [self addSubview:_confimBtn];
    [self addSubview:self.mTableView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(44.0f);
    }];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.tag = 87541513;
    [AppHelper addBottomLineWithParentView:_titleLabel];
    [_confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
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
    UIView *window=[UIApplication sharedApplication].keyWindow;
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
