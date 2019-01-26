//
//  BTMarketQuotationsView.m
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMarketQuotationsView.h"
#import "YKLineChart.h"
#import "FenshiView.h"
#import "FenshiModel.h"
#import "QuotesSegment.h"
#import "OptiontimeView.h"
#import "KLineHelper.h"
#import "UIScrollView+PSRefresh.h"
#import "BTViewRotationHeader.h"

@interface BTMarketQuotationsView()<YKLineChartViewDelegate,BTViewRotationHeaderDelegate>

@property (nonatomic, strong)YKLineDataSet *dataset;
@property (nonatomic, strong)YKLineChartView *klineView;
@property (nonatomic, strong)YKTimeLineView *timeLineView;
@property (nonatomic, strong)YKTimeDataset * timeDataset;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet BTLabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet BTLabel *numLabel;

@property (weak, nonatomic) IBOutlet BTLabel *rateLabel;

@property (weak, nonatomic) IBOutlet BTLabel *chengjiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *l24Label;

@property (weak, nonatomic) IBOutlet UILabel *h24Label;

@property (weak, nonatomic) IBOutlet UIView *viewSegment;

@property (weak, nonatomic) IBOutlet UIView *viewWarning;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewFenshi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollViewFenshiHeight;

//

@property (weak, nonatomic) IBOutlet BTLabel *labelTimeInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeWarning;
@property (weak, nonatomic) IBOutlet UILabel *labelWarningCount;

@property (weak, nonatomic) IBOutlet UILabel *labelWarningPrice;

////

@property (weak, nonatomic) IBOutlet UIView *viewWarningRotation;
@property (weak, nonatomic) IBOutlet UILabel *labelWarningOpen;
@property (weak, nonatomic) IBOutlet UILabel *labelWarningHigh;
@property (weak, nonatomic) IBOutlet UILabel *labelWarningMin;
@property (weak, nonatomic) IBOutlet UILabel *labelWarningClose;
@property (weak, nonatomic) IBOutlet UILabel *lableCountRotation;
@property (weak, nonatomic) IBOutlet UILabel *labelRotationTime;


//// 全屏

@property (strong, nonatomic) BTViewRotationHeader *viewRotationHeader;
@property (nonatomic, strong) UIView *viewRotation;
@property (nonatomic, assign) BOOL isFullScreen;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewFenshiWidth;


@property (nonatomic, strong) QuotesSegment *quotesSegmentView;
@property (nonatomic, strong) OptiontimeView *optiontimeView;
@property (nonatomic, strong) FenshiView *viewFenshi;

@property (nonatomic, assign) BOOL isShowFenshiOption;


@end

@implementation BTMarketQuotationsView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.isShowFenshiOption =YES;
    self.viewWarningRotation.backgroundColor = CShowPriceColor;
    [self configView];
    [self configKLineView];
    [self configTimeDataSet];
    [self configKLineDataSet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarning:) name:NSNotification_ShowWarningView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noShowWarning) name:NSNotification_noShowWarningView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarningRotation:) name:NSNotification_ShowWarningRotationView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noShowWarningRotation) name:NSNotification_noShowWarningRotationView object:nil];
}

- (void)configKLineDataSet{
    self.dataset = [[YKLineDataSet alloc]init];
    self.dataset.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    self.dataset.highlightLineWidth = 0.7;
    self.dataset.candleRiseColor = CGreenColor;
    self.dataset.candleFallColor = CRedColor;
    self.dataset.avgLineWidth = 1.f;
    self.dataset.avgMA10Color = [UIColor colorWithRed:252/255.0 green:85/255.0 blue:198/255.0 alpha:1.0];
    self.dataset.avgMA5Color = [UIColor colorWithRed:67/255.0 green:85/255.0 blue:109/255.0 alpha:1.0];
    self.dataset.avgMA20Color = [UIColor colorWithRed:216/255.0 green:140/255.0 blue:60/255.0 alpha:1.0];
    self.dataset.candleTopBottmLineWidth = 1;
}

