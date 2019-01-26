//
//  DMCommunityDetailHeaderView.m
//  DMRice
//
//  Created by zdd. on 17/4/10.
//  Copyright zdd. All rights reserved.
//

#import "ZDPersonHeaderView.h"
#import "BTMyHeaderView.h"
#import "NSString+Utils.h"
@interface ZDPersonHeaderView (){
    BOOL testHits;
}


@end

@implementation ZDPersonHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundImageView];
        
        [self addSubview:self.verifyBtn];
        
        [self addSubview:self.avatarImageV];
        [self addSubview:self.postHeader];
        [self addSubview:self.nameLabel];
        [self addSubview:self.introduceL];
      
        [self addSubview:self.selectMenuView];
        CGSize verifySize = [[APPLanguageService sjhSearchContentWith:@"shenqingrenzheng"] calculateSizeWithFont:12 height:30.0f];
        [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(verifySize.width + 20);
            make.height.mas_equalTo(22);
            make.top.equalTo(self).offset(kTopHeight);
        }];
        
//        [self.avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(86.0f);
//            make.centerX.equalTo(self.mas_centerX);
//            make.width.height.mas_equalTo(80.0f);
//        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20.0f);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.avatarImageV.mas_bottom).offset(14);
        }];
        [self.introduceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        }];
        [_avatarImageV layoutIfNeeded];
        
    }
    return self;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self.selectMenuView switchSelectButtonWithIndex:selectIndex];
}
//重写view的touch事件
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
   
    if(testHits){
        return nil;
    }
    
    if(!self.passthroughViews
       || (self.passthroughViews && self.passthroughViews.count == 0)){
        return self;
    } else {
        
        UIView *hitView = [super hitTest:point withEvent:event];
        
        if (hitView == self) {
            //Test whether any of the passthrough views would handle this touch
            testHits = YES;
            CGPoint superPoint = [self.superview convertPoint:point fromView:self];
            UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
            testHits = NO;
            
            if ([self isPassthroughView:superHitView]) {
                hitView = superHitView;
            }
        }
        return hitView;
    }
}
//是否获取到当前view的穿透视图
- (BOOL)isPassthroughView:(UIView *)view {
    
    if (view == nil) {
        return NO;
    }
    
    if ([self.passthroughViews containsObject:view]) {
        return YES;
    }
    
    return [self isPassthroughView:view.superview];
}

#pragma mark - Setter and getter
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;        
    }
    return _backgroundImageView ;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.0f];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel*)introduceL{
    if(!_introduceL){
        _introduceL = [[UILabel alloc] initWithFrame:CGRectZero];
        _introduceL.font = [UIFont systemFontOfSize:14.0f];
        _introduceL.textColor = [UIColor whiteColor];
        _introduceL.textAlignment = NSTextAlignmentCenter;
    }
    return _introduceL;
}

- (UIImageView*)avatarImageV{
    if(!_avatarImageV){
        _avatarImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 86, 80, 80)];
        _avatarImageV.layer.cornerRadius = 40.0f;
        _avatarImageV.layer.masksToBounds = YES;
        _avatarImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageV.layer.borderWidth = 1.0f;
        CGPoint center = _avatarImageV.center;
        center.x = self.center.x;
        _avatarImageV.center = center;
        
    }
    return _avatarImageV;
}

- (UIButton*)verifyBtn{
    if(!_verifyBtn){
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyBtn setTitle:[APPLanguageService sjhSearchContentWith:@"shenqingrenzheng"] forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font  = FONTOFSIZE(12);
        _verifyBtn.layer.cornerRadius = 4.0f;
        _verifyBtn.layer.masksToBounds = YES;
        _verifyBtn.layer.borderColor = CWhiteColor.CGColor;
        _verifyBtn.layer.borderWidth = 1.0f;
    }
    return _verifyBtn;
    
    
}

- (ZDSelectMenuView *)selectMenuView{
    if (!_selectMenuView) {
         NSArray *titleArr = @[[APPLanguageService sjhSearchContentWith:@"quanbu"], [APPLanguageService sjhSearchContentWith:@"yuanchuang"]];
        _selectMenuView = [[ZDSelectMenuView alloc] initWithFrame:CGRectMake(0, self.height - 44, ScreenWidth, 44) titleArr:titleArr imageArr:nil];
        __weak typeof(self) weakSelf = self;
        [_selectMenuView selectBtn:^(NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(personHeaderView:didSelectItemAtIndex:)]) {
                [weakSelf.delegate personHeaderView:weakSelf didSelectItemAtIndex:index];
            }
        }];
    }
    return _selectMenuView;
}

- (BTMyHeaderView*)postHeader{
    if(!_postHeader){
        _postHeader = [BTMyHeaderView loadFromXib];
        _postHeader.frame = CGRectMake(0, self.height - 44 - 76, ScreenWidth, 76);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [_postHeader.fabuView addGestureRecognizer:tap];
        [_postHeader.guanzhuView addGestureRecognizer:tap1];
        [_postHeader.fensiView addGestureRecognizer:tap2];
        [_postHeader.huozanView addGestureRecognizer:tap3];
    }
    return _postHeader;
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    if([self.delegate respondsToSelector:@selector(clickButton:)]){
        [self.delegate clickButton:view.tag];
    }
}



@end
