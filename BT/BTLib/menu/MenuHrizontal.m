
#import "MenuHrizontal.h"
#import "LineButton.h"

@implementation MenuHrizontal
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [AppHelper addBottomLineWithParentView:self];
    }
    return self;
}

-(void)setLineBtnArr:(NSArray *)lineBtnArr{
    
    int i = 0;
    float menuWidth = 0.0;
    if(mButtonArray){
        [mButtonArray removeAllObjects];
    }
    if(mItemInfoArray){
        [mItemInfoArray removeAllObjects];
    }
    
    for (NSDictionary *lDic in lineBtnArr) {
        float vButtonWidth =  [[lDic objectForKey:TITLEWIDTH] floatValue];
        vButtonWidth = ScreenWidth/lineBtnArr.count;
        LineButton*vButton = [[LineButton alloc] initWithFrame:CGRectZero];
        vButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [vButton setTitle:lDic[@"name"] forState:UIControlStateNormal];
        [vButton setTitleColor:SecondColor forState:UIControlStateNormal];
        [vButton setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = [self calculateSizeWithFont:14 Text:lDic[@"name"]].size.width;
        
        //[vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        [mScrollView addSubview:vButton];
        if(lineBtnArr.count >2){
            
            if(i == 0){
                [vButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.equalTo(mScrollView);
                    make.width.mas_equalTo(width + 30);
                    make.height.mas_equalTo(mScrollView);
                }];
            }else if(i == lineBtnArr.count -1){
                [vButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(mScrollView);
                    make.left.equalTo(mScrollView).offset(ScreenWidth - width - 30);
                    make.width.mas_equalTo(width + 30);
                    make.height.mas_equalTo(mScrollView);
                }];
            }else{
                [vButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(mScrollView.mas_centerX);
                    make.top.bottom.equalTo(mScrollView);
                    make.height.mas_equalTo(mScrollView);
                }];
            }
        }else{
            if(i == 0){
                [vButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.equalTo(mScrollView);
                    make.width.mas_equalTo(width + 30);
                    make.height.mas_equalTo(mScrollView);
                }];
            }else{
                [vButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(mScrollView.mas_centerX);
                    make.top.bottom.equalTo(mScrollView);
                    make.height.mas_equalTo(mScrollView);
                }];
            }
        }
        [mButtonArray addObject:vButton];
        menuWidth += vButtonWidth;
        i++;
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    
    [mScrollView setContentSize:CGSizeMake(ScreenWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于屏幕宽度则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}

-(void)cleanButtons{
    for(UIView *view in mScrollView.subviews){
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    [mScrollView setContentOffset:CGPointMake(0, 0)];//还原
}
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
        
    }
}
#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    if(aIndex>=mButtonArray.count) return;
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    //[self menuButtonClicked:vButton];
    [self changeButtonStateAtIndex:vButton.tag];
}
#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    if(aIndex>=mButtonArray.count) return;
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}
#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
    if (mTotalWidth <= ScreenWidth) {
        return;
    }
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:NO];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:NO];
        }
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
        return;
    }
}
#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
    [self changeButtonStateAtIndex:aButton.tag];
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}
@end
