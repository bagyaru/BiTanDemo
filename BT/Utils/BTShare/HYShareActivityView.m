//
//  HYShareActivityView.m




#define ShareImageWidth  48.0f
#define ShareBtnTag 0x10000
#define ShareNum 3
#define ShareHeight  274.0f
#define ShareViewHeight 113.0f
#define ShareContentHeight 100.0f
#define ShareBtnViewHeight  46.0f
#define ShareBtnViewWidth  46.0f

#import "HYShareActivityView.h"


/********分享的按钮*******/

@interface HYShareButtonView()
{

    UILabel             *_titleLabel;
}

@end

@implementation HYShareButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect  rect = CGRectMake(0, 0, ShareBtnViewWidth, ShareBtnViewHeight);
    //rect.origin.x = (frame.size.width - rect.size.width)/2.0f;
    
    if ( _shareBtn == nil )
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:self.shareImage] forState:UIControlStateNormal];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:self.shareImage] forState:UIControlStateHighlighted];
        _shareBtn.frame = rect;
        _shareBtn.tag   = self.tag;
        _shareBtn.backgroundColor = [UIColor clearColor];
        [_shareBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
    }else
    {
        _shareBtn.frame = rect;
    }
    
    if(self.isShowTitle){
        rect.origin.y +=  rect.size.height + 10.0f;
        rect.size.width = frame.size.width;
        rect.origin.x = 0.0f;
        rect.size.height = 18.0f;
        if ( _titleLabel == nil )
        {
            _titleLabel = NewObject(UILabel);
            _titleLabel.frame = rect;
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.text = self.shareTitle;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = CFontColor11;
            _titleLabel.font = [UIFont systemFontOfSize:11.0f];
            [self addSubview:_titleLabel];
        }
        else
        {
            _titleLabel.frame = rect;
        }
    }
    
}

-(void)OnButton:(id)sender
{
    if ( sender == _shareBtn )
    {
        if ( _delegate && [_delegate respondsToSelector:@selector(onIconBtnPress:)])
        {
            [_delegate onIconBtnPress:self];
        }
    }
}

@end


@interface HYShareActivityView ()<HYShareButtonViewDelegate>
{
    NSMutableArray  *_imageArray;
    NSMutableArray  *_nameArray;
    NSMutableArray  *_buttonType;
    NSUInteger       _lines;//行数
    UILabel         *_titleLabel;
    UIView          *_shareBtnView;
    UIButton        *_closeBtn;
    UIButton        *_cancelBtn;
    UIView          *_lineView;
    UIView          *_line1View;
    UIButton        *_lineBtn;
    UIScrollView    *_imageScrollView;
    HYShareContentView      *_shareContentView;
    BOOL            _shown;
    
}

@property (nonatomic,strong)HYShayeTypeBlocks reqTypeResult;

@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *sharePay;

@property (nonatomic,copy) NSString *KX;
@property (nonatomic,strong) UIImageView *KX_IV;

@end

@implementation HYShareActivityView


