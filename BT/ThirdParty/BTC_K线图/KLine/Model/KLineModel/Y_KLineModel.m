//
//  Y-KlineModel.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineModel.h"
#import "Y_KLineGroupModel.h"
#import "Y_StockChartGlobalVariable.h"


@implementation Y_KLineModel

//double countSMA(double c, double n, double m, double sma) {
//    return (m * c + (n - m) * sma) / n;
//}

//rsi计算
- (double)rsiWithDays:(NSInteger)days{
    double Torelence = 0.0000001;
    double sumGain = 0;
    double sumLoss = 0;
    NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
    if(index < days) return 0;
    NSInteger addCount = 0;
    NSInteger minusCount = 0;
    if(index >= days){
        for(NSUInteger i = index - days;i <= index; i++){
            Y_KLineModel *model = self.ParentGroupModel.models[i];
            double difference = model.Close.doubleValue - model.PreviousKlineModel.Close.doubleValue;
            if (difference >= 0){
                sumGain += difference;
                addCount ++;
            }
            else{
                sumLoss -= difference;
                minusCount ++;
            }
        }
    }
    if (sumGain == 0) return 0;
    if(addCount == 0) return 0;
    if(minusCount == 0) return 100;
    if (ABS(sumLoss) < Torelence) return 100;
    
    double relativeStrength = sumGain / sumLoss;
    
    return 100.0 - (100.0 / (1 + relativeStrength));
    
//    double smaMax = self.PreviousKlineModel.SMA.doubleValue, smaAbs = self.PreviousKlineModel.SMB.doubleValue;
//
//    double rsi = 0;
//    double lc = self.PreviousKlineModel.Close.doubleValue;
//    double close = self.Close.doubleValue;
//
//    smaMax = countSMA(MAX(close - lc, 0), days, 1, smaMax);
//    smaAbs = countSMA(ABS(close - lc), days, 1, smaAbs);
//    self.SMA = @(smaMax);
//    self.SMB = @(smaAbs);
//
//    rsi = smaMax / smaAbs * 100;
//    return rsi;
}

- (NSNumber*)RSI_6{
    if(!_RSI_6){
        return @([self rsiWithDays:6]);
    }
    return _RSI_6;
}

- (NSString*)rate{
    if(!_rate){
        if(self.Open.doubleValue != 0){
            _rate = [NSString stringWithFormat:@"%.2f%%",(self.High.doubleValue - self.Low.doubleValue)/self.Open.doubleValue *100];
        }else{
            _rate = @"0.00%";
        }
    }
    return _rate;
}

- (NSString*)riseRate{
    if(!_riseRate){
        if(self.Open.doubleValue != 0){
            _riseRate = [NSString stringWithFormat:@"%.2f%%",(self.Close.doubleValue - self.Open.doubleValue)/self.Open.doubleValue *100];
        }else{
            _riseRate = @"0.00%";
        }
    }
    return _riseRate;
}

- (double)zfRate{
    if(!_zfRate){
        if(self.Open.doubleValue != 0){
            _zfRate = (self.Close.doubleValue - self.Open.doubleValue)/self.Open.doubleValue;
        }else{
            _zfRate = 0.00;
        }
    }
    return _zfRate;
}

- (NSNumber*)RSI_12{
    if(!_RSI_12){
        return @([self rsiWithDays:12]);
    }
    return _RSI_12;
}

- (NSNumber*)RSI_24{
    if(!_RSI_24){
        return @([self rsiWithDays:24]);
    }
    return _RSI_24;
}

//资金净流入
- (NSNumber*)netInflow{
    if(!_netInflow){
        CGFloat num = (self.Close.doubleValue - self.Open.doubleValue) * self.Volume;
        _netInflow = @(num);
    }
    return _netInflow;
}

