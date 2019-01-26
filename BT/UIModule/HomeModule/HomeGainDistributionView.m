//
//  HomeGainDistributionView.m
//  BT
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeGainDistributionView.h"
#import "BarView.h"
//柱形图的宽度
#define BarW 14
//柱形图最大高度
#define BarH 106-28-15-12
//柱形图之间的间距
#define BarMargin (ScreenWidth-BarW*12)/13

//界面的总高度
#define ViewH 106

@interface HomeGainDistributionView ()

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *barArray;
@property (nonatomic,strong) NSMutableArray *xLabelArray;
@property (nonatomic,strong) NSArray *BFBArray;
@end

@implementation HomeGainDistributionView
-(NSMutableArray *)xLabelArray{
    if (!_xLabelArray) {
        _xLabelArray = [NSMutableArray array];
    }
    return _xLabelArray;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    //self.heightArray = @[@(0.2),@(0.5),@(0.18),@(1.0),@(0.6),@(0.3),@(0.2),@(0.5),@(0.18),@(0.9),@(0.6),@(0.3)];
    
    //[self drawDottedLineY];
    
    //[self strokeChart];
}

//画柱形  添加柱形上面的提示label
-(void)strokeChart{
    
    [self drawDown_X];
    
    self.barArray = [NSMutableArray array];
    CGFloat barX = 0;
    for (int i = 0; i<self.heightArray.count; i++) {
        
        barX = 18 + (BarW+BarMargin)*i;
        BarView *bar = [[BarView alloc] initWithFrame:CGRectMake(barX, 15+12, BarW, BarH)];
        [self addSubview:bar];
        
        //百分比
        bar.percent = [self.heightArray[i] floatValue];
        
        [bar strokePath:i];
        
        [self.barArray addObject:bar];
        
        //添加柱形上面的label
        NSString *text = [NSString stringWithFormat:@"%ld",[self.numbArray[i] integerValue]];
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = i > 5 ? CFallColor : CRiseColor;
        label.text = text;
        NSLog(@"%.0f %.0f",bar.endYPos,bar.endYPos);
        label.frame = CGRectMake(0, bar.endYPos+12, [self getLabelWidth:label labelStr:text], 10);
        label.center = CGPointMake(bar.center.x, label.center.y);
        
    }
}
//画X轴_首页
-(void)drawDown_X {
    
    self.BFBArray = @[@"10%",@"8%",@"6%",@"4%",@"2%",@"0%",@"-2%",@"-4%",@"-6%",@"-8%",@"-10%"];
    //绘制x轴label
    //柱形之间间距是BarMargin   每个矩形是10宽度
    NSLog(@"%d",ViewH);
    CGFloat xMargin = BarMargin + BarW;
    for (int i = 0; i< self.BFBArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = kHEXCOLOR(0x111210);
        label.text = self.BFBArray[i];
        CGFloat labelW = [self getLabelWidth:label labelStr:self.BFBArray[i]];
        //第一个距离左边是18  每个柱形宽度是10
        label.frame = CGRectMake(18+xMargin*(i+1)-(labelW+BarMargin)/2, ViewH-23, labelW, 11);
        [self.xLabelArray addObject:label];
        UILabel *lineL_H = [[UILabel alloc] init];
        [self addSubview:lineL_H];
        lineL_H.backgroundColor = kHEXCOLOR(0xdddddd);
        lineL_H.frame = CGRectMake(18+BarW+xMargin*i, ViewH-28.5, BarMargin, 0.5);
        
        UILabel *lineL_S = [[UILabel alloc] init];
        [self addSubview:lineL_S];
        lineL_S.backgroundColor = kHEXCOLOR(0xdddddd);
        lineL_S.frame = CGRectMake(18+BarW+BarMargin/2+xMargin*i, ViewH-29-3, 0.5, 3);
    }
}

-(CGFloat)getLabelWidth:(UILabel*)label  labelStr:(NSString*)text{
    return [text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
}

@end
