//
//  HYActionSheetViewController.m


#import "HYActionSheetViewController.h"

@interface HYActionSheetViewController ()
{
    UIView          *_bgView;
    UITapGestureRecognizer      *_tapGesture;
    
    UIView                      *_lineView;
    
    UIView                      *_line1View;
    
    UIButton                    *_firstBtn;
    UIButton                    *_nextBtn;
    UIButton                    *_canBtn;
}

@end

@implementation HYActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPage:)]];
   
    [self initsubView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self showView];
}
-(void)initsubView
{
    if ( _bgView == nil )
    {
        _bgView = NewObject(UIView);
        _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 161.0f)
        ;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
    }else
    {
        _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 161.0f);
    }
    CGRect rect = CGRectMake(0, 0.0f, ScreenWidth, 50.0f);
    if ( _firstBtn == nil )
    {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstBtn setTitle:[APPLanguageService wyhSearchContentWith:@"congxiangcehuoqu"] forState:UIControlStateNormal];
        [_firstBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _firstBtn.frame = rect;
        _firstBtn.userInteractionEnabled = YES;
        _firstBtn.backgroundColor = [UIColor whiteColor];
        [_firstBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_firstBtn];
    }else
    {
        _firstBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = 1.0f;
    rect.origin.x = 15.0f;
    rect.size.width = ScreenWidth-2*rect.origin.x;
    if ( _lineView == nil )
    {
        _lineView =NewObject(UIView);
        _lineView.backgroundColor = kHEXCOLOR(0xebebeb);
        _lineView.frame = rect;
        [_bgView addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.origin.x = 0;
    rect.size.width = ScreenWidth;
    rect.size.height = _firstBtn.bounds.size.height;
    if ( _nextBtn == nil )
    {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:[APPLanguageService wyhSearchContentWith:@"paizhao"] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _nextBtn.frame = rect;
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [UIColor whiteColor];
        [_nextBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_nextBtn];
    }else
    {
        _nextBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = 10.0f;
    if ( _line1View == nil )
    {
        _line1View =NewObject(UIView);
        _line1View.backgroundColor = kHEXCOLOR(0xebebeb);
        _line1View.frame = rect;
        [_bgView addSubview:_line1View];
    }else
    {
        _line1View.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.origin.x = 0;
    rect.size.width = ScreenWidth;
    rect.size.height = _firstBtn.bounds.size.height;
    if ( _canBtn == nil )
    {
        _canBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_canBtn setTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] forState:UIControlStateNormal];
        [_canBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _canBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _canBtn.frame = rect;
        _canBtn.userInteractionEnabled = YES;
        _canBtn.backgroundColor = [UIColor whiteColor];
        [_canBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_canBtn];
    }else
    {
        _canBtn.frame = rect;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onButton:(id)sender
{
    
    NSInteger index = 0;
    if ( sender == _firstBtn )
    {
        index = 1;
    }
    else if (sender == _nextBtn )
    {
        index = 2;
    }
    [self dismissViewIndex:index];
}
-(void)showView
{
    [UIView animateWithDuration:0.3f animations:^
     {
         _bgView.frame = CGRectMake(0, ScreenHeight-161.0f, ScreenWidth, 161.0f);
         
     } completion:nil];
}
#pragma mark -
- (void)tapOnPage:(UIGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateRecognized)
    {
        // if this gesture intercepts any of the views, then inform the delegate
        [self dismissViewIndex:0];
    }

}

-(void)dismissViewIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3f animations:^
     {
         _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 161.0f);
         
     } completion:^(BOOL finished) {
         [weakSelf dismissViewControllerAnimated:NO completion:^{
             if ( _delegate && [_delegate respondsToSelector:@selector(actionSheetView:clickedButtonAtIndex:)]) {
                 [_delegate actionSheetView:self clickedButtonAtIndex:index];
             }
         }];

     }];
}
@end