- (void)configTimeDataSet{
    self.timeDataset  = [[YKTimeDataset alloc]init];
    self.timeDataset.avgLineCorlor = [UIColor colorWithRed:253/255.0 green:179/255.0 blue:8/255.0 alpha:1.0];
    self.timeDataset.priceLineCorlor = [UIColor colorWithHexString:@"1C262F"];
    self.timeDataset.lineWidth = 1.f;
    self.timeDataset.highlightLineWidth = .8f;
    self.timeDataset.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    
    self.timeDataset.volumeTieColor = CRedColor;
    self.timeDataset.volumeRiseColor = CGreenColor;
    self.timeDataset.volumeFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
    
    self.timeDataset.fillStartColor = [UIColor colorWithHexString:@"1C262F"];
    self.timeDataset.fillStopColor = [UIColor whiteColor];
    self.timeDataset.fillAlpha = .5f;
    self.timeDataset.drawFilledEnabled = YES;
}

- (void)configKLineView{
    self.klineView = [[YKLineChartView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.scrollViewFenshi.frame.size.height)];
    self.klineView.hidden = YES;
    [self.klineView setupChartOffsetWithLeft:10 top:10 right:0 bottom:0];
    self.klineView.gridBackgroundColor = [UIColor whiteColor];
    self.klineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
    self.klineView.borderWidth = .5;
    self.klineView.candleWidth = 8;
    self.klineView.candleMaxWidth = 30;
    self.klineView.candleMinWidth = 5;
    self.klineView.uperChartHeightScale = 0.9;
    self.klineView.xAxisHeitht = 25;
    self.klineView.delegate = self;
    self.klineView.highlightLineShowEnabled = YES;
    self.klineView.zoomEnabled = YES;
    self.klineView.scrollEnabled = YES;
    [self.scrollViewFenshi addSubview:self.klineView];
}

- (QuotesSegment *)quotesSegmentView{
    if (!_quotesSegmentView) {
        _quotesSegmentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuotesSegment class]) owner:self options:nil][0];
    }
    return _quotesSegmentView;
}

- (OptiontimeView *)optiontimeView{
    if (!_optiontimeView) {
        _optiontimeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OptiontimeView class]) owner:self options:nil][0];
    }
    return _optiontimeView;
}

