//
//  BTLoadingView.m
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTLoadingView.h"

@interface BTLoadingView (){
    UIView *_parentView;
    UIView *_aboveView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLoading;

@property (weak, nonatomic) IBOutlet UIView *viewError;

@property (weak, nonatomic) IBOutlet BTLabel *labelError;

@property (weak, nonatomic) IBOutlet BTButton *btnTry;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *addView;

@end

@implementation BTLoadingView

- (void)awakeFromNib{
    [super awakeFromNib];
    NSMutableArray *loadingImages = [NSMutableArray array];
    self.imageViewLoading.image = [UIImage imageNamed:@"loading_0"];
    for (NSInteger i = 0; i < 49; i++) {
        [loadingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld",i]]];
    }
    self.labelError.textColor = CFontColor11;
    [self.btnTry setTitleColor:CGrayColor forState:UIControlStateNormal];
    ViewBorderRadius(self.btnTry, 4.0, 1, CGrayColor);
    //self.imageViewLoading.backgroundColor = [UIColor redColor];
    [self.imageViewLoading setAnimationImages:loadingImages];
    [self.imageViewLoading setAnimationDuration:loadingImages.count * 0.04];
    [self.imageViewLoading setAnimationRepeatCount:0];
    
    self.viewError.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.viewError addGestureRecognizer:tap];
    
    
}

- (instancetype)initWithParentView:(UIView *)parentView aboveSubView:(UIView *)aboveView delegate:(id<BTLoadingViewDelegate>)delegate{
    self = [[UINib nibWithNibName:NSStringFromClass([BTLoadingView class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    if (self) {
        _parentView = parentView;
        _aboveView = aboveView;
        self.delegate = delegate;
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (_parentView && _aboveView) {
            [parentView insertSubview:self aboveSubview:_aboveView];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_aboveView).insets(insets);
            }];
        }else if (_parentView){
            [_parentView addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_parentView).insets(insets);
            }];
        }
    }
    return self;
}

- (void)showLoading{
    self.hidden = NO;
    self.viewError.hidden = YES;
    self.imageViewLoading.hidden = NO;
    [self.imageViewLoading startAnimating];
    //
    self.addView.hidden = YES;
}

- (void)showErrorWith:(NSString *)msg{
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    self.showImageView.image = [UIImage imageNamed:@"ic_wuwangluo"];
    if (kNetworkNotReachability) {
        msg = [APPLanguageService sjhSearchContentWith:@"nonetwork"];
    }
   
    if (SAFESTRING(msg).length == 0) {
        return;
    }
    self.labelError.text = msg;
}
-(void)showNoDataWith:(NSString *)msg {
    
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    self.btnTry.hidden = YES;
    self.showImageView.image = [UIImage imageNamed:@"ic_wushuju"];
    msg = [APPLanguageService wyhSearchContentWith:msg];
    
    if (SAFESTRING(msg).length == 0) {
        return;
    }
    self.labelError.text = msg;
}

- (void)showBusinessErrorWith:(NSString *)msg{
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    self.btnTry.hidden = YES;
    self.showImageView.image = [UIImage imageNamed:@"ic_wushuju"];
    if (SAFESTRING(msg).length == 0) {
        return;
    }
    self.labelError.text = msg;
}

-(void)showNoDataWithMessage:(NSString *)msg imageString:(NSString *)img {
    
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    self.btnTry.hidden = YES;
    self.showImageView.image = [UIImage imageNamed:img];
    msg = [APPLanguageService wyhSearchContentWith:msg];
    
    if (SAFESTRING(msg).length == 0) {
        return;
    }
    self.labelError.text = msg;
}
-(void)showHeadErrorWith:(NSString *)msg {
    
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    if (kNetworkNotReachability) {
        msg = [APPLanguageService sjhSearchContentWith:@"nonetwork"];
    }
    
    if (SAFESTRING(msg).length == 0) {
        return;
    }
    self.labelError.text = msg;
}
-(void)showLncomeStatisticsView {
    
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = YES;
    self.addView.hidden = NO;
}

- (void)showAddOptioal{
    self.hidden = NO;
    [self.imageViewLoading stopAnimating];
    self.imageViewLoading.hidden = YES;
    self.viewError.hidden = NO;
    self.btnTry.hidden = YES;
    self.showImageView.image = [UIImage imageNamed:@"ic_tianjiazixuan"];
    NSString *msg = [APPLanguageService sjhSearchContentWith:@"dianjitianjiazixuan"];
    self.labelError.text = msg;
    self.labelError.textColor = FirstColor;
}


- (void)hiddenLoading{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self.imageViewLoading stopAnimating];
    });
}

- (IBAction)clickedBtnTry:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshingData)]) {
        [self.delegate refreshingData];
    }
}
//添加收益
- (IBAction)addBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addLncomeStatistics)]) {
        [self.delegate addLncomeStatistics];
    }
}

- (void)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchOptional)]) {
        [self.delegate searchOptional];
    }
}

@end