- (instancetype)initWithButtons:(NSArray *)buttons
                          title:(NSString *)title
                            pay:(NSString *)pays
                 shareTypeBlock:(HYShayeTypeBlocks )shareType
{
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        [self initarray];
        self.shareTitle = title;
        self.sharePay = pays;
        _lines = _buttonType.count>3?2:1;
          self.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setAFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
}
-(void)initarray
{
    if ( _imageArray == nil  )
    {
        
        _imageArray = [[NSMutableArray alloc] initWithArray:@[@"TypeWechatSession",@"TypeWechatTimeline",@"TypeSinaWeibo",@"TypeQZone",@"TypeCopy",@"TypeQQFriend",@"TypeToMain",@"TypeCallService",@"TypeSMS"]];
        
    }
    if ( _nameArray == nil )
    {
        _nameArray = [[NSMutableArray alloc] initWithArray:@[[APPLanguageService sjhSearchContentWith:@"weixinhaoyou"], [APPLanguageService sjhSearchContentWith:@"pengyouquan"], [APPLanguageService sjhSearchContentWith:@"sinaweibo"],@"QQ空间",[APPLanguageService wyhSearchContentWith:@"baocuntupian"],@"QQ",[APPLanguageService wyhSearchContentWith:@"bitanshequ"],@"联系客服",@"发短信"]];
    }
    self.shareTitle = [APPLanguageService wyhSearchContentWith:@"fenxiangyingtanli"];
    self.sharePay = @"";
}
- (instancetype)initWithButtons:(NSArray *)buttons shareTypeBlock:(HYShayeTypeBlocks )shareType
{
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        [self initarray];
        _lines = _buttonType.count>4?2:1;
        self.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setAFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
}
-(instancetype)initWithButtons:(NSArray *)buttons title:(NSString *)title shareTypeBlock:(HYShayeTypeBlocks)shareType {
    
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        self.KX            = title;
        [self initarray];
        _lines = _buttonType.count>4?2:1;
        self.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setAFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
}
-(instancetype)initWithButtons:(NSArray *)buttons title:(NSString *)title image:(UIImageView *)iv shareTypeBlock:(HYShayeTypeBlocks)shareType {
    
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        self.KX            = title;
        self.KX_IV         = iv;
        [self initarray];
        _lines = _buttonType.count>4?2:1;
        self.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setAFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
}
-(void)setAFrame:(CGRect)frame
{
    //[super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    rect.size.height = ScreenHeight - ShareHeight + ShareViewHeight*(2-_lines);
    if ( ISNSStringValid(self.sharePay) )
    {
        rect.size.height -= ShareContentHeight;
    }
    if ( _closeBtn == nil )
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = rect;
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
    }else
    {
        _closeBtn.frame = rect;
    }
    if (ISNSStringValid(self.KX)) {
       
        if (ISStringEqualToString(self.KX, @"邀请好友")) {
            
            if ( _imageScrollView == nil) {
                
                _imageScrollView = [[UIScrollView alloc] init];
                _imageScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                _imageScrollView.scrollsToTop = NO;
                _imageScrollView.backgroundColor = [UIColor clearColor];
                _imageScrollView.pagingEnabled = YES;
                _imageScrollView.showsHorizontalScrollIndicator = NO;
                _imageScrollView.showsVerticalScrollIndicator = NO;
                _imageScrollView.contentSize = CGSizeMake(0, self.KX_IV.frame.size.height);
                self.KX_IV.frame = CGRectMake((ScreenWidth-self.KX_IV.frame.size.width)/2, kTopHeight+15, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
                [_imageScrollView addSubview:self.KX_IV];
                [self addSubview:_imageScrollView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                    [self hide];
                }];
                [_imageScrollView addGestureRecognizer:tap];
            }else {
                
                _imageScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                self.KX_IV.frame = CGRectMake(60, 23, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
                [_imageScrollView addSubview:self.KX_IV];
            }
            
        }else {
            
            if ( _imageScrollView == nil) {
                
                _imageScrollView = [[UIScrollView alloc] init];
                _imageScrollView.frame = CGRectMake(self.KX_IV.frame.origin.x, self.KX_IV.frame.origin.y, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height > (ScreenHeight-kTopHeight-160) ? (ScreenHeight-kTopHeight-160) : self.KX_IV.frame.size.height);
                _imageScrollView.scrollsToTop = NO;
                _imageScrollView.backgroundColor = [UIColor clearColor];
                _imageScrollView.pagingEnabled = NO;
                _imageScrollView.showsHorizontalScrollIndicator = NO;
                _imageScrollView.showsVerticalScrollIndicator = NO;
                _imageScrollView.contentSize = CGSizeMake(0, self.KX_IV.frame.size.height);
                self.KX_IV.frame = CGRectMake(0, 0, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
                [_imageScrollView addSubview:self.KX_IV];
                [self addSubview:_imageScrollView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                    [self hide];
                }];
                [_imageScrollView addGestureRecognizer:tap];
            }else {
                
                //_imageScrollView.frame = CGRectMake(0, 0, ScreenWidth, rect.size.height);
                _imageScrollView.frame = CGRectMake(self.KX_IV.frame.origin.x, self.KX_IV.frame.origin.y, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height > (ScreenHeight-kTopHeight-160) ? (ScreenHeight-kTopHeight-160) : self.KX_IV.frame.size.height);
                self.KX_IV.frame = CGRectMake(0, 0, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
                [_imageScrollView addSubview:self.KX_IV];
            }
        }
    }
    
    if ( ISNSStringValid(self.sharePay) )
    {
        rect.origin.y += rect.size.height;
        rect.size.height = ShareContentHeight;
        if ( _shareContentView == nil )
        {
            _shareContentView = NewObject(HYShareContentView);
            _shareContentView.sharePay = self.sharePay;
            _shareContentView.frame = rect;
            [self addSubview:_shareContentView];
        }else
        {
            _shareContentView.sharePay = self.sharePay;
            _shareContentView.frame = rect;
        }
    }else
    {
        if ( _shareContentView )
        {
            [_shareContentView removeFromSuperview];
        }
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = ShareViewHeight*_lines;
    if ( _shareBtnView == nil )
    {
        _shareBtnView = NewObject(UIView);
        _shareBtnView.backgroundColor = KWhiteColor;
        _shareBtnView.frame = rect;
        [self addSubview:_shareBtnView];
    }else
    {
        _shareBtnView.frame = rect;
    }
    CGFloat iconheight = ShareBtnViewHeight;
    CGFloat iconWidth = ShareBtnViewWidth;
    NSInteger nHcount = (ISStringEqualToString(self.KX, @"快讯") || ISStringEqualToString(self.KX, @"帖子")) ? 4 : 3;
    CGFloat inconX = (frame.size.width - nHcount*iconWidth)/(nHcount+1.0);
    CGRect btnrect = CGRectMake(0, rect.origin.y,iconWidth , iconheight);
    for (int i = 0 ; i< [_buttonType  count]; i++)
    {
        btnrect.origin.x = inconX*(i%nHcount) + iconWidth*(i%nHcount) + inconX;
        
        btnrect.origin.y = rect.origin.y + (i/nHcount)*(iconheight + 13.0f)+ 20.0f;
        NSUInteger type = [[_buttonType objectAtIndex:i] integerValue];
        HYShareButtonView * iconbtn = (HYShareButtonView *)[self viewWithTag:ShareBtnTag + type];
        if (iconbtn == nil)
        {
            iconbtn = NewObject(HYShareButtonView);
            iconbtn.tag = ShareBtnTag + type;
            iconbtn.shareImage = [_imageArray objectAtIndex:type];
            iconbtn.shareTitle = [_nameArray objectAtIndex:type];
            NSLog(@"%ld====%@",iconbtn.tag,iconbtn.shareTitle);
            iconbtn.delegate = self;
            iconbtn.isShowTitle = YES;
            iconbtn.frame = btnrect;
            [self addSubview:iconbtn];
        }else
        {
            iconbtn.frame = btnrect;
        }
    }
    
    rect.size.height = 49.0f;
    rect.size.width = frame.size.width;
    rect.origin.x = 0;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _cancelBtn == nil )
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = rect;
        _cancelBtn.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        [_cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:FirstColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = SYSTEMFONT(16);
        [_cancelBtn setTitleColor:ThirdColor forState:UIControlStateHighlighted];
        [self addSubview:_cancelBtn];
    }else
    {
        _cancelBtn.frame = rect;
    }
    
    rect.size.height = 0.5f;
    rect.origin.y -= rect.size.height;
    if ( _line1View == nil )
    {
        _line1View = NewObject(UIView);
        _line1View.backgroundColor = SeparateColor;
        _line1View.frame = rect;
        [self addSubview:_line1View];
    }else
    {
        _line1View.frame = rect;
    }
    
}

-(void)onButton:(id)sender
{
    if ( sender == _closeBtn )
    {
        [self hide];
    }
    else if ( sender == _cancelBtn )
    {
        [self hide];
    }
}
-(void)onIconBtnPress:(HYShareButtonView *)button
{
    NSInteger nSelect = ((UIView *)button).tag - ShareBtnTag;
    NSInteger shareBtnSelect = button.shareBtn.tag - ShareBtnTag;
    if ( self.reqTypeResult )
    {
        self.reqTypeResult(nSelect);
        if (nSelect == 4 && shareBtnSelect == 4) {//防止连续点击保存图片
            
            button.shareBtn.enabled = NO;
        }
    }
}

- (void)show
{
    if (_shown)
    {
        return;
    }
    _shown = YES;
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5f animations:^
     {
         self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
         self.alpha = 1;

     } completion:^(BOOL finished) {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
     }];
}