- (NSNumber *)RSV_9
{
    if (!_RSV_9) {
        if(self.NineClocksMinPrice == self.NineClocksMaxPrice) {
            _RSV_9 = @100;
        } else {
            //修复nan的问题
            CGFloat unit =self.NineClocksMaxPrice.floatValue - self.NineClocksMinPrice.floatValue;
            if(unit > 0.00000001){
                _RSV_9 = @((self.Close.floatValue - self.NineClocksMinPrice.floatValue) * 100 / (self.NineClocksMaxPrice.floatValue - self.NineClocksMinPrice.floatValue));
            }else{
                _RSV_9 = @100;
            }
            
        }
    }
    return _RSV_9;
}
- (NSNumber *)KDJ_K
{
    if (!_KDJ_K) {
        _KDJ_K = @((self.RSV_9.floatValue + 2 * (self.PreviousKlineModel.KDJ_K ? self.PreviousKlineModel.KDJ_K.floatValue : 50) )/3);
    }
    return _KDJ_K;
}

- (NSNumber *)KDJ_D
{
    if(!_KDJ_D) {
        _KDJ_D = @((self.KDJ_K.floatValue + 2 * (self.PreviousKlineModel.KDJ_D ? self.PreviousKlineModel.KDJ_D.floatValue : 50))/3);
    }
    return _KDJ_D;
}
- (NSNumber *)KDJ_J
{
    if(!_KDJ_J) {
        _KDJ_J = @(3*self.KDJ_K.floatValue - 2*self.KDJ_D.floatValue);
    }
    return _KDJ_J;
}

- (NSNumber*)MA5{
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_MA5) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 4) {
                if (index > 4) {
                    _MA5 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 5].SumOfLastClose.floatValue) / 5);
                } else {
                    _MA5 = @(self.SumOfLastClose.floatValue / 5);
                }
            }
        }
    } else {
        return self.EMA5;
    }
    return _MA5;
}

- (NSNumber*)MA10{
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_MA10) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 9) {
                if (index > 9) {
                    _MA10 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 10].SumOfLastClose.floatValue) / 10);
                } else {
                    _MA10 = @(self.SumOfLastClose.floatValue / 10);
                }
            }
        }
    } else {
        return self.EMA10;
    }
    return _MA10;
    
}
- (NSNumber *)MA7
{
    
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_MA5) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 4) {
                if (index > 4) {
                    _MA5 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 5].SumOfLastClose.floatValue) / 5);
                } else {
                    _MA5 = @(self.SumOfLastClose.floatValue / 5);
                }
            }
        }
    } else {
        return self.EMA5;
    }
    return _MA5;
    
//    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
//    {
//        if (!_MA7) {
//            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
//            if (index >= 6) {
//                if (index > 6) {
//                    _MA7 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastClose.floatValue) / 7);
//                } else {
//                    _MA7 = @(self.SumOfLastClose.floatValue / 7);
//                }
//            }
//        }
//    } else {
//        return self.EMA7;
//    }
//    return _MA7;
}

- (NSNumber *)Volume_MA7
{
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_Volume_MA7) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _Volume_MA7 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 7].SumOfLastVolume.floatValue) / 7);
                } else {
                    _Volume_MA7 = @(self.SumOfLastVolume.floatValue / 7);
                }
            }
        }
    } else {
        return self.Volume_EMA7;
    }
    return _Volume_MA7;
}
- (NSNumber *)Volume_EMA7
{
    if(!_Volume_EMA7) {
        _Volume_EMA7 = @((self.Volume + 3 * self.PreviousKlineModel.Volume_EMA7.floatValue)/4);
    }
    return _Volume_EMA7;
}
//// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
- (NSNumber*)EMA5{
    if(!_EMA5) {
        _EMA5 = @((self.Close.floatValue + 2 * self.PreviousKlineModel.EMA5.floatValue)/3);
    }
    return _EMA5;
    
}

- (NSNumber*)EMA10{
    if(!_EMA10) {
        _EMA10 = @((2 * self.Close.floatValue + 9 * self.PreviousKlineModel.EMA10.floatValue)/11);
    }
    return _EMA10;
}

