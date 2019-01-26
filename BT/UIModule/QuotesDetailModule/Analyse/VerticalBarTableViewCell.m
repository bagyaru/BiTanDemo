//
//  VerticalBarTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VerticalBarTableViewCell.h"
#import "BarView.h"
#import "DVPieChart.h"
#import "DVFoodPieModel.h"

//柱形图的宽度
#define BarW RELATIVE_WIDTH(20)
//柱形图最大高度
#define BarH RELATIVE_WIDTH(195)
//柱形图之间的间距
#define BarMargin RELATIVE_WIDTH(44)

//界面的总高度
#define ViewH RELATIVE_WIDTH(240 + 55)

@interface VerticalBarTableViewCell ()

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *heightArray;

@property (nonatomic,strong) NSMutableArray *barArray;

@property (nonatomic,strong) NSMutableArray *xLabelArray;

@end


@implementation VerticalBarTableViewCell

-(NSMutableArray *)xLabelArray{
    if (!_xLabelArray) {
        _xLabelArray = [NSMutableArray array];
    }
    return _xLabelArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *firstBgView = [UIView new];
        [self.contentView addSubview:firstBgView];
        firstBgView.backgroundColor = [UIColor whiteColor];
        [firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_offset(46);
        }];
        [AppHelper addLeftLineWithParentView:firstBgView];
        UIView *topBgView = [UIView new];
        topBgView.backgroundColor = kHEXCOLOR(0xf5f5f5);
        [firstBgView addSubview:topBgView];
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(firstBgView);
            make.height.mas_offset(6);
        }];
        
        UILabel *mainTipLabel = [UILabel new];
        [firstBgView addSubview:mainTipLabel];
        mainTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        mainTipLabel.textColor = kHEXCOLOR(0x111210);
        mainTipLabel.text = [APPLanguageService wyhSearchContentWith:@"jiaoyiduizhanbi24h"];
        [mainTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstBgView).offset(15);
            make.top.equalTo(topBgView.mas_bottom).offset(10);
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
//        [self drawDottedLineY];
        
    }
    return self;
}

//画柱形  添加柱形上面的提示label
- (void)strokeChart{
    
    self.barArray = [NSMutableArray array];
    CGFloat barX = 0;
    NSMutableArray *numArr = @[].mutableCopy;
    
    for(NSDictionary *dict in self.info){
        NSString *rate = SAFESTRING(dict[@"rate"]);
        double num =  [rate doubleValue];
        [numArr addObject:SAFESTRING(@(num))];
    }
    
    for (int i = 0; i< self.info.count; i++) {
        NSDictionary *dict = self.info[i];
        barX = RELATIVE_WIDTH(15) + (BarW+BarMargin)*i;
        BarView *bar = [[BarView alloc] initWithFrame:CGRectMake(barX, RELATIVE_WIDTH(60), BarW, BarH)];
        [self addSubview:bar];
        //百分比
        bar.percent = [numArr[i] floatValue];
        [bar strokePath];
        [self.barArray addObject:bar];
        
        NSString *text =[NSString stringWithFormat:@"%.2f%%",[SAFESTRING(dict[@"rate"]) floatValue]*100];
        if([SAFESTRING(dict[@"rate"]) floatValue]*100 <0.01){
            text = [NSString stringWithFormat:@"<0.01%%"];
        }
        //添加柱形上面的label
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = FONTOFSIZE(10);
        label.textColor = kHEXCOLOR(0x108ee9);
        label.text = text;
        label.frame = CGRectMake(0, bar.endYPos+RELATIVE_WIDTH(45), [self getLabelWidth:label labelStr:text], RELATIVE_WIDTH(14));
        label.center = CGPointMake(bar.center.x, label.center.y);
        
    }
}

//
- (void)setInfo:(NSArray *)info{
    _info = info;
    if(info){
        for(UIView *subView in self.contentView.subviews){
            if([subView isKindOfClass:[UILabel class]]||[subView isKindOfClass:[DVPieChart class]]){
                [subView removeFromSuperview];
            }
        }
        NSMutableArray *xLabels = @[].mutableCopy;
        for(NSDictionary *dict in info){
            NSString *key = dict[@"key"];
            if([key isEqualToString:@"other"]){
                key = [APPLanguageService sjhSearchContentWith:@"qita"];
            }
            [xLabels addObject:key];
        }
        
        [self setChart];
        //
//        [self strokeChart];
//        [self setXLabels:xLabels];
    }
}

- (void)setChart{
    NSArray *arr = [self.info sortedArrayUsingComparator:^NSComparisonResult(NSDictionary  *obj1, NSDictionary *obj2) {
        NSNumber *rate1 = [SAFESTRING(obj1[@"rate"]) numberValue];
        NSNumber *rate2 = [SAFESTRING(obj2[@"rate"]) numberValue];
        return [rate2 compare:rate1];
    }];
    DVPieChart *chart = [[DVPieChart alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, 245.0f)];
    [self.contentView addSubview:chart];
    NSMutableArray *dataArr = @[].mutableCopy;
    NSInteger i = 0;
    for(NSDictionary *dict in arr){
        NSString *key = dict[@"key"];
        if([key isEqualToString:@"other"]){
            key = [APPLanguageService sjhSearchContentWith:@"qita"];
        }
        DVFoodPieModel *model = [[DVFoodPieModel alloc] init];
        model.name = key;
        model.rate = [SAFESTRING(dict[@"rate"]) floatValue];
        model.afterRate = model.rate;
        if(model.rate < 0.02){
            i++;
            model.afterRate+= 0.04;
        }
        [dataArr addObject:model];
    }
    if(i >=2){
        NSInteger j =0;
        for(DVFoodPieModel *model in dataArr){
            if(j < i){
                model.afterRate -= 0.04;
                if(model.afterRate <0.04){
                    model.afterRate += 0.04;
                    DVFoodPieModel *firstModel = dataArr.firstObject;
                    firstModel.afterRate -= 0.04;
                }
                
            }
            j++;
        }
    }
    chart.dataArray = dataArr;
    [chart draw];
}

//画X轴的数据label
-(void)setXLabels:(NSArray *)xLabels{
    //44为柱形之间的间距   20为柱形的宽度
    CGFloat xMargin = BarMargin + BarW;
    for (int i = 0; i< xLabels.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = kHEXCOLOR(0x111210);
        label.text = xLabels[i];
        CGFloat labelW = [self getLabelWidth:label labelStr:xLabels[i]];
        label.frame = CGRectMake((15+10)+xMargin*i - labelW/2, RELATIVE_WIDTH(295.0f)-40+5, labelW, 14);
    }
}

//画Y轴的虚线
-(void)drawDottedLineY{
    
    //y轴间距
    CGFloat yMargin = RELATIVE_WIDTH(40);
    
    for (int i = 0; i<5; i++) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(RELATIVE_WIDTH(25), (i+1)*yMargin + RELATIVE_WIDTH(55), ScreenWidth - RELATIVE_WIDTH(25)*2, RELATIVE_WIDTH(1))];
        [self addSubview:lineView];
        [self drawDashLine:lineView lineLength:5 lineSpacing:10 lineColor:kHEXCOLOR(0xdddddd)];
    }
}

//画虚线
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

-(CGFloat)getLabelWidth:(UILabel*)label  labelStr:(NSString*)text{
    return [text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
}


@end