- (void)configView{

    self.viewWarning.hidden = YES;
    self.viewWarning.backgroundColor = CShowPriceColor;
    
    self.scrollViewContainer.scrollEnabled = NO;
    self.viewFenshi = [[FenshiView alloc] init];
    [self.scrollViewFenshi addSubview:self.viewFenshi];
    self.scrollViewFenshi.showsHorizontalScrollIndicator = NO;
    WS(ws);
    [self.scrollViewFenshi addRefreshHeaderWithClosure:^{
        if([ws.delegate respondsToSelector:@selector(refreshRequest)]){
            [ws.delegate refreshRequest];
        }
    }];
    [self configKLineView];
    
    [self.quotesSegmentView showInViewWith:self.viewSegment];
    self.quotesSegmentView.fenshiTitle = [APPLanguageService sjhSearchContentWith:@"fenshi"];
    self.quotesSegmentView.segmentBlock = ^(NSInteger segmentType,QuotesSegment *segment, BOOL isShowFenshiOption,  BOOL ishideAlpha) {
        ws.isShowFenshiOption = isShowFenshiOption;
        if (isShowFenshiOption) {
            ws.optiontimeView.hiddenblock = ^{
                segment.isShow = NO;
            };
            __strong __typeof(ws)strongSelf = ws;
            strongSelf.optiontimeView.optionTypeBlock = ^(NSInteger type,NSString *str) {
                ws.quotesSegmentView.fenshiTitle = str;
                ws.klineType = type;
                if (type == 0) {
                    ws.viewFenshi.hidden = NO;
                    if([ws.delegate respondsToSelector:@selector(requestKLineData:)]){
                        [ws.delegate requestKLineData:type];
                    }
                    ws.klineView.hidden = YES;
                    
                }else{
                    ws.viewFenshi.hidden = YES;
                    ws.klineView.hidden = NO;
                    ws.scrollViewFenshi.contentSize = CGSizeMake(ScreenWidth, ws.scrollViewFenshi.frame.size.height);
                    if([ws.delegate respondsToSelector:@selector(requestKLineData:)]){
                        [ws.delegate requestKLineData:type];
                    }
                }
                
            };
            
            if (ws.isFullScreen) {
                __strong __typeof(ws)strongSelf = ws;
                strongSelf.optiontimeView.viewRotation = strongSelf.viewRotation;
                [strongSelf.optiontimeView showInParentView:strongSelf.viewRotation relativeView:strongSelf.quotesSegmentView];
            }else{
                
                strongSelf.optiontimeView.viewRotation = nil;
                [strongSelf.optiontimeView showInParentView:ws relativeView:ws.quotesSegmentView];
            }
            
            
        }else{
            if (segmentType >=  10) {
                ws.viewFenshi.hidden = YES;
                if (ws.isFullScreen) {
                    ws.klineView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth - 60 - 60 - 30);
                    ws.scrollViewFenshi.contentSize = CGSizeMake(ScreenHeight, 0);
                }else{
                    ws.scrollViewFenshi.contentSize = CGSizeMake(ScreenWidth, 0);
                    
                }
                ws.scrollViewFenshi.contentSize = CGSizeMake(ScreenWidth, ws.scrollViewFenshi.frame.size.height);
                if([ws.delegate respondsToSelector:@selector(requestKLineData:)]){
                    [ws.delegate requestKLineData:segmentType];
                }
                ws.klineView.hidden = NO;
            }else{
                
                if ([ws.quotesSegmentView.fenshiTitle isEqualToString:[APPLanguageService sjhSearchContentWith:@"fenshi"]]) {
                    ws.klineView.hidden = YES;
                    if([ws.delegate respondsToSelector:@selector(requestKLineData:)]){
                        [ws.delegate requestKLineData:segmentType];
                    }
                    ws.viewFenshi.hidden = NO;
                    
                }else{
                    
                    ws.klineView.hidden = NO;
                    ws.viewFenshi.hidden = YES;
                    [ws.optiontimeView fromeWithTitle:ws.quotesSegmentView.fenshiTitle];
                }
                
                
                
            }
        }
    };
    
    
    self.quotesSegmentView.fullScreenBlock = ^{
        ws.isFullScreen = YES;
        ws.viewRotation = [[UIView alloc] initWithFrame:CGRectZero];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:ws.viewRotation];
        [ws.viewRotation mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.width.mas_equalTo(window.frame.size.height - 20);
                make.height.equalTo(window.mas_width);
                make.centerX.equalTo(window);
                make.centerY.equalTo(window.mas_centerY).offset(20);
            }else{
                make.width.equalTo(window.mas_height);
                make.height.equalTo(window.mas_width);
                make.center.equalTo(window);
            }
        }];
        
        ws.viewRotationHeader = [[[NSBundle mainBundle] loadNibNamed:@"BTViewRotationHeader" owner:ws options:nil] lastObject];
        ws.viewRotationHeader.cryModel =ws.cryModel;
        ws.viewRotationHeader.delegate = ws;
        [ws.viewRotation addSubview:ws.viewRotationHeader];
        [ws.viewRotationHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(ws.viewRotation);
            make.height.mas_equalTo(50);
        }];
        
        ws.quotesSegmentView.isShowFullScreen = NO;
        [ws.viewRotation addSubview:ws.quotesSegmentView];
        [ws.quotesSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.viewRotationHeader.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.height.mas_equalTo(50);
        }];
        
        [ws.viewRotation addSubview:ws.viewWarning];
        [ws.viewWarning mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.viewRotationHeader.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.height.mas_equalTo(50);
        }];
        
        [ws.viewRotation addSubview:ws.viewWarningRotation];
        [ws.viewWarningRotation mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.viewRotationHeader.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.height.mas_equalTo(50);
        }];
        
        [ws.viewRotation addSubview:ws.scrollViewContainer];
        [ws.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.quotesSegmentView.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.bottom.equalTo(ws.viewRotation);
        }];
        if (iPhoneX) {
            ws.constraintViewFenshiWidth.constant = ScreenHeight - 50;
        }else{
            ws.constraintViewFenshiWidth.constant = ScreenHeight;
        }
        
        ws.constraintScrollViewFenshiHeight.constant = ScreenWidth - 50 - 50 - 10;
        if (iPhoneX) {
            ws.klineView.frame = CGRectMake(0, 0, ScreenHeight - 50, ScreenWidth - 50 - 50 - 10 );
            float width = (self.fenshiArr.count - 1) * ((ScreenHeight - 50) / TOTALPOINTS);
            if (width < ScreenHeight - 50) {
                width = ScreenHeight - 50;
            }
            ws.scrollViewFenshi.contentSize = CGSizeMake(width, 0);
            ws.viewFenshi.frame = CGRectMake(0,10, width + 10, ScreenWidth - 50 - 50 - 10);
        }else{
            ws.klineView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth - 50 - 50 - 10 );
            float width = (self.fenshiArr.count - 1) * ((ScreenHeight) / TOTALPOINTS);
            if (width < ScreenHeight) {
                width = ScreenHeight;
            }
            ws.scrollViewFenshi.contentSize = CGSizeMake(width, 0);
            ws.viewFenshi.frame = CGRectMake(0,10, width + 10, ScreenWidth - 50 - 50 - 10);
        }

        ws.viewFenshi.isFullScreen = ws.isFullScreen;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        ws.viewRotation.transform = CGAffineTransformMakeRotation(M_PI_2);

        if (ws.isShowFenshiOption) {
            [ws.scrollViewFenshi scrollToRight];
        }else{
            CGPoint contentOffset = ws.scrollViewFenshi.contentOffset;
            contentOffset.x = 0;
            ws.scrollViewFenshi.contentOffset = contentOffset;
        }