- (NSNumber *)EMA7
{
    if(!_EMA7) {
        _EMA7 = @((self.Close.floatValue + 3 * self.PreviousKlineModel.EMA7.floatValue)/4);
    }
    return _EMA7;
}

- (NSNumber *)EMA30
{
    if(!_EMA30) {
        _EMA30 = @((2 * self.Close.floatValue + 29 * self.PreviousKlineModel.EMA30.floatValue)/31);
    }
    return _EMA30;
}

- (NSNumber *)EMA12
{
    if(!_EMA12) {
        _EMA12 = @((2 * self.Close.floatValue + 11 * self.PreviousKlineModel.EMA12.floatValue)/13);
    }
    return _EMA12;
}

- (NSNumber *)EMA26
{
    if (!_EMA26) {
        _EMA26 = @((2 * self.Close.floatValue + 25 * self.PreviousKlineModel.EMA26.floatValue)/27);
    }
    return _EMA26;
}

- (NSNumber *)MA30
{
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _MA30 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastClose.floatValue) / 30);
                } else {
                    _MA30 = @(self.SumOfLastClose.floatValue / 30);
                }
            }
        }
    } else {
        return self.EMA30;
    }
    return _MA30;
}

- (NSNumber *)Volume_MA30
{
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_Volume_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _Volume_MA30 = @((self.SumOfLastVolume.floatValue - self.ParentGroupModel.models[index - 30].SumOfLastVolume.floatValue) / 30);
                } else {
                    _Volume_MA30 = @(self.SumOfLastVolume.floatValue / 30);
                }
            }
        }
    } else {
        return self.Volume_EMA30;
    }
    return _Volume_MA30;
}

- (NSNumber *)Volume_EMA30
{
    if(!_Volume_EMA30) {
        _Volume_EMA30 = @((2 * self.Volume + 29 * self.PreviousKlineModel.Volume_EMA30.floatValue)/31);
    }
    return _Volume_EMA30;
}


- (NSNumber *)MA12
{
    if (!_MA12) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 11) {
            if (index > 11) {
                _MA12 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 12].SumOfLastClose.floatValue) / 12);
            } else {
                _MA12 = @(self.SumOfLastClose.floatValue / 12);
            }
        }
    }
    return _MA12;
}

- (NSNumber *)MA26
{
    if (!_MA26) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 25) {
            if (index > 25) {
                _MA26 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 26].SumOfLastClose.floatValue) / 26);
            } else {
                _MA26 = @(self.SumOfLastClose.floatValue / 26);
            }
        }
    }
    return _MA26;
}

- (NSNumber *)SumOfLastClose
{
    if(!_SumOfLastClose) {
        _SumOfLastClose = @(self.PreviousKlineModel.SumOfLastClose.floatValue + self.Close.floatValue);
    }
    return _SumOfLastClose;
}

- (NSNumber *)SumOfLastVolume
{
    if(!_SumOfLastVolume) {
        _SumOfLastVolume = @(self.PreviousKlineModel.SumOfLastVolume.floatValue + self.Volume);
    }
    return _SumOfLastVolume;
}

- (NSNumber *)NineClocksMinPrice
{
    if (!_NineClocksMinPrice) {
        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
        {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
        } else {
            _NineClocksMinPrice = @(0.001);
        }
    }
    return _NineClocksMinPrice;
}

- (NSNumber *)NineClocksMaxPrice {
    if (!_NineClocksMaxPrice) {
        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
        {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
        } else {
            _NineClocksMaxPrice = @(0.002);
        }
    }
    return _NineClocksMaxPrice;
}


////DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//
////今日的DEA值=前一日DEA*8/10+今日DIF*2/10.

- (NSNumber *)DIF
{
    if(!_DIF) {
        _DIF = @(self.EMA12.floatValue - self.EMA26.floatValue);
    }
    return _DIF;
}

//已验证
-(NSNumber *)DEA
{
    if(!_DEA) {
        _DEA = @(self.PreviousKlineModel.DEA.floatValue * 0.8 + 0.2*self.DIF.floatValue);
    }
    return _DEA;
}

