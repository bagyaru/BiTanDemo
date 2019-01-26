//
//  BTDistributeCell.m
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDistributeCell.h"
#import "LRSChartView.h"
#import "BTDistHeaderView.h"
#import "BTCoinHolderHeader.h"
#import "NSDate+Extent.h"
#import "FutureLineChartView.h"

@interface BTDistributeCell()

@property (nonatomic, strong) FutureLineChartView *incomeChartLineView;

@property (nonatomic, strong) BTDistHeaderView *headerView;

@property (nonatomic, strong) UILabel *leftTimeL;
@property (nonatomic, strong) UILabel *rightTimeL;
@property (nonatomic, strong) NSArray *tenData;
@property (nonatomic, strong) NSArray *fiftyData;
@property (nonatomic, strong) NSArray *hundredData;

@end
@implementation BTDistributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(80.0f);
        }];
        [self.contentView addSubview:self.leftTimeL];
        [self.contentView addSubview:self.rightTimeL];
        [self.leftTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-19);
        }];
        [self.rightTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-19);
        }];
    }
    return self;
}

- (UILabel*)leftTimeL{
    if(!_leftTimeL){
        _leftTimeL = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:kHEXCOLOR(0x111210)];
    }
    return _leftTimeL;
}

- (UILabel*)rightTimeL{
    if(!_rightTimeL){
        _rightTimeL = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:kHEXCOLOR(0x111210)];
    }
    return _rightTimeL;
}

- (BTDistHeaderView*)headerView{
    if(!_headerView){
        _headerView = [BTDistHeaderView loadFromXib];
        [_headerView layoutIfNeeded];
    }
    return _headerView;
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    if(info){
        NSArray *topTenList = info[@"topTen"];
        NSArray *topFiftyList = info[@"topFifty"];
        NSArray *topHundredList = info[@"topHundred"];
        if(topTenList.count>0){
            NSMutableArray *topFiftyData = @[].mutableCopy;
            NSMutableArray *topTenData = @[].mutableCopy;
            NSMutableArray *dateArr = @[].mutableCopy;
            NSMutableArray *topHundredData = @[].mutableCopy;
            
            for(NSDictionary *price in topTenList){
                [topTenData addObject:@([SAFESTRING(price[@"rate"]) doubleValue])];
                [dateArr addObject: [NSDate getTimeStrFromInterval:SAFESTRING(price[@"date"]) andFormatter:nil]];
            }
            NSArray* afterTopTenData = [[topTenData reverseObjectEnumerator] allObjects];
            NSArray* afterDateArr = [[dateArr reverseObjectEnumerator] allObjects];
            NSArray *topTenReverse = [[topTenList reverseObjectEnumerator] allObjects];
            if(topFiftyList.count >0){
                //初始值
                for (NSDictionary *price in topTenReverse) {
                    NSString *priceTime = [NSDate getTimeStrFromInterval:SAFESTRING(price[@"date"]) andFormatter:nil];
                    BOOL isExist = NO;
                    for(NSDictionary *address in topFiftyList){
                        NSString *addressTime = [NSDate getTimeStrFromInterval:SAFESTRING(address[@"date"]) andFormatter:nil];;
                        if([addressTime isEqualToString:priceTime]){
                            isExist = YES;
                            [topFiftyData addObject:@([SAFESTRING(address[@"rate"]) doubleValue])];
                            break;
                        }else{
                            isExist = NO;
                        }
                    }
                    if(!isExist){
                        [topFiftyData addObject:@(0)];
                    }
                }
            }
            
            if(topHundredList.count >0){
                //初始值
                for (NSDictionary *price in topTenReverse) {
                    NSString *priceTime = [NSDate getTimeStrFromInterval:SAFESTRING(price[@"date"]) andFormatter:nil];
                    BOOL isExist = NO;
                    for(NSDictionary *address in topHundredList){
                        NSString *addressTime = [NSDate getTimeStrFromInterval:SAFESTRING(address[@"date"]) andFormatter:nil];;
                        if([addressTime isEqualToString:priceTime]){
                            isExist = YES;
                            [topHundredData addObject:@([SAFESTRING(address[@"rate"]) doubleValue])];
                            break;
                        }else{
                            isExist = NO;
                        }
                    }
                    if(!isExist){
                        [topHundredData addObject:@(0)];
                    }
                }
            }
            
            NSString *tenValue = SAFESTRING([afterTopTenData lastObject]);
            NSString *tenStr = @"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                tenStr = @"10名";
            }else{
                tenStr = @"Top 10";
            }
           
            NSString *countValue = [NSString stringWithFormat:@"%@：%.2f%%",tenStr,[tenValue doubleValue]];
            self.headerView.tenL.text = countValue;
            
            NSString *fiftyValue = SAFESTRING([topFiftyData lastObject]);
            if(fiftyValue.length == 0){
                fiftyValue = @"0.00";
            }
            NSString *fiftyStr =@"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                fiftyStr = @"50名";
            }else{
                fiftyStr = @"Top 50";
            }
            self.headerView.fiftyL.text =  [NSString stringWithFormat:@"%@：%.2f%%",fiftyStr,[SAFESTRING(fiftyValue) doubleValue]];
            
            NSString *hundredValue = SAFESTRING([topHundredData lastObject]);
            if(hundredValue.length == 0){
                hundredValue = @"0.00";
            }
            NSString *hundredStr = @"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                hundredStr = @"100名";
            }else{
                hundredStr = @"Top 100";
            }
            self.headerView.hundredL.text = [NSString stringWithFormat:@"%@：%.2f%%",hundredStr,[SAFESTRING(hundredValue) doubleValue]];
            if(topTenList.count >0){
                [self createIncomeChartLineViewWithTenArr:afterTopTenData fiftyArr:topFiftyData hundredArr:topHundredData xArr:afterDateArr];
            }
            
            //
            self.tenData = afterTopTenData;
            self.fiftyData = topFiftyData;
            self.hundredData = topHundredData;
            
            self.leftTimeL.text = [afterDateArr firstObject];
            self.rightTimeL.text = [afterDateArr lastObject];
        }
    }
}