//
        [ws.viewFenshi setNeedsDisplay];
        [ws.klineView setNeedsDisplay];
        //[ws startTimer];
    };
}

- (void)configFrame{
    float width;
    if (self.isFullScreen) {
        width = (self.fenshiArr.count - 1) * ((ScreenHeight - 10) / TOTALPOINTS);
        if (width < ScreenHeight) {
            width = ScreenHeight;
        }
    }else{
        width = (self.fenshiArr.count - 1) * ((ScreenWidth - 10) / TOTALPOINTS);
        if (width < ScreenWidth) {
            width = ScreenWidth;
        }
        
    }
    self.scrollViewFenshi.contentSize = CGSizeMake(width +10, 0);
    self.constraintScrollViewFenshiHeight.constant = 290;
    self.viewFenshi.frame = CGRectMake(0, 10, width + 10, 280);
   
    self.viewFenshi.dataArray = [[KLineHelper shareInstance].trendItems mutableCopy];
    [self.viewFenshi setNeedsDisplay];
    //[self.scrollViewFenshi scrollToRight];
}

- (void)configKLineView:(id)data{
    self.dataset.data = data;
    if (self.isFullScreen) {
        if (iPhoneX) {
            self.klineView.frame = CGRectMake(0, 0, ScreenHeight - 50, ScreenWidth - 50 - 50 - 10);
        }else{
            self.klineView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth - 50 - 50 - 10);
        }
        
    }else{
        self.klineView.frame = CGRectMake(0, 0, ScreenWidth, 280);
    }
    [self.klineView setupData:self.dataset];
}


//隐藏分时数据
- (void)noShowWarning{
    self.labelTimeWarning.hidden = YES;
    self.viewWarning.hidden = YES;
    self.labelTimeInfo.hidden = YES;
}

//显示分时数据
- (void)showWarning:(NSNotification *)noti{
    FenshiModel *model = (FenshiModel *)noti.object;
    if ([model isKindOfClass:[FenshiModel class]]) {
        self.viewWarning.hidden = NO;
        self.labelTimeWarning.hidden = NO;
        self.labelTimeInfo.hidden = NO;
        self.labelTimeWarning.text = [[NSDate dateWithTimeIntervalSince1970:model.time / 1000] stringWithFormat:@"HH:mm"];
        self.labelWarningPrice.text = [DigitalHelperService isTransformWithDouble:model.price];
        self.labelWarningCount.text = [DigitalHelperService isTransformWithDouble:model.volum];
    }
}

- (void)noShowWarningRotation{
    self.labelRotationTime.hidden = YES;
    self.labelRotationTime.text = @"";
    self.viewWarningRotation.hidden = YES;
}

- (void)showWarningRotation:(NSNotification *)noti{
    YKLineEntity *entity = noti.object;
    if ([noti.object isKindOfClass:[YKLineEntity class]]) {
        self.viewWarningRotation.hidden = NO;
        self.labelWarningHigh.text = [DigitalHelperService formartScientificNotationWithString:entity.highStr];
        self.labelWarningMin.text = [DigitalHelperService formartScientificNotationWithString:entity.lowStr];
        self.labelRotationTime.hidden = NO;
        if (self.klineType >= 10) {
            self.labelRotationTime.text = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy年MM月dd日"];
        }else{
            self.labelRotationTime.text = [[NSDate dateWithTimeIntervalSince1970:entity.time/ 1000] stringWithFormat:@"yyyy年MM月dd日 HH:mm"];
        }
        self.lableCountRotation.text = @(entity.volume).p2fString;
        self.labelWarningOpen.text = [DigitalHelperService formartScientificNotationWithString:entity.openStr];
        self.labelWarningClose.text = [DigitalHelperService formartScientificNotationWithString:entity.closeStr];
    }
    
}

