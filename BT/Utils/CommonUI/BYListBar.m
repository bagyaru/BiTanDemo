//
//  BYConditionBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYListBar.h"

#define kDistanceBetweenItem 40
#define kIndicatorWidth 24
#define kExtraPadding 20
#define itemFont 14
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface BYListBar()

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) NSMutableArray *btnLists;
@property (nonatomic, strong) NSMutableArray *unreadLabelLists;

@end

@implementation BYListBar

-(NSMutableArray *)btnLists{
    if (_btnLists == nil) {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}
-(NSMutableArray *)unreadLabelLists {
    
    if (_unreadLabelLists == nil) {
        _unreadLabelLists = [NSMutableArray array];
    }
    return _unreadLabelLists;
}
- (void)setVisibleItemList:(NSMutableArray *)visibleItemList{
    
    _visibleItemList = visibleItemList;
    if(_visibleItemList.count == 0) return;
    if (!self.btnBackView) {
        self.btnBackView = [[UIView alloc] initWithFrame:CGRectMake(10,self.frame.size.height - 4,15,2.0)];
        self.btnBackView.backgroundColor = kHEXCOLOR(0x108ee9);
        [self addSubview:self.btnBackView];
        
        //适配
        if(self.isFuture){
            if(self.visibleItemList.count <=4){
                self.maxWidth = 0;
            }else{
                self.maxWidth = 15;
            }
        }else{
            self.maxWidth = 15;
        }
        
        
        self.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;
        for (int i =0; i<visibleItemList.count; i++) {
            
            [self makeItemWithTitle: visibleItemList[i] row:i];
        }
        UIButton *btnFirst = (UIButton *)self.btnLists[0];
        CGRect btnBackViewRect = self.btnBackView.frame;
        btnBackViewRect.size.width = kIndicatorWidth;
        self.btnBackView.frame = btnBackViewRect;
        CGFloat changeW = btnFirst.frame.origin.x-(btnBackViewRect.size.width-btnFirst.frame.size.width)/2-10;
        self.btnBackView.transform  = CGAffineTransformMakeTranslation(changeW, 0);
        self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }
}
-(void)setUnreadNumList:(NSMutableArray *)unreadNumList {
    _unreadNumList = unreadNumList;
    for (int i = 0; i < unreadNumList.count; i++) {
        
        BTLabel *labelUnread = (BTLabel *)self.unreadLabelLists[i];
        NSInteger unread = [unreadNumList[i] integerValue];
        labelUnread.hidden = unread <= 0;
        labelUnread.text   = unread > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",unread];;
    }
}
- (void)makeItemWithTitle:(NSString *)title row:(NSInteger)row{
    //适配期货的
    if(self.isFuture){
        CGFloat itemW;
        CGFloat MessageCenter_ItemW;
        NSInteger count = self.visibleItemList.count;
        if(count <=4){
            itemW = ScreenWidth / self.visibleItemList.count;
        }else{
            itemW = [self calculateSizeWithFont:self.isSheQu ? 16 : itemFont Text:title].size.width;
        }
        BTButton *item = [[BTButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
        item.tag = row;
        item.titleLabel.font = [UIFont systemFontOfSize:self.isSheQu ? 16 : itemFont];
        [item setTitle:title forState:UIControlStateNormal];
        
        [item setTitleColor:self.isSheQu ? SecondColor : ThirdColor forState:UIControlStateNormal];
        [item setTitleColor:MainBg_Color forState:UIControlStateSelected];
        [item addTarget:self
                 action:@selector(itemClick:)
       forControlEvents:1 << 6];
        
        if (self.isMessageCenter) {
            CGFloat titleW = [self calculateSizeWithFont:itemFont Text:title].size.width;
            MessageCenter_ItemW = (titleW + itemW)/2+itemW*row;
            
            BTLabel *labelNum = [[BTLabel alloc] init];
            labelNum.frame = CGRectMake(MessageCenter_ItemW, 5, 20, 12);
            labelNum.hidden = YES;
            labelNum.font = SYSTEMFONT(10);
            labelNum.textColor = KWhiteColor;
            labelNum.textAlignment = NSTextAlignmentCenter;
            ViewRadius(labelNum, 6);
            labelNum.backgroundColor = kHEXCOLOR(0xE8003F);
            [self.unreadLabelLists addObject:labelNum];
            [self addSubview:labelNum];
            
        }
        if(count <=4){
            self.maxWidth += ScreenWidth / self.visibleItemList.count;
        }else{
            if(self.visibleItemList.count >5){
                self.maxWidth += itemW+30.0f;
            }else{
                self.maxWidth += itemW+kDistanceBetweenItem;
            }
        }
        [self.btnLists addObject:item];
        [self addSubview:item];
        if (!self.btnSelect) {
            [item setTitleColor:self.isSheQu ? SecondColor : ThirdColor forState:0];
            self.btnSelect = item;
            self.btnSelect.selected = YES;
        }
        self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }else{
        CGFloat itemW;
        if (row < 2) {
            itemW = [self calculateSizeWithFont:itemFont Text:[APPLanguageService sjhSearchContentWith:title]].size.width;
            // 修改 根据是否全网或者交易所来判断
            if(![self.exchangeCode isEqualToString:k_Net_Code]){
                if(row ==1){
                    itemW = [self calculateSizeWithFont:itemFont Text:title].size.width;
                }
                if(row ==0){
                    itemW = [self calculateSizeWithFont:itemFont Text:title].size.width;
                }
                
            }
        }else{
            itemW = [self calculateSizeWithFont:itemFont Text:title].size.width;
        }
        
        BTButton *item = [[BTButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
        item.tag = row;
        item.titleLabel.font = [UIFont systemFontOfSize:itemFont];
        //    [item setTitle:title forState:0];
        if (row < 2) {
            item.fixTitle = title;
            //xiugai
            if(![self.exchangeCode isEqualToString:k_Net_Code]){
                if(row ==1){
                    [item setTitle:title forState:UIControlStateNormal];
                }
                if(row ==0){
                    [item setTitle:title forState:UIControlStateNormal];
                }
            }
        }else{
            [item setTitle:title forState:UIControlStateNormal];
        }
        [item setTitleColor:ThirdColor forState:UIControlStateNormal];
        [item setTitleColor:MainBg_Color forState:UIControlStateSelected];
        [item addTarget:self
                 action:@selector(itemClick:)
       forControlEvents:1 << 6];
        
        //if(row == self.visibleItemList.count - 1){
            //self.maxWidth += itemW +15;
        //}else{
            self.maxWidth += itemW+kDistanceBetweenItem;
        //}
        [self.btnLists addObject:item];
        [self addSubview:item];
        if (!self.btnSelect) {
            [item setTitleColor:ThirdColor forState:0];
            self.btnSelect = item;
            self.btnSelect.selected = YES;
        }
       self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }
    
}


-(void)itemClick:(UIButton *)sender{
    //if (self.btnSelect != sender) {
        self.btnSelect.selected = NO;
        sender.selected = YES;
        
    //        [self.btnSelect setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
    //        [sender setTitleColor:[UIColor whiteColor] forState:0];
    self.btnSelect = sender;
    
    if (self.listBarItemClickBlock) {
        self.listBarItemClickBlock(sender.titleLabel.text,sender.tag);//[self findIndexOfListsWithTitle:sender.titleLabel.text]
    }
    //}
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect btnBackViewRect = self.btnBackView.frame;
        btnBackViewRect.size.width = kIndicatorWidth;
        self.btnBackView.frame = btnBackViewRect;
        CGFloat changeW = sender.frame.origin.x-(btnBackViewRect.size.width-sender.frame.size.width)/2-10;
        self.btnBackView.transform  = CGAffineTransformMakeTranslation(changeW, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;
            if (sender.frame.origin.x >= kScreenW - 150 && sender.frame.origin.x < self.contentSize.width-200) {
                changePoint = CGPointMake(sender.frame.origin.x - 200, 0);
            }
            else if (sender.frame.origin.x >= self.contentSize.width-200){
                if(self.visibleItemList.count >= 5){//适配多个
                    changePoint = CGPointMake(self.contentSize.width-350, 0);
                }else{
                    changePoint = CGPointMake(0, 0);
                }
            }else{
                changePoint = CGPointMake(0, 0);
            }
            self.contentOffset = changePoint;
        }];
    }];
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index{
    if(index>= self.btnLists.count) return;
    UIButton *item = (UIButton *)self.btnLists[index];
    item.tag =  index;
    [self itemClick:item];
}

-(void)operationFromBlock:(animateType)type itemName:(NSString *)itemName index:(int)index{
    switch (type) {
        case topViewClick:
            [self itemClick:self.btnLists[[self findIndexOfListsWithTitle:itemName]]];
            if (self.arrowChange) {
                self.arrowChange();
            }
            break;
        case FromTopToTop:
            [self switchPositionWithItemName:itemName index:index];
            break;
        case FromTopToTopLast:
            [self switchPositionWithItemName:itemName index:self.visibleItemList.count-1];
            break;
        case FromTopToBottomHead:
            if ([self.btnSelect.titleLabel.text isEqualToString:itemName]) {
                [self itemClick:self.btnLists[0]];
            }
            [self removeItemWithTitle:itemName];
            [self resetFrame];
            break;
        case FromBottomToTopLast:
            [self.visibleItemList addObject:itemName];
            [self makeItemWithTitle:itemName row:index];
            break;
        default:
            break;
    }
}

-(void)switchPositionWithItemName:(NSString *)itemName index:(NSInteger)index{
    UIButton *button = self.btnLists[[self findIndexOfListsWithTitle:itemName]];
    [self.visibleItemList removeObject:itemName];
    [self.btnLists removeObject:button];
    [self.visibleItemList insertObject:itemName atIndex:index];
    [self.btnLists insertObject:button atIndex:index];
    [self itemClick:self.btnSelect];
    [self resetFrame];
}

-(void)removeItemWithTitle:(NSString *)title{
    NSInteger index = [self findIndexOfListsWithTitle:title];
    UIButton *select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:title];
}

-(NSInteger)findIndexOfListsWithTitle:(NSString *)title{
    for (int i =0; i < self.visibleItemList.count; i++) {
        if ([title isEqualToString:self.visibleItemList[i]]) {
            return i;
        }
    }
    return 0;
}

-(void)resetFrame{
    self.maxWidth = 15;
    for (int i = 0; i < self.visibleItemList.count; i++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat itemW = [self calculateSizeWithFont:itemFont Text:self.visibleItemList[i]].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += kDistanceBetweenItem + itemW;
        } completion:^(BOOL finished){
        }];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
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