//已验证
- (NSNumber *)MACD
{
    if(!_MACD) {
        _MACD = @(2*(self.DIF.floatValue - self.DEA.floatValue));
    }
    return _MACD;
}

#pragma mark BOLL线

- (NSNumber *)MA20{
    
    if (!_MA20) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            if (index > 19) {
                _MA20 = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 20].SumOfLastClose.floatValue) / 20);
            } else {
                _MA20 = @(self.SumOfLastClose.floatValue / 20);
            }
        }
    }
    return _MA20;
    
}

- (NSNumber *)BOLL_MB {
    
    if(!_BOLL_MB) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            
            if (index > 19) {
                _BOLL_MB = @((self.SumOfLastClose.floatValue - self.ParentGroupModel.models[index - 19].SumOfLastClose.floatValue) / 19);
                
            } else {
                
                _BOLL_MB = @(self.SumOfLastClose.floatValue / index);
                
            }
        }
        
        // NSLog(@"lazyMB:\n _BOLL_MB: %@", _BOLL_MB);
        
    }
    
    return _BOLL_MB;
}

- (NSNumber *)BOLL_MD {
    
    if (!_BOLL_MD) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        
        if (index >= 20) {
            
            _BOLL_MD = @(sqrt((self.PreviousKlineModel.BOLL_SUBMD_SUM.floatValue - self.ParentGroupModel.models[index - 20].BOLL_SUBMD_SUM.floatValue)/ 20));
            
        }
        
    }
    
    // NSLog(@"lazy:\n_BOLL_MD:%@ -- BOLL_SUBMD:%@",_BOLL_MD,_BOLL_SUBMD);
    
    return _BOLL_MD;
}

- (NSNumber *)BOLL_UP {
    if (!_BOLL_UP) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_UP = @(self.BOLL_MB.floatValue + 2 * self.BOLL_MD.floatValue);
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_UP:%@ -- BOLL_MD:%@",_BOLL_UP,_BOLL_MD);
    
    return _BOLL_UP;
}

- (NSNumber *)BOLL_DN {
    if (!_BOLL_DN) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_DN = @(self.BOLL_MB.floatValue - 2 * self.BOLL_MD.floatValue);
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_DN:%@ -- BOLL_MD:%@",_BOLL_DN,_BOLL_MD);
    
    return _BOLL_DN;
}

- (NSNumber *)BOLL_SUBMD_SUM {
    
    if (!_BOLL_SUBMD_SUM) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            
            _BOLL_SUBMD_SUM = @(self.PreviousKlineModel.BOLL_SUBMD_SUM.floatValue + self.BOLL_SUBMD.floatValue);
            
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_SUBMD_SUM:%@ -- BOLL_SUBMD:%@",_BOLL_SUBMD_SUM,_BOLL_SUBMD);
    
    return _BOLL_SUBMD_SUM;
}

- (NSNumber *)BOLL_SUBMD{
    
    if (!_BOLL_SUBMD) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        
        if (index >= 20) {
            
            _BOLL_SUBMD = @((self.Close.floatValue - self.MA20.floatValue) * ( self.Close.floatValue - self.MA20.floatValue));
                        
        }
    }
    
    // NSLog(@"lazy_BOLL_SUBMD: \n MA20: %@ \n Close: %@ \n subNum: %f", _MA20, _Close, self.Close.floatValue - self.MA20.floatValue);
    
    return _BOLL_SUBMD;
}



