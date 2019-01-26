//
//  HomeHeadView.m
//  BT
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeHeadView.h"
#import "HomeGainDistributionView.h"
#import "BTBitaneIndexModel.h"
@interface HomeHeadView ()

@property (nonatomic,strong)HomeGainDistributionView *gainDistributionView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


@end
@implementation HomeHeadView
-(HomeGainDistributionView *)gainDistributionView {
    
    if (!_gainDistributionView) {
        
        _gainDistributionView = [HomeGainDistributionView loadFromXib];
        _gainDistributionView.frame = CGRectMake(0, 0, ScreenWidth, 106);
    }
    return _gainDistributionView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    //[self.ZFFB_VIEW addSubview:self.gainDistributionView];
    [self.rightBtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
}
-(void)setZFFB_DICT:(NSDictionary *)ZFFB_DICT {
    if (ZFFB_DICT) {
        _ZFFB_DICT = ZFFB_DICT;
        [self.gainDistributionView removeAllSubviews];
        [self.ZFFB_VIEW addSubview:self.gainDistributionView];
        NSLog(@"%@",ZFFB_DICT[@"0"]);
        NSMutableArray *arr_Num = @[].mutableCopy;
        NSMutableArray *arr_Height = @[].mutableCopy;
        for (int i = 0; i < ZFFB_DICT.count; i++) {
            NSString *num = ZFFB_DICT[[NSString stringWithFormat:@"%d",i]];
            NSLog(@"%ld",num.integerValue);
            [arr_Num addObject:@(num.integerValue)];
            [arr_Height addObject:@(num.integerValue)];
//            [arr_Num addObject:@(num.integerValue == 0 ? 1 : num.integerValue)];
//            [arr_Height addObject:@(num.integerValue == 0 ? 1 : num.integerValue)];
        }
        //对数组进行排序
        NSArray *result = [arr_Height sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
            return [obj2 compare:obj1]; //降序
            
        }];
        //获取柱状图的高度百分比
        NSMutableArray *result_Height = @[].mutableCopy;
        for (int i = 0; i < arr_Height.count; i++) {
            
            [result_Height addObject:@([arr_Height[i] integerValue]/[result[0] floatValue])];
        }
        NSMutableArray *arr_12 =@[].mutableCopy;
        if (arr_Num.count < 12) {
            NSLog(@"%lu",12-arr_Num.count);
            for (int j = 0; j <= (12-arr_Num.count); j++) {
                [arr_12 addObject:@(0)];
            }
            [arr_Num addObjectsFromArray:arr_12];
            [arr_Height addObjectsFromArray:arr_12];
        }
        //得到数据 绘制柱状图
        self.gainDistributionView.numbArray = arr_Num;
        self.gainDistributionView.heightArray = result_Height;
        [self.gainDistributionView strokeChart];
        
        //涨幅分布 计算头部数据
        NSInteger zf_6 =[arr_Num[0] integerValue]+[arr_Num[1] integerValue]+[arr_Num[2] integerValue];
        NSInteger zf_ALLL =[arr_Num[0] integerValue]+[arr_Num[1] integerValue]+[arr_Num[2] integerValue]+[arr_Num[3] integerValue]+[arr_Num[4] integerValue]+[arr_Num[5] integerValue];
        NSInteger df_6 =[arr_Num[9] integerValue]+[arr_Num[10] integerValue]+[arr_Num[11] integerValue];
        NSInteger df_ALLL =[arr_Num[6] integerValue]+[arr_Num[7] integerValue]+[arr_Num[8] integerValue]+[arr_Num[9] integerValue]+[arr_Num[10] integerValue]+[arr_Num[11] integerValue];
        
        self.ZFFB_TYPE1.text = [NSString stringWithFormat:@"%@>6%%:%ld  %@:%ld",[APPLanguageService wyhSearchContentWith:@"zhangfu"],zf_6,[APPLanguageService wyhSearchContentWith:@"shangzhang"],zf_ALLL];
        self.ZFFB_TYPE2.text = [NSString stringWithFormat:@"%@>6%%:%ld  %@:%ld",[APPLanguageService wyhSearchContentWith:@"diefu"],df_6,[APPLanguageService wyhSearchContentWith:@"xiadie"],df_ALLL];
        self.ZFFB_TYPE1.tag = 87541510;
        self.ZFFB_TYPE2.tag = 87541511;
        [getUserCenter changeUILabelColor:self.ZFFB_TYPE1 and:[NSString stringWithFormat:@"%ld",zf_6] and:[NSString stringWithFormat:@"%ld",zf_ALLL] color:CRiseColor];
        [getUserCenter changeUILabelColor:self.ZFFB_TYPE2 and:[NSString stringWithFormat:@"%ld",df_6] and:[NSString stringWithFormat:@"%ld",df_ALLL] color:CFallColor];
    }
}
-(void)setArray:(NSMutableArray *)array {
    
    _array = array;
    if (array) {
        
        NSArray *a1 = @[self.zs1_title1L,self.zs2_title1L,self.zs3_title1L];
        NSArray *a2 = @[self.zs1_title2L,self.zs2_title2L,self.zs3_title2L];
        NSArray *a3 = @[self.zs1_title3L,self.zs2_title3L,self.zs3_title3L];
        NSLog(@"%@",array);
        
        for (int i = 0; i < array.count; i++) {
            BTBitaneIndexModel *model = array[i];
            UILabel *L1 = a1[i];
            UILabel *L2 = a2[i];
            UILabel *L3 = a3[i];
            
            L1.text     = ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans) ? model.name : model.englishname;
            if (kIsCNY) {
                if (model.priceCNIndex > 1) {
                    L2.text = @(model.priceCNIndex).p2fString;
                }else if(model.priceCNIndex < 1){
                    L2.text = @(model.priceCNIndex).p8fString;
                }else{
                    L2.text = [NSString stringWithFormat:@"%.0f",model.priceCNIndex];
                }
            }else {
                if (model.priceUSIndex > 1) {
                    L2.text = @(model.priceUSIndex).p2fString;
                }else if(model.priceUSIndex < 1){
                    L2.text = @(model.priceUSIndex).p8fString;
                }else{
                    L2.text = [NSString stringWithFormat:@"%.0f",model.priceUSIndex];
                }
                
            }
            switch (model.type) {
                case 0:
                    L2.textColor = isNightMode ? FirstNightColor :FirstDayColor;;
                    break;
                case 1:
                    L2.textColor = CGreenColor;
                    break;
                case 2:
                    L2.textColor = CRedColor;
                    break;
                default:
                    break;
            }
            
            if (model.increaseRateIndex <  0) {
                L3.textColor =CRedColor;
                L3.text =[NSString stringWithFormat:@"-%@%%",@(-model.increaseRateIndex).p2fString];
            }else{
                L3.textColor =CGreenColor;
                L3.text =[NSString stringWithFormat:@"+%@%%",@(model.increaseRateIndex).p2fString];
                
                if (model.increaseRateIndex == 0) {
                    L3.textColor = isNightMode ? FirstNightColor :FirstDayColor;;
                    L3.text =@"0.00%";
                }
            }
        }
    }
    
}
- (IBAction)indexDetailBtnClcik:(UIButton *)sender {
    
    if (_array) {
        if (sender.tag-10 >= _array.count) return;
        BTBitaneIndexModel *model = _array[sender.tag-10];
       
        [BTCMInstance pushViewControllerWithName:@"BTIndexDetail" andParams:@{@"model":model}];
    }
}
//更多
- (IBAction)moreBtnClick:(UIButton *)sender {
    
    [MobClick event:@"rise_fall_distributed"];//首页-涨跌分布
    NSLog(@"%@---%@",_ZFFB_DICT,_ZFFB_DICT[@"0"]);
    NSArray *qjArray = @[@"10%",@"8%-10%",@"6%-8%",@"4%-6%",@"2%-4%",@"0%-2%",
                         @"0%-2%",@"2%-4%",@"4%-6%",@"6%-8%",@"8%-10%",@"10%"];
    NSMutableArray *totalArr = @[].mutableCopy;
    NSMutableArray *roseArr  = @[].mutableCopy;
    NSMutableArray *fellArr  = @[].mutableCopy;
    NSInteger      roseTotal = 0;
    NSInteger      fellTotal = 0;
    for (int i = 0; i < _ZFFB_DICT.count; i++) {
        
        BTZFFFModel *model = [[BTZFFFModel alloc] init];
        model.qujian = qjArray[i];
        model.number = [_ZFFB_DICT[[NSString stringWithFormat:@"%d",i]] integerValue];
        model.riseDistributionType = i;
        if (i <= 5) {
            roseTotal += model.number;
            [roseArr addObject:model];
        }else {
            fellTotal += model.number;
            [fellArr addObject:model];
        }
    }
    //降序
    fellArr =  [NSMutableArray arrayWithArray:[fellArr sortedArrayUsingComparator:^NSComparisonResult(BTZFFFModel *obj1, BTZFFFModel *obj2) {
        return [@(obj2.riseDistributionType) compare:@(obj1.riseDistributionType)];
    }]];
    
    [totalArr addObject:@{@"arr":roseArr,
                          @"total":@(roseTotal)}];
    [totalArr addObject:@{@"arr":fellArr,
                          @"total":@(fellTotal)}];
    [BTCMInstance pushViewControllerWithName:@"BTZFFBDetail" andParams:@{@"dataArray":totalArr}];
}

@end
