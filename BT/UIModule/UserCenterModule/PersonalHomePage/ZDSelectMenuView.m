//
//  Created by zdd. on 16/10/12.
//  Copyright © zdd.. All rights reserved.
//

#import "ZDSelectMenuView.h"

@interface ZDSelectMenuView (){
    NSInteger _allBtnCount;
    void (^_callBackBtn)(NSInteger index);//回调事件
}
@property (nonatomic, strong)UILabel *lineLabel; //选择滚动线条
@property (nonatomic, strong)UILabel *shadowLabel;//最低部的线
@property (nonatomic, strong)NSArray *imageArr;

@end

@implementation ZDSelectMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
        _allBtnCount = titleArr.count ? : imageArr.count;
        self.selectTextColor =  MainBg_Color;
        _unSelectTextColor = SecondColor;
        self.imageArr = imageArr;
        [self initWithTitleArr:titleArr imageNameArr:imageArr];
        self.selectIndex = 0;
        [AppHelper addBottomLineWithParentView:self];
    }
    return self;
}

- (void)initWithTitleArr:(NSArray *)titleArr imageNameArr:(NSArray *)imageNameArr{
    for (int i = 0; i < _allBtnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.width / _allBtnCount, 0, self.width / _allBtnCount , self.height);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.tag = i + 1000;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            [button setTitleColor:_selectTextColor forState:UIControlStateNormal];
            [button  addSubview:self.lineLabel];
        }else if (i == 1){
            [button setTitleColor:_unSelectTextColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:_unSelectTextColor forState:UIControlStateNormal];
        }
        [self addSubview:button];
    }
    
    
}
//
- (void)clickBtn:(UIButton *)btn{
    _callBackBtn(btn.tag - 1000);
    [self switchSelectButtonWithIndex:btn.tag - 1000];
    self.selectIndex = (btn.tag - 1000);
}
- (void)selectBtn:(void (^)(NSInteger))callBackBtn{
    _callBackBtn = callBackBtn;
}
/**
 *  切换当前按钮的选中状态
 *
 *  @param selectIndex 选中的按钮索引 0 代表私信，1 代表评论，2 代表回复
 *
 */
- (void)switchSelectButtonWithIndex:(NSInteger) selectIndex{
    UIButton *btn = (UIButton *)[self viewWithTag:selectIndex + 1000];
    for (int i = 0; i < _allBtnCount; i++) {
        if (selectIndex == i) {
            [UIView animateWithDuration:0.2 animations:^{
                [btn setTitleColor:_selectTextColor forState:UIControlStateNormal];
                self.lineLabel.centerX = self.width / _allBtnCount * (0.5 + i);
            }];
        }else{
            UIButton *button = (UIButton *)[self viewWithTag:i + 1000];
           [button setTitleColor:_unSelectTextColor forState:UIControlStateNormal];
        }
    }
}
- (void)changeSelectButtonWithIndex:(NSInteger) selectIndex{
    
    UIButton *btn = (UIButton *)[self viewWithTag:selectIndex + 1000];
    for (int i = 0; i < _allBtnCount; i++) {
        if (selectIndex == i) {
            [btn setTitleColor:_selectTextColor forState:UIControlStateNormal];
            
        }
    }
}
#pragma mark --- 横线动画
////滚动线的高度
//- (void)setLineHeight:(CGFloat)lineHeight{
//    if (_lineHeight != lineHeight) {
//        _lineHeight = lineHeight;
//    }
//    self.lineLabel.mj_y = self.height - lineHeight;
//   // self.lineLabel.height = lineHeight;
//}
//滚动线 的颜色
- (void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
    }
    self.lineLabel.backgroundColor = lineColor;
}

//底部线的显隐性
-(void)setShowShadowLabelHidde:(BOOL)showShadowLabelHidde{
    if (_showShadowLabelHidde != showShadowLabelHidde) {
        _showShadowLabelHidde = showShadowLabelHidde;
    }
    self.shadowLabel.hidden = showShadowLabelHidde;
}
////选中的文字颜色
//-(void)setSelectTextColor:(UIColor *)selectTextColor{
//    //if (_selectTextColor != selectTextColor) {
//    //    _selectTextColor = selectTextColor;
//    //}
////    _selectTextColor = [UIColorHex(333333) colorWithAlphaComponent:0.95];
//    _selectTextColor = MainBg_Color;
//    [self switchSelectButtonWithIndex:0];
//}
//未选中的文字颜色
//-(void)setUnSelectTextColor:(UIColor *)unSelectTextColor{
//    if (_unSelectTextColor != unSelectTextColor) {
//        _unSelectTextColor = unSelectTextColor;
//    }
//    [self switchSelectButtonWithIndex:0];
//}

- (void)setShowLineHidde:(BOOL)showLineHidde{
    if (_showLineHidde != showLineHidde) {
        _showLineHidde = showLineHidde;
    }
    self.lineLabel.hidden = showLineHidde;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.lineLabel.width = lineWidth;
}

#pragma mark - getter /setter
- (UILabel *)lineLabel{
    if (!_lineLabel) {
        CGFloat width = 24;
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height - 4,width, 2)];
        _lineLabel.backgroundColor =  MainBg_Color;
        _lineLabel.centerX  = self.width / _allBtnCount * 0.5 ;
    }
    return _lineLabel;
}
- (UILabel *)shadowLabel{
    if (!_shadowLabel) {
        _shadowLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, self.height - 0.5, ScreenWidth + 50, 0.5)];
        _shadowLabel.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _shadowLabel;
}

@end