- (Y_KLineModel *)PreviousKlineModel
{
    if (!_PreviousKlineModel) {
        _PreviousKlineModel = [Y_KLineModel new];
        _PreviousKlineModel.DIF = @(0);
        _PreviousKlineModel.DEA = @(0);
        _PreviousKlineModel.MACD = @(0);
        _PreviousKlineModel.MA7 = @(0);
        _PreviousKlineModel.MA5 = @(0);
        _PreviousKlineModel.MA10 = @(0);
        _PreviousKlineModel.MA12 = @(0);
        _PreviousKlineModel.MA26 = @(0);
        _PreviousKlineModel.MA30 = @(0);
        _PreviousKlineModel.EMA7 = @(0);
        
        _PreviousKlineModel.EMA5 = @(0);
        _PreviousKlineModel.EMA10 = @(0);
        _PreviousKlineModel.EMA12 = @(0);
        _PreviousKlineModel.EMA26 = @(0);
        _PreviousKlineModel.EMA30 = @(0);
        _PreviousKlineModel.Volume_MA7 = @(0);
        _PreviousKlineModel.Volume_MA30 = @(0);
        _PreviousKlineModel.Volume_EMA7 = @(0);
        _PreviousKlineModel.Volume_EMA30 = @(0);
        _PreviousKlineModel.SumOfLastClose = @(0);
        _PreviousKlineModel.SumOfLastVolume = @(0);
        _PreviousKlineModel.KDJ_K = @(50);
        _PreviousKlineModel.KDJ_D = @(50);
        
        
        //RSI指标
        _PreviousKlineModel.SMA = @(0);
        _PreviousKlineModel.SMB = @(0);
        _PreviousKlineModel.RSI_6 = @(50);
        _PreviousKlineModel.RSI_12 = @(50);
        _PreviousKlineModel.RSI_24 = @(50);
        
        
        _PreviousKlineModel.MA20 = @(0);
        _PreviousKlineModel.BOLL_MD = @(0);
        _PreviousKlineModel.BOLL_MB = @(0);
        _PreviousKlineModel.BOLL_DN = @(0);
        _PreviousKlineModel.BOLL_UP = @(0);
        _PreviousKlineModel.BOLL_SUBMD_SUM = @(0);
        _PreviousKlineModel.BOLL_SUBMD = @(0);
        
    }
    return _PreviousKlineModel;
}
- (Y_KLineGroupModel *)ParentGroupModel
{
    if(!_ParentGroupModel) {
        _ParentGroupModel = [Y_KLineGroupModel new];
    }
    return _ParentGroupModel;
}
//对Model数组进行排序，初始化每个Model的最新9Clock的最低价和最高价
- (void)rangeLastNinePriceByArray:(NSArray<Y_KLineModel *> *)models condition:(NSComparisonResult)cond
{
    if([self.ParentGroupModel.models indexOfObject:self] < 8){
        return;
    }
    switch (cond) {
            //最高价
        case NSOrderedAscending:
        {
            
//            第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger j = 7; j >= 1; j--)
            {
                NSNumber *emMaxValue = @0;
                
                NSInteger em = j;
                //修复bug
                if(em >= models.count) return;
                
                while ( em >= 0 )
                {
                    if([emMaxValue compare:models[em].High] == cond)
                    {
                        emMaxValue = models[em].High;
                    }
                    em--;
                }
                //NSLog(@"%f",emMaxValue.floatValue);
                models[j].NineClocksMaxPrice = emMaxValue;
            }
            //第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++)
            {
                NSNumber *emMaxValue = @0;
                
                NSInteger em = j;
                
                while ( em >= i )
                {
                    if([emMaxValue compare:models[em].High] == cond)
                    {
                        emMaxValue = models[em].High;
                    }
                    em--;
                }
                //NSLog(@"%f",emMaxValue.floatValue);

                models[j].NineClocksMaxPrice = emMaxValue;
            }
        }
            break;
        case NSOrderedDescending:
        {
            //第一个循环结束后，ClockFirstValue为最小值
            
            for (NSInteger j = 7; j >= 1; j--)
            {
                NSNumber *emMinValue = @(10000000000);
                
                NSInteger em = j;
                
                while ( em >= 0 )
                {
                    if([emMinValue compare:models[em].Low] == cond)
                    {
                        emMinValue = models[em].Low;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
            
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++)
            {
                NSNumber *emMinValue = @(10000000000);
                
                NSInteger em = j;
                
                while ( em >= i )
                {
                    if([emMinValue compare:models[em].Low] == cond)
                    {
                        emMinValue = models[em].Low;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
        }
            break;
        default:
            break;
    }
}

- (void) initWithArray:(NSArray *)arr;{
    NSAssert(arr.count == 6, @"数组长度不足");
    
    if (self)
    {
        _Date = arr[0];
        _Open = @([arr[1] floatValue]);
        _High = @([arr[2] floatValue]);
        _Low = @([arr[3] floatValue]);
        _Close = @([arr[4] floatValue]);
        
        _Volume = [arr[5] floatValue];
        self.SumOfLastClose = @(_Close.floatValue + self.PreviousKlineModel.SumOfLastClose.floatValue);
        self.SumOfLastVolume = @(_Volume + self.PreviousKlineModel.SumOfLastVolume.floatValue);
    }
}

- (void)initWithModel:(YKLineEntity*)entity{
    if(self){
        
        _time = entity.time;
        _Date =  SAFESTRING(entity.date);
        _Open = @(entity.open);
        _High = @(entity.high);
        _Low = @(entity.low);
        _Close = @(entity.close);
        _Volume = entity.volume;
        self.SumOfLastClose = @(_Close.floatValue + self.PreviousKlineModel.SumOfLastClose.floatValue);
        self.SumOfLastVolume = @(_Volume + self.PreviousKlineModel.SumOfLastVolume.floatValue);
    }
}

- (void) initWithDict:(NSDictionary *)dict
{
    
    if (self)
    {
        _Date = dict[@"currentTime"];
        _Open = @([dict[@"openPrice"] floatValue]);
        _High = @([dict[@"maxPrice"] floatValue]);
        _Low = @([dict[@"minPrice"] floatValue]);
        _Close = @([dict[@"closePrice"] floatValue]);
        _Volume = [dict[@"volume"] floatValue];
        self.SumOfLastClose = @(_Close.floatValue + self.PreviousKlineModel.SumOfLastClose.floatValue);
        self.SumOfLastVolume = @(_Volume + self.PreviousKlineModel.SumOfLastVolume.floatValue);
        //        NSLog(@"%@======%@======%@------%@",_Close,self.MA7,self.MA30,_SumOfLastClose);
        
    }
}

- (void)initFirstModel
{
//    _SumOfLastClose = _Close;
//    _SumOfLastVolume = @(_Volume);
    _KDJ_K = @(55.27);
    _KDJ_D = @(55.27);
    _KDJ_J = @(55.27);
//    _MA7 = _Close;
//    _MA12 = _Close;
//    _MA26 = _Close;
//    _MA30 = _Close;
    _EMA5 = _Close;
    _EMA10 = _Close;
    _EMA7 = _Close;
    _EMA12 = _Close;
    _EMA26 = _Close;
    _EMA30 = _Close;
    _NineClocksMinPrice = _Low;
    _NineClocksMaxPrice = _High;
    [self DIF];
    [self DEA];
    [self MACD];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
    //RSI
    [self RSI_6];
    [self RSI_12];
    [self RSI_24];
    
    [self MA20];
    [self BOLL_MD];
    [self BOLL_MB];
    [self BOLL_UP];
    [self BOLL_DN];
    [self BOLL_SUBMD];
    [self BOLL_SUBMD_SUM];
    //
    
}

- (void)initData {
    [self MA7];
    [self MA12];
    [self MA26];
    [self MA30];
    [self EMA7];
    [self EMA12];
    [self EMA26];
    [self EMA30];
    
    [self DIF];
    [self DEA];
    [self MACD];
    [self NineClocksMaxPrice];
    [self NineClocksMinPrice];
    [self RSV_9];
    
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
    //RSI
    [self RSI_6];
    [self RSI_12];
    [self RSI_24];
    
    [self MA20];
    [self BOLL_MD];
    [self BOLL_MB];
    [self BOLL_UP];
    [self BOLL_DN];
    [self BOLL_SUBMD];
    [self BOLL_SUBMD_SUM];

}
@end
