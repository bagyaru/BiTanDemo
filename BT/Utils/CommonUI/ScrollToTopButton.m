//
//  ScrollToTopButton.m
//  BT
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ScrollToTopButton.h"

@interface ScrollToTopButton()
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *scrollBtnToTop;
@property (nonatomic, assign) BOOL isShow;
@end

@implementation ScrollToTopButton


- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView{
    if(self = [super initWithFrame:frame]){
        _isShow = NO;
        _mScrollView = scrollView;
        _scrollBtnToTop = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBtnToTop setImage:[UIImage imageNamed:@"return_top"] forState:UIControlStateNormal];
        WS(ws)
        [_scrollBtnToTop bk_addEventHandler:^(id  _Nonnull sender) {
            [ws scrollToTopBtnAction];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scrollBtnToTop];
        [_scrollBtnToTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.hidden = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView completion:(nonnull UIView_ToTop_Operation)completion{
    if(self = [super initWithFrame:frame]){
        _isShow = NO;
        _mScrollView = scrollView;
        _block = completion;
        _scrollBtnToTop = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBtnToTop setImage:[UIImage imageNamed:@"return_top"] forState:UIControlStateNormal];
        WS(ws)
        [_scrollBtnToTop bk_addEventHandler:^(id  _Nonnull sender) {
            [ws scrollToTopBtnAction];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scrollBtnToTop];
        [_scrollBtnToTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.hidden = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        if(_mScrollView.contentOffset.y <=0){
            [self hideScrollToTopBtn];
        }else{
            if (_mScrollView.contentOffset.y > _mScrollView.superview.frame.size.height) {
                if(_mScrollView.isDragging){
                    [self hideScrollToTopBtn];
                }else{
                    self.hidden = NO;
                }
            }
            
        }
    }
}

//隐藏到顶部
- (void)hideScrollToTopBtn{
    self.hidden = YES;
}

//滚动到顶部
- (void)scrollToTopBtnAction{
    
    [UIView animateWithDuration:0.5 animations:^{
        [_mScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
    if(self.block){
        self.block();
    }
    [self hideScrollToTopBtn];
   
}

- (void)dealloc{
    [_mScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