- (void)hide
{
    if (!_shown)
    {
        return;
    }
    if ( _delegate && [_delegate respondsToSelector:@selector(closeView)])
    {
        [_delegate closeView];
    }
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5f animations:^
     {
         self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
     }
                     completion:^(BOOL finished)
     {
         _shown = NO;
        [self removeFromSuperview];
         
     }];
}

- (instancetype)initWithButtons:(NSArray *)buttons image:(UIImageView *)iv shareTypeBlock:(HYShayeTypeBlocks)shareType{
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        self.KX_IV         = iv;
        [self initarray];
        _lines = _buttonType.count>4?2:1;
        [self setJiePingFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return self;
    
}


- (void)setJiePingFrame:(CGRect)frame{
    
    [self setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGFloat height = ScreenHeight - 186;
    if ( _imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.frame = CGRectMake(0, 0, self.KX_IV.frame.size.width, height);
        _imageScrollView.scrollsToTop = NO;
        _imageScrollView.backgroundColor =isNightMode?ViewContentBgColor :CWhiteColor;
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.contentSize = CGSizeMake(0, self.KX_IV.frame.size.height +65);
        
        self.KX_IV.frame = CGRectMake(0, 65, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
        [_imageScrollView addSubview:self.KX_IV];
        [self addSubview:_imageScrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self hide];
        }];
        [_imageScrollView addGestureRecognizer:tap];
    }else {
        _imageScrollView.frame = CGRectMake(0, 0, self.KX_IV.frame.size.width, height);
        self.KX_IV.frame = CGRectMake(0, 0, self.KX_IV.frame.size.width, self.KX_IV.frame.size.height);
        [_imageScrollView addSubview:self.KX_IV];
    }
    
    if ( _shareBtnView == nil ){
        _shareBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 186, ScreenWidth, 138)];
        _shareBtnView.backgroundColor = kHEXCOLOR(0xf5f5f5);
        [self addSubview:_shareBtnView];
    }else{
        _shareBtnView.frame = CGRectMake(0, ScreenHeight - 186, ScreenWidth, 138);
    }
    
    CGFloat iconheight = ShareBtnViewHeight +17;
    CGFloat iconWidth = ShareBtnViewWidth;
    NSInteger nHcount = 3;
    
    CGFloat inconX = (frame.size.width - 3*iconWidth)/4.0f;
    CGRect btnrect = CGRectMake(0, 0, iconWidth,iconheight);
    
    BTLabel *titleL = [[BTLabel alloc] initWithFrame:CGRectZero];
    titleL.font = FONTOFSIZE(14.0f);
    titleL.textColor = kHEXCOLOR(0x111210);
    titleL.fixText = @"shareTo";
    [_shareBtnView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shareBtnView.mas_centerX);
        make.top.equalTo(_shareBtnView).offset(12.0f);
    }];
    
    NSArray *nameArr = @[@"TypeWechatSession",@"TypeWechatTimeline",@"TypeSinaWeibo"];
    for (int i = 0 ; i< [_buttonType  count]; i++){
        CGFloat x = inconX*(i%nHcount) + iconWidth*(i%nHcount) + inconX;
        CGFloat y  = 20.0f +24.0f;
        btnrect = CGRectMake(x, y,iconWidth,iconheight);
        
        NSUInteger type = [[_buttonType objectAtIndex:i] integerValue];
        HYShareButtonView * iconbtn = (HYShareButtonView *)[_shareBtnView viewWithTag:ShareBtnTag + type];
        if (iconbtn == nil){
            iconbtn = NewObject(HYShareButtonView);
            iconbtn.tag = ShareBtnTag + type;
            iconbtn.shareImage = [nameArr objectAtIndex:type];
            iconbtn.shareTitle = [_nameArray objectAtIndex:type];
            iconbtn.delegate = self;
            iconbtn.isShowTitle = YES;
            iconbtn.frame = btnrect;
            [_shareBtnView addSubview:iconbtn];
        }else{
            iconbtn.isShowTitle = YES;
            iconbtn.frame = btnrect;
            
        }
    }
    
    if ( _cancelBtn == nil ){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, ScreenHeight -48, frame.size.width, 48);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:kHEXCOLOR(0x525057) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = SYSTEMFONT(16);
        [_cancelBtn setTitleColor:kHEXCOLOR(0x525057) forState:UIControlStateHighlighted];
        [self addSubview:_cancelBtn];
    }else{
        _cancelBtn.frame = CGRectMake(0, ScreenHeight -48, frame.size.width, 48);
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"评论关闭"] forState:UIControlStateNormal];
    [closeBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [self hide];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_imageScrollView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageScrollView);
        make.top.equalTo(_imageScrollView).offset(24);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(45);
    }];
}



@end

@interface HYShareContentView ()
{
    UILabel     *_paysLabel;
    UILabel     *_contentLabel;
}

@end

@implementation HYShareContentView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, 10.0f, frame.size.width, 26.0f);
    if ( _paysLabel == nil )
    {
        _paysLabel = NewObject(UILabel);
        _paysLabel.text = self.sharePay;
        _paysLabel.textColor = kHEXCOLOR(0xff2741);
        _paysLabel.textAlignment = NSTextAlignmentCenter;
        _paysLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        _paysLabel.frame = rect;
        [self addSubview:_paysLabel];
    }else
    {
        _paysLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height+16.0f;
    rect.origin.x = 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 36.0f;
    if ( _contentLabel == nil )
    {
        _contentLabel = NewObject(UILabel);
        _contentLabel.text = [NSString stringWithFormat:@"小伙伴们从你分享的链接进入嗨云买买买，你就可以获得%@的收益奖励哦！心动就马上行动吧～",self.sharePay];
        _contentLabel.textColor = kHEXCOLOR(0x252525);
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
        _contentLabel.frame = rect;
        [self addSubview:_contentLabel];
    }else
    {
        _contentLabel.frame = rect;
    }
    
}

@end