- (void)setCryModel:(CurrencyModel *)cryModel{
    _cryModel = cryModel;
    if (kIsCNY) {
        self.h24Label.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceCNY];
        self.l24Label.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPriceCNY];
        
    }else{
        self.h24Label.text = [DigitalHelperService isTransformWithDouble:self.cryModel.maxPriceUSD];
        self.l24Label.text = [DigitalHelperService isTransformWithDouble:self.cryModel.minPriceUSD];
    }
    if (self.cryModel.rose > 0) {
        self.rateLabel.text = [NSString stringWithFormat:@"+%@%%",@(self.cryModel.rose).p2fString];
    }else{
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%",@(self.cryModel.rose).p2fString];
    }
    self.titleLabel.text = self.cryModel.kind;
    NSString *str = @"";
    NSString *priceStr;
    if (kIsCNY) {
        str = @"¥";
        priceStr =[NSString stringWithFormat:@"%.2f",[self.cryModel.priceCNY floatValue]];
    }else{
        str = @"$";
        priceStr =[NSString stringWithFormat:@"%.2f",[self.cryModel.priceUSD floatValue]];
    }
    self.h24Label.text =[NSString stringWithFormat:@"%@%@",str,self.h24Label.text];
    self.l24Label.text =[NSString stringWithFormat:@"%@%@",str,self.l24Label.text];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@",str,priceStr];
    
    if (self.cryModel.rose > 0){
        self.numLabel.text = [NSString stringWithFormat:@"+%@",[DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)]];
    }else{
        if (self.cryModel.rose == -100) {
            self.numLabel.text = @"0";
            
        }else{
            self.numLabel.text = [DigitalHelperService isTransformWithDouble:[self.cryModel.priceCNY doubleValue]  * (self.cryModel.rose / 100.0) / (1 + self.cryModel.rose / 100.0)];
        }
    }
    self.chengjiaoLabel.text = [DigitalHelperService transformWith:self.cryModel.volume];
    ////////////////////////////////////////////////////////////
    self.viewRotationHeader.cryModel =cryModel;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)endRefreshing{
    [self.scrollViewFenshi endRefreshing];
}

- (void)exitFullScreen{
    self.constraintScrollViewFenshiHeight.constant = 290;
    self.constraintViewFenshiWidth.constant = ScreenWidth;
    //self.delegate.m.tableHeaderView = self.viewHeader;
    [self.viewWarningRotation removeFromSuperview];
    self.isFullScreen = NO;
//    [self.viewRotationHeader stopTimeForTime];
    self.quotesSegmentView.isShowFullScreen = YES;
    [self addSubview:self.quotesSegmentView];
    [self.quotesSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewHeader.mas_bottom);
        make.left.right.equalTo(self.viewHeader);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.viewWarning];
    [self.viewWarning mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewHeader.mas_bottom);
        make.left.right.equalTo(self.viewHeader);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.viewWarningRotation];
    [self.viewWarningRotation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewHeader.mas_bottom);
        make.left.right.equalTo(self.viewHeader);
        make.height.mas_equalTo(40);
    }];
    
    
    [self addSubview:self.scrollViewContainer];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quotesSegmentView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(300);
    }];
    float width = (self.fenshiArr.count - 1) * (ScreenWidth / TOTALPOINTS);
    if (width < ScreenWidth) {
        width = ScreenWidth;
    }
    self.scrollViewFenshi.contentSize = CGSizeMake(width, 0);
    self.viewFenshi.frame = CGRectMake(0, 10, width + 10, 280);
    self.viewFenshi.isFullScreen = self.isFullScreen;
    self.klineView.frame = CGRectMake(0, 0, ScreenWidth, 280);
    if (self.isShowFenshiOption) {
        [self.scrollViewFenshi scrollToRight];
    }else{
        CGPoint contentOffset = self.scrollViewFenshi.contentOffset;
        contentOffset.x = 0;
        self.scrollViewFenshi.contentOffset = contentOffset;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewRotation.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.viewRotation removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.viewFenshi setNeedsDisplay];
    [self.klineView setNeedsDisplay];
}


@end
