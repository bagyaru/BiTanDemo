//
//  NewsHeadView.m
//  BT
//
//  Created by admin on 2018/3/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsHeadView.h"
#import "OneTopicview.h"
@implementation NewsHeadView

-(void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(dataArray.count*200, 0);
    //_contentY = (_CNXHDataArray.count+1)*160-Main_Screen_Width-70;
    //_scrollView.delegate = self;
    
    for (UIView *subview in _scrollView.subviews)
    {
        
        [subview removeFromSuperview];
        
    }
    for (int i = 0; i<dataArray.count; i++) {
        FastInfomationObj *obj = dataArray[i];
        OneTopicview *view = [OneTopicview loadFromXib];
        view.frame = CGRectMake(200*i, 0, 200, 200);
        view.goDetailBtn.tag = 1000+i;
        [view.imageIV sd_setImageWithURL:[NSURL URLWithString:obj.imgUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
        ViewRadius(view.imageIV, 3);
        view.titleL.text =  obj.title;
        view.titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        view.numberL.text = [NSString stringWithFormat:@"%ld人浏览",obj.viewCount];
        [view.goDetailBtn addTarget:self action:@selector(goDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:view];
        
    }
}
-(void)goDetailBtnClick:(UIButton *)btn {
    FastInfomationObj *obj = _dataArray[btn.tag-1000];
    if (self.goDetailBlack) {
        
        self.goDetailBlack(obj.infoID);
    }
}
@end
