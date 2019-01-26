//
//  KLineHelper.m
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "KLineHelper.h"
#import "FenshiModel.h"
#import "TradePointModel.h"
#import "zlib.h"
#import "KLineModel.h"

#define ARC4RANDOM_MAX      0x100000000
@interface KLineHelper ()

@property (nonatomic, assign) BOOL isRand;

@property (nonatomic, strong) NSMutableArray *arrPoint;

@property (nonatomic, strong) FenshiModel *fenshiNewModel;

@property (nonatomic, assign)  double minPrice;

@property (nonatomic, assign) double maxPrice;

//@property (nonatomic, assign) double maxVolum;

@property (nonatomic, assign) double minVolum;

@property (nonatomic, assign) double totalMoney;

@property (nonatomic, assign) double totalCount;

@property (nonatomic, strong) FenshiModel *pri20model;


@end

@implementation KLineHelper


+ (instancetype)shareInstance{
    static KLineHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[KLineHelper alloc] init];
    });
    return helper;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isRand = YES;
    }
    return self;
}

- (void)setOriginItems:(NSMutableArray *)items{
    self.isRand  = YES;
    _trendItems = [items mutableCopy];
    [self setPointFenshiView];
}

- (void)setPointFenshiView{
    FenshiModel *preModel = nil;
    self.totalMoney = 0;
    self.totalCount = 0;
    self.maxPrice = 0;
    self.minPrice = 0;
    self.minVolum = 0;
    self.maxVolum = 0;
  
    for (FenshiModel *model in _trendItems) {
        if (preModel) {
            if (model.price > preModel.price) {
                model.rise = YES;
            }else{
                model.rise = NO;
            }
            model.volum = model.totalVolum  - preModel.totalVolum;
            if (model.volum <= 0) {
                model.volum = [self randFloatBetween:self.minVolum and:self.maxVolum];
            }
            if (model.volum < self.minVolum) {
                self.minVolum = model.volum;
            }
            if (model.volum > self.maxVolum) {
                self.maxVolum = model.volum;
            }
            
            if (model.price < self.minPrice) {
                self.minPrice = model.price;
            }
            if (model.price > self.maxPrice) {
                self.maxPrice = model.price;
            }
            self.totalCount += model.volum;
            self.totalMoney += model.price * model.volum;
            model.pointAvgPrice = self.totalMoney / self.totalCount;
        }else{
            model.volum = [self randFloatBetween:100.0 and:1000.0];
            model.rise = YES;
            self.minVolum = 0;
            self.maxVolum = model.volum;
            model.pointAvgPrice = model.price;
            self.maxPrice = model.price;
            self.minPrice = model.price;
        }
        preModel = model;
    }
//    self.maxPrice *=  1.0000002;
//    self.minPrice *=  0.9999999;
}

- (double)randFloatBetween:(double)low and:(double)high{
    return  floorf(((double)arc4random() / ARC4RANDOM_MAX) * high) + low;
}


//- (double)randVolumn{
//    CGFloat percentage = 1 + ((float)(1+arc4random()%99)/100)*0.2;
//    NSMutableArray *volumnArr =@[].mutableCopy;
//
//    NSInteger i= -1;
//    FenshiModel *lastModel;
//    for (FenshiModel *model in _trendItems){
//        i++;
//        if(i == 0){
//            model.volum = [self randFloatBetween:100.0 and:1000.0];
//        }else{
//            model.volum= model.volum - lastModel.volum;
//        }
//        lastModel = model;
//
//        [volumnArr addObject:@(model.volum)];
//    }
//    NSNumber *averageVolumn = [volumnArr valueForKeyPath:@"@avg.floatValue"];
//    return [averageVolumn doubleValue]*percentage;
//}

- (void)setPointViewWithItem:(FenshiModel *)item{
    for (FenshiModel *model in _trendItems){
        model.pointValuePrice = (self.minPrice - model.price) / (self.maxPrice - self.minPrice);
        model.pointValueAvgPrice = (self.minPrice - model.pointAvgPrice) / (self.maxPrice - self.minPrice);
        model.pointValueVolum = (model.volum - self.minVolum) / (self.maxVolum - self.minVolum);
    }
}

