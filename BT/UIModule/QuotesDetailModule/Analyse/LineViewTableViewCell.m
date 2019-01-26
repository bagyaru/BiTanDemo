//
//  LineViewTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LineViewTableViewCell.h"
#import "LRSChartView.h"

#import "BTCoinHolderHeader.h"
#import "NSDate+Extent.h"
#import "FutureLineChartView.h"
@interface LineViewTableViewCell()

@property (nonatomic, strong) FutureLineChartView *incomeChartLineView;

@property (nonatomic, strong) BTCoinHolderHeader *headerView;

@property (nonatomic, strong) UILabel *leftTimeL;
@property (nonatomic, strong) UILabel *rightTimeL;
@property (nonatomic, strong) NSArray *addressData;


@end

@implementation LineViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(46.0f);
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

- (BTCoinHolderHeader*)headerView{
    if(!_headerView){
        _headerView = [BTCoinHolderHeader loadFromXib];
        [_headerView layoutIfNeeded];
    }
    return _headerView;
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    if(info){
        if(self.isNoDetail){
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40.0f);
            }];
            self.headerView.rightView.hidden = YES;
            self.headerView.indicatorL.hidden = YES;
            self.headerView.topCons.constant = 0;
        }
        NSArray *addressList = info[@"addressList"];
        if(addressList.count>0){
            NSMutableArray *addressData = @[].mutableCopy;
            NSMutableArray *priceData = @[].mutableCopy;
            NSMutableArray *dateArr = @[].mutableCopy;

            for(NSDictionary *address in addressList){
                [addressData addObject:@([SAFESTRING(address[@"number"]) doubleValue])];
                [dateArr addObject: [NSDate getTimeStrFromInterval:SAFESTRING(address[@"date"]) andFormatter:nil]];
            }
            NSArray* afterPriceData = [[priceData reverseObjectEnumerator] allObjects];
            NSArray* afterDateArr = [[dateArr reverseObjectEnumerator] allObjects];
            
            NSArray *afterAddressData = [[addressData reverseObjectEnumerator] allObjects];
            if(addressList.count >0){
                [self createIncomeChartLineViewWithNumsArr:afterAddressData priceArr:afterPriceData xArr:afterDateArr];
            }
            self.leftTimeL.text = [afterDateArr firstObject];
            self.rightTimeL.text = [afterDateArr lastObject];
        }
    }
}
/**创建“收益走势”图*/
-(void)createIncomeChartLineViewWithNumsArr:(NSArray*)numsArr priceArr:(NSArray*)priceArr xArr:(NSArray*)xArr{
    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[FutureLineChartView class]]){
            [view removeFromSuperview];
        }
    }
    NSArray *tempDataArrOfY =@[];
    if(numsArr.count >0){
        tempDataArrOfY = @[numsArr];
    }
    
    NSArray *tempDataArrRightOfY =@[numsArr];
    _incomeChartLineView = [[FutureLineChartView alloc]initWithFrame:CGRectMake(0, self.isNoDetail?40:55, ScreenWidth, 276)];
    //是否可以浮动
    _incomeChartLineView.chartMargin = UIEdgeInsetsMake(30, 0, 46, 15);
    _incomeChartLineView.originDataArr = numsArr;
    _incomeChartLineView.singleTitle = [APPLanguageService sjhSearchContentWith:@"dizhishu"];
    _incomeChartLineView.isFloating = YES;
    _incomeChartLineView.isHoldCount = YES;
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
    //_incomeChartLineView.isFloating = YES;
    //折线图数据
//    _incomeChartLineView.leftDataArr = tempDataArrOfY;
    _incomeChartLineView.rightDataArr = tempDataArrRightOfY;
    
    //折线图所有颜色
//    _incomeChartLineView.leftColorStrArr = @[@"#4d87ea"];
    _incomeChartLineView.rightColorStrArr = @[@"#4d87ea"];
    //设置折线样式
    _incomeChartLineView.chartViewStyle = LRSChartViewLeftRightLine;
    //设置图层效果
    _incomeChartLineView.chartLayerStyle = LRSChartGradient;
    //设置折现效果
    _incomeChartLineView.lineLayerStyle = LRSLineLayerNone;
    //渐变效果的颜色组
    _incomeChartLineView.colors = @[@[[UIColor colorWithHexString:@"#febf83"],[UIColor greenColor]],@[[UIColor colorWithHexString:@"#53d2f8"],[UIColor blueColor]]];
    //渐变开始比例
    _incomeChartLineView.proportion = 0.5;
    //底部日期
    _incomeChartLineView.dataArrOfX = xArr;
    //开始画图
    [_incomeChartLineView show];
    [self.contentView addSubview:_incomeChartLineView];
}

@end