/**创建“收益走势”图*/
- (void)createIncomeChartLineViewWithTenArr:(NSArray*)tenArr fiftyArr:(NSArray*)fiftyArr hundredArr:(NSArray*)hundredArr xArr:(NSArray*)xArr{
    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[FutureLineChartView class]]){
            [view removeFromSuperview];
        }
    }
    NSArray *tempDataArrRightOfY = @[tenArr,fiftyArr,hundredArr];
    _incomeChartLineView = [[FutureLineChartView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 260)];
    //是否可以浮动
    _incomeChartLineView.chartMargin = UIEdgeInsetsMake(5, 0, 46, 15);
    _incomeChartLineView.isFloating = YES;
    _incomeChartLineView.isNoShowGradient = YES;
    //设置X轴坐标字体大小
    _incomeChartLineView.x_Font = [UIFont systemFontOfSize:10];
    //设置X轴坐标字体颜色
    _incomeChartLineView.x_Color = TextColor;
    //设置Y轴坐标字体大小
    _incomeChartLineView.y_Font = [UIFont systemFontOfSize:10];
    //设置Y轴坐标字体颜色
    _incomeChartLineView.y_Color = TextColor;
    //设置X轴数据间隔
    _incomeChartLineView.Xmargin = 50;
    //设置背景颜色
    _incomeChartLineView.backgroundColor = [UIColor clearColor];
    //是否根据折线数据浮动泡泡
    //折线图数据
    _incomeChartLineView.rightDataArr = tempDataArrRightOfY;
    //折线图所有颜色
    _incomeChartLineView.rightColorStrArr = @[@"#108ee9",@"#e63a1a",@"#ff9800"];
    //设置折线样式
    _incomeChartLineView.chartViewStyle = LRSChartViewLeftRightLine;
    //设置图层效果
    _incomeChartLineView.chartLayerStyle = LRSChartGradient;
    //设置折现效果
    _incomeChartLineView.lineLayerStyle = LRSLineLayerNone;
    //底部日期
    _incomeChartLineView.dataArrOfX = xArr;
    //开始画图
    [_incomeChartLineView show];
    WS(ws)
    _incomeChartLineView.completion = ^(NSInteger index) {
        
        NSString *tenValue = SAFESTRING(ws.tenData[index]);
        NSString *tenStr = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            tenStr = @"10名";
        }else{
            tenStr = @"Top 10";
        }
        
        NSString *countValue = [NSString stringWithFormat:@"%@：%.2f%%",tenStr,[tenValue doubleValue]];
        ws.headerView.tenL.text = countValue;
        NSString *fiftyStr =@"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            fiftyStr = @"50名";
        }else{
            fiftyStr = @"Top 50";
        }
        if(index >=ws.fiftyData.count){
            ws.headerView.fiftyL.text = [NSString stringWithFormat:@"%@：%@%%",fiftyStr,SAFESTRING(@"0.00")];
        }else{
            NSString *fiftyValue = SAFESTRING(ws.fiftyData[index]);
            ws.headerView.fiftyL.text = [NSString stringWithFormat:@"%@：%.2f%%",fiftyStr,[SAFESTRING(fiftyValue) doubleValue]];
        }
        
        NSString *hundredStr = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            hundredStr = @"100名";
        }else{
            hundredStr = @"Top 100";
        }
        if(index >=ws.hundredData.count){
            ws.headerView.hundredL.text = [NSString stringWithFormat:@"%@：%@%%",hundredStr,SAFESTRING(@"0.00")];
        }else{
            NSString *hundredValue = SAFESTRING(ws.hundredData[index]);
            ws.headerView.hundredL.text = [NSString stringWithFormat:@"%@：%.2f%%",hundredStr,[SAFESTRING(hundredValue) doubleValue]];
        }
    };
    _incomeChartLineView.cancelBlock = ^{
        NSString *tenValue = SAFESTRING(ws.tenData.lastObject);
        NSString *tenStr = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            tenStr = @"10名";
        }else{
            tenStr = @"Top 10";
        }
        
        NSString *countValue = [NSString stringWithFormat:@"%@：%.2f%%",tenStr,[tenValue doubleValue]];
        ws.headerView.tenL.text = countValue;
        
        NSString *fiftyValue = SAFESTRING(ws.fiftyData.lastObject);
        if(fiftyValue.length == 0){
            fiftyValue = @"0.00";
        }
        NSString *fiftyStr =@"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            fiftyStr = @"50名";
        }else{
            fiftyStr = @"Top 50";
        }
        ws.headerView.fiftyL.text = [NSString stringWithFormat:@"%@：%.2f%%",fiftyStr,[SAFESTRING(fiftyValue) doubleValue]];
        
        NSString *hundredValue = SAFESTRING(ws.hundredData.lastObject);
        if(hundredValue.length == 0){
            hundredValue = @"0.00";
        }
        NSString *hundredStr = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            hundredStr = @"100名";
        }else{
            hundredStr = @"Top 100";
        }
        ws.headerView.hundredL.text = [NSString stringWithFormat:@"%@：%.2f%%",hundredStr,[SAFESTRING(hundredValue) doubleValue]];
    };
    [self.contentView addSubview:_incomeChartLineView];
}


@end