- (void)updateFromItem:(FenshiModel *)item{
    NSMutableArray *arr = [_trendItems mutableCopy];
    if (arr == nil) {
        return;
    }
    FenshiModel *lastPreItem = _trendItems[_trendItems.count - 1];
    NSInteger count = arr.count;
    BOOL isSame = NO;
    NSString *strLastPri =  [[NSDate dateWithTimeIntervalSince1970:lastPreItem.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    NSString *strItem = [[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"dd HH:mm"];
    if ([strLastPri isEqualToString:strItem]) {
        isSame = YES;
    }
    for (NSInteger i = count - 1; i>=0; i--) {
        NSInteger mineSepa = ([[[NSDate dateWithTimeIntervalSince1970:item.time / 1000.0] stringWithFormat:@"mm"] integerValue] - [[[NSDate dateWithTimeIntervalSince1970:lastPreItem.time / 1000.0] stringWithFormat:@"mm"] integerValue]);
        if ((lastPreItem.time < item.time && mineSepa >= 1) || isSame) {
            item.volum = item.totalVolum - lastPreItem.totalVolum;
            if (item.volum <= 0) {
                item.volum = [self randFloatBetween:self.minVolum and:self.maxVolum];
            }
            if (item.volum < self.minVolum) {
                self.minVolum = item.volum;
            }
            if (item.volum > self.maxVolum) {
                self.maxVolum = item.volum;
            }
            if (isSame) {
                self.totalCount+= (item.volum - lastPreItem.volum);
                self.totalMoney += (item.volum * item.price - lastPreItem.volum *lastPreItem.price);
            }else{
                self.totalCount+= item.volum;
                self.totalMoney += item.volum * item.price;
            }
            
            item.pointAvgPrice = self.totalMoney / self.totalCount;
            if (item.maxPrice > 0) {
                if (self.maxPrice < item.maxPrice) {
                    self.maxPrice = item.maxPrice;
                }
                
            }
            if (item.minPrice > 0) {
                if (item.minPrice < self.minPrice) {
                    self.minPrice = item.minPrice;
                }
            }
            if (item.price < self.minPrice) {
                self.minPrice = item.price;
            }
            
            if (item.price > self.maxPrice) {
                self.maxPrice = item.price;
            }
            if (isSame) {
                [_trendItems replaceObjectAtIndex:i withObject:item];
            }else{
                lastPreItem.lineTime = @"";
                [_trendItems insertObject:item atIndex:i + 1];
            }
            break;
        }
    }
    NSMutableArray *priceArr =@[].mutableCopy;
    for (FenshiModel *model in _trendItems){
        [priceArr addObject:@(model.price)];
    }
    NSNumber *maxPrice = [priceArr valueForKeyPath:@"@max.self"];
    NSNumber *minPrice = [priceArr valueForKeyPath:@"@min.self"];
    
    //调整比例尺
    self.maxPrice = [maxPrice doubleValue]*1.0002;
    self.minPrice = [minPrice doubleValue]*0.9999;
    [self setPointViewWithItem:item];
}
//
- (void)updateFromItems:(NSArray *)items{
    NSMutableArray *array = self.trendItems.mutableCopy;
      NSInteger count = array.count;
    for (FenshiModel *item in items) {
        for (NSInteger i = count - 1; i>=0; i--) {
            FenshiModel *ori = array[i];
            if (ori.time < item.time) {
                [array insertObject:item atIndex:i + 1];
                break;
            }else if (ori.time == item.time){
                [array replaceObjectAtIndex:i withObject:item];
                break;
            }
        }
    }
    _trendItems = [array copy];
}

- (NSArray *)fenshiTradeDrawPoint{
    return nil;
}

-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        // chadeltu 加了(Bytef *)
        strm.next_out = (Bytef *)[decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

//获取0-1之间的随机数
- (float)randomNum{
    return (float)(1+arc4random()%99)/100 ;
}

- (float)getVol:(double)targetAverage{
    double percentage = 0.3 + [self randomNum] * 1.1;
    return targetAverage *percentage;
}


- (NSArray*)getDataWithFenshiData:(NSArray*)fenshiData{
    NSMutableArray *mutaArr =@[].mutableCopy;
    if(fenshiData.count == 0) return @[];
    int numberOfLinesInVol = 1;
    double averageOnPreviousDay = 0;
    if(fenshiData.count>1){
        FenshiModel *model0 = [fenshiData firstObject];
        FenshiModel *model1 = fenshiData[1];
        numberOfLinesInVol = ceil(86400000 / (model1.time - model0.time));
        if(numberOfLinesInVol>1440){
            numberOfLinesInVol = 1440;
        }
        
        averageOnPreviousDay = model0.volum / ((double) numberOfLinesInVol);
       
    }
    int index = 0;
    FenshiModel *model0 = [fenshiData firstObject];
    double lastVol = fenshiData.count==0 ? 0 : model0.volum;
    for (FenshiModel* model in fenshiData) {
        double diff = model0.volum - lastVol;
        double newVol = diff + averageOnPreviousDay;
        if(newVol<0.3*averageOnPreviousDay){
            newVol = 0.3 *averageOnPreviousDay;
        }
        if(newVol >3*averageOnPreviousDay){
            newVol = 3*averageOnPreviousDay;
        }
        
        lastVol = model.volum;
        index = (index + 1) % numberOfLinesInVol;
        
        model.volum = newVol;
        
        [mutaArr addObject:model];
        if((index%numberOfLinesInVol) == 0){
            averageOnPreviousDay = model.volum /((double)numberOfLinesInVol);
        }
    }
    return mutaArr;
}

- (NSArray*)getDataWithModelArr:(NSArray*)fenshiArr{
    NSMutableArray *mutaArr = @[].mutableCopy;
    if(fenshiArr.count ==0) return @[];
    double sum = 0, count = 0;
    for (FenshiModel *model in fenshiArr) {
        double vol = model.volum;
        if (vol > 0) {
            sum += vol;
            count ++;
        } else if (count > 0) {
            // 如果该点没有值，则取接近平均数的随即值
            vol = [self getVol:sum/count];  //getVol(sum / count);
        } else {
            vol = 0;
        }
        [mutaArr addObject:model];
    }
    return mutaArr;
}

- (NSArray*)getDataWithKlineNotSubData:(NSArray*)klineArr{
    NSMutableArray *mutaArr = @[].mutableCopy;
    if(klineArr.count ==0) return @[];
    double sum = 0, count = 0;
    KLineModel *lastModel;
    NSInteger i = -1;
    for (KLineModel*model in klineArr) {
        i++;
        if(i>0){
            model.openPrice = lastModel.closePrice;
        }
        double vol = model.volume;
        if (vol > 0) {
            sum += vol;
            count ++;
        } else if (count > 0) {
            // 如果该点没有值，则取接近平均数的随即值
            vol = [self getVol:sum/count];  //getVol(sum / count);
        } else {
            vol = 0;
        }
        model.volume = vol;
        [mutaArr addObject:model];
        lastModel = model;
    }
    return mutaArr;
}


- (NSArray*)getDataWithKlineData:(NSArray*)klineArr{
    NSMutableArray *mutaArr =@[].mutableCopy;
    if(klineArr.count == 0) return @[];
    int numberOfLinesInVol = 1;
    double averageOnPreviousDay = 0;
    
    if(klineArr.count>1){
        KLineModel *model0 = [klineArr firstObject];
        KLineModel *model1 = klineArr[1];
        numberOfLinesInVol = ceil(86400000 / (model1.currentTime - model0.currentTime));
        if(numberOfLinesInVol>1440){
            numberOfLinesInVol = 1440;
        }
        if(model0.volume == 0){
            model0.volume = 100;
        }
        averageOnPreviousDay = model0.volume / ((double) numberOfLinesInVol);
    }
    int index = 0;
    KLineModel *model0 = [klineArr firstObject];
    double lastVol = klineArr.count==0 ? 0 : model0.volume;
    
    KLineModel *lastModel;
    NSInteger i =-1;
    for (KLineModel* model in klineArr) {
        i++;
        //下一个开盘价 等于上一个收盘价
        if(i>0){
            model.openPrice = lastModel.closePrice;
        }
        double diff = model.volume - lastVol;
        double newVol = diff + averageOnPreviousDay;
        if(newVol<0.3*averageOnPreviousDay){
            newVol = 0.3 *averageOnPreviousDay;
        }
        if(newVol >3*averageOnPreviousDay){
            newVol = 3*averageOnPreviousDay;
        }
        
        lastVol = model.volume;
        index = (index + 1) % numberOfLinesInVol;
        
        model.volume = newVol;
        
        [mutaArr addObject:model];
        if((index%numberOfLinesInVol) == 0){
            averageOnPreviousDay = model.volume /((double)numberOfLinesInVol);
        }
        lastModel = model;
    }
    return mutaArr;
}

@end
