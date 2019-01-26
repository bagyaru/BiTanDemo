//
//  ADView.m
//  LaunchAD
//
//  Created by xiongoahc on 16/9/12.
//  Copyright © 2016年 xiongoahc. All rights reserved.
//

#import "ADView.h"

@interface ADView()

@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, strong) UIImageView *downIV;

@property (nonatomic, strong) NSTimer *countTimer;


@property (nonatomic, assign) NSUInteger count;

/** 广告图片本地路径 */
@property (nonatomic,copy) NSString *imgPath;

/** 新广告图片地址 */
@property (nonatomic,copy) NSString *imgUrl;

/** 新广告的链接 */
@property (nonatomic,copy) NSString *adUrl;

/** 新广告的ID */
@property (nonatomic,copy) NSString *splashId;

/** 所点击的广告链接 */
@property (nonatomic,copy) NSString *clickAdUrl;

/** 所点击的广告ID */
@property (nonatomic,copy) NSString *clickAdId;

/** 是否点击广告*/
@property (nonatomic,assign) BOOL isClickAd;

/** 点击图片回调block */
@property (nonatomic,copy) void (^clickImg)(NSString *url);

@end

@implementation ADView

-(NSUInteger)showTime
{
    if (_showTime == 0)
    {
        _showTime = 3;
    }
    return _showTime;
}

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

/**
 *  初始化
 *
 *  @param frame    坐标
 *  @param imgUrl 图片地址
 *  @param splashId 广告id
 *  @param adUrl    广告链接
 *  @param block    点击广告回调
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame imgUrl:(NSString *)img splashId:(NSInteger)adID adUrl:(NSString *)ad clickImg:(void (^)(NSString *))block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //给属性赋值
        _clickImg = block;
        _imgUrl   = img;
        _adUrl    = ad;
        _splashId = SAFESTRING(@(adID));
        
        //广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
        
        //跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - btnW - 24, kStatusBarHeight+10, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        _downIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-130, SCREEN_WIDTH, 130)];
        _downIV.userInteractionEnabled = YES;
        _downIV.contentMode = UIViewContentModeScaleAspectFill;
        _downIV.clipsToBounds = YES;

        if (iPhone5)  _downIV.image = IMAGE_NAMED(kIszh_hans?@"iPhone5":@"iPhone5_EN");
        if (iPhone6)  _downIV.image = IMAGE_NAMED(kIszh_hans?@"iPhone6":@"iPhone6_EN");
        if (iPhone6P) _downIV.image = IMAGE_NAMED(kIszh_hans?@"iPhone6P":@"iPhone6P_EN");
        if (iPhoneX)  _downIV.image = IMAGE_NAMED(kIszh_hans?@"iPhoneX":@"iPhoneX_EN");
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        [self addSubview:_downIV];
    }
    return self;
}


- (void)showWithShowInterval:(NSInteger)showInterval
{
    //判断本地缓存广告是否存在，存在即显示
    if ([self imageExist]) {
        //设置按钮倒计时
        [_countBtn setTitle:[NSString stringWithFormat:@"%@%zd",[APPLanguageService wyhSearchContentWith:@"tiaoguo"],self.showTime] forState:UIControlStateNormal];
        //当前显示的广告图片
        _adView.image = [UIImage imageWithContentsOfFile:_imgPath];
        //当前显示的广告链接
        _clickAdUrl = [UserDefaults valueForKey:adUrl];
        //当前显示的广告ID
        _clickAdId = [UserDefaults valueForKey:splashId];
        if (showInterval == 1) {//每天启动一次
            NSDate *date = [[BTSearchService sharedService] readBTSplashScreenDatatime];
            if (date == nil || ([[NSDate date] day] != date.day)) {//第一次启动或者当天没有启动
                
                //浏览PVUV
                [self splashAddPvuvWithDataType:1 splashId:_clickAdId.integerValue];
                //开启倒计时
                [self startTimer];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self];
                //写入这次启动的时间
                [[BTSearchService sharedService] writeBTSplashScreenDatatime];
            }else {//防止在改显示间隔期间 闪屏信息过期或者更新 而本地信息没有变更
                
                [self splashScreenAPI];
            }
        }
        if (showInterval == 2) {//每次启动
            
            //浏览PVUV
            [self splashAddPvuvWithDataType:1 splashId:_clickAdId.integerValue];
            //开启倒计时
            [self startTimer];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self];
        }
        if (showInterval == 3) {//点击后不再显示(只启动一次)
            
            if ([UserDefaults boolForKey:splashScreenIsOrNoShow]) {
                //防止在改显示间隔期间 闪屏信息过期或者更新 而本地信息没有变更
                [self splashScreenAPI];
                return;
            }
            //浏览PVUV
            [self splashAddPvuvWithDataType:1 splashId:_clickAdId.integerValue];
            //开启倒计时
            [self startTimer];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self];
            [UserDefaults setBool:YES forKey:splashScreenIsOrNoShow];
            [UserDefaults synchronize];
        }
    }
    else
    {
        //获取最新图片
        //[self setNewADImgUrl:_imgUrl];
        [self splashScreenAPI];
    }
    
}


//判断沙盒中是否存在广告图片，如果存在，直接显示
- (BOOL)imageExist
{
    
    _imgPath = [self getFilePathWithImageName:[UserDefaults valueForKey:adImageName]];
    
    NSLog(@"===%@",[UserDefaults valueForKey:adImageName]);
    NSLog(@"===%@",_imgPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:_imgPath];
    return isExist;
//    if (![UserDefaults valueForKey:adImageName]) {
//
//
//    }else {
//
//        return NO;
//    }
}


//跳转到广告页面
- (void)pushToAd{
    if (_clickAdUrl)
    {
        self.isClickAd = YES;
        //点击PVUV
        [self splashAddPvuvWithDataType:2 splashId:_clickAdId.integerValue];
        //把所点击的广告链接回调出去
        _clickImg(_clickAdUrl);
        [self dismiss];
    }
    
}

//跳过
- (void)countDown
{
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"%@%zd",[APPLanguageService wyhSearchContentWith:@"tiaoguo"],_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss];
    }
}


// 定时器倒计时
- (void)startTimer
{
    _count = self.showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}


// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        //获取最新图片,为下一次启动做准备
        //[self setNewADImgUrl:_imgUrl];
        [self splashScreenAPI];
    }];
}
#pragma marl - 调用闪屏接口
-(void)splashScreenAPI {
    [self checkIsSignIn];
    if (!self.isClickAd) {
        //[getUserCenter enterTheHistoryVC];
    }
    BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
    if (localModel) {
        BTValidateSplashVersionRequest *API = [[BTValidateSplashVersionRequest alloc] initWithSplashVersion:localModel.splashVersion splashId:localModel.splashId];
        [API requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            BOOL isGQ = [request.data boolValue];
            if (isGQ) {//本地闪屏信息可用
                 NSLog(@"可用");
            }else {//本地闪屏信息不可用（过期）
                [self splashScreenOverdueUIWithType:1];
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }else {//本地闪屏信息（没有）
        
        [self splashScreenOverdueUIWithType:2];
    }
    
}
#pragma marl - 调用闪屏UI 本地闪屏信息(没有或者过期) 更新闪屏信息
-(void)splashScreenOverdueUIWithType:(NSInteger)type {//本地闪屏信息(没有或者过期) 更新闪屏信息
    
    BTSplashShowRequest *api = [BTSplashShowRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        if ([request.data isKindOfClass:[NSDictionary class]]) {
            BTSplashScreenModel *model = [BTSplashScreenModel objectWithDictionary:request.data];
            
            if (iPhone6) {
                model.localPic = model.pic1;
            }else if (iPhone6P) {
                model.localPic = model.pic2;
            }else if (iPhoneX) {
                model.localPic = model.pic3;
            }else {
                model.localPic = model.pic1;
            }
            [[BTSearchService sharedService] writeBTSplashScreenModel:model];
            
            //获取图片名字（***.png）
            NSString *imgName = [model.localPic lastPathComponent];
            
            //拼接沙盒路径
            NSString *filePath = [self getFilePathWithImageName:imgName];
            //判断路径是否存在
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isExist = [fileManager fileExistsAtPath:filePath];
            if (!isExist){// 如果本地没有该图片，下载新图片保存，并且删除旧图片
                [self downloadAdImageWithUrl:model.localPic imageName:imgName];
            }else {// 如果本地有该图片 但是其他的本地信息有变化 需要更改其他的本地信息
                if (!ISStringEqualToString(model.redirectInfo, [UserDefaults valueForKey:adUrl])||!ISStringEqualToString(SAFESTRING(@(model.splashId)), [UserDefaults valueForKey:splashId])) {
                    [self downloadAdImageWithUrl:model.localPic imageName:imgName];
                }
            }
        }else {
            
            [[BTSearchService sharedService] clearBTSplashScreenModel];
            
            //删除旧广告图片
            [self deleteOldImage];
            //设置新图片
            [UserDefaults setValue:nil forKey:adImageName];
            //设置广告链接
            [UserDefaults setValue:nil forKey:adUrl];
            //设置广告ID
            [UserDefaults setValue:nil forKey:splashId];
            [UserDefaults synchronize];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.error);
    }];
}
//获取最新广告
- (void)setNewADImgUrl:(NSString *)imgUrl
{
    //获取图片名字（***.png）
    NSString *imgName = [imgUrl lastPathComponent];
    //拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imgName];
    //判断路径是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (!isExist){// 如果本地没有该图片，下载新图片保存，并且删除旧图片
        [self downloadAdImageWithUrl:imgUrl imageName:imgName];
    }else {// 如果本地有该图片 但是其他的本地信息有变化 需要更改其他的本地信息
        if (!ISStringEqualToString(_adUrl, [UserDefaults valueForKey:adUrl])||!ISStringEqualToString(_splashId, [UserDefaults valueForKey:splashId])) {
            [self downloadAdImageWithUrl:imgUrl imageName:imgName];
        }
    }
}
/**
 *  下载新图片(这里也可以自己使用SDWebImage来下载图片)
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            //删除旧广告图片
            [self deleteOldImage];
            //设置新图片
            [UserDefaults setValue:imageName forKey:adImageName];
            //设置广告链接
            [UserDefaults setValue:localModel.redirectInfo forKey:adUrl];
            //设置广告ID
            [UserDefaults setValue:SAFESTRING(@(localModel.splashId)) forKey:splashId];
            [UserDefaults synchronize];
        }else{
            NSLog(@"保存失败");
        }
        
    });
}


/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{

    if (imageName) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        NSString *imgPath =[cachesPath stringByAppendingPathComponent:imageName];
        return imgPath;
    }
    return nil;
}


/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [UserDefaults valueForKey:adImageName];
    BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
    NSString *NewImageName = [localModel.localPic lastPathComponent];
    if (imageName && !ISStringEqualToString(imageName, NewImageName)) {
        NSString *imgPath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imgPath error:nil];
    }
    if ([[BTSearchService sharedService] readBTSplashScreenDatatime]) {//删除旧广告的启动时间
       
        [[BTSearchService sharedService] clearBTSplashScreenDatatime];
    }
    [UserDefaults setBool:NO forKey:splashScreenIsOrNoShow];//只启动一次的标签重新设置
    [UserDefaults synchronize];
}
//闪屏pvuv
- (void)splashAddPvuvWithDataType:(NSInteger)dataType splashId:(NSInteger)splashId
{
    if (dataType == 1) {
        
        [MobClick event:@"flash"];//曝光量
    }else {
        
        [MobClick event:@"flash_click"];//点击量
    }
    BTSplashAddPvuvRequest *API = [[BTSplashAddPvuvRequest alloc] initWithDataType:dataType splashId:splashId];
    
    [API requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        
    } failure:^(__kindof BTBaseRequest *request) {
        NSLog(@"%@",request.error);
    }];
}
#pragma mark - 判断是否已经签到
-(void)checkIsSignIn{
    
    if (![getUserCenter isLogined]) return;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:continueQianDao]) {
        return;
    }
    
    BTIsSignInRequest *request = [BTIsSignInRequest new];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        //false表示未签到
        if (![request.data integerValue]) {
            DLog(@"++++");
            [TPAlertView showTPAlertView:AlertTypeNOTSign day:0 award:0 btnClick:^{
                [AnalysisService alaysismine_page_tanli];
                [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isContinue":@(YES)}];
            }];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
}
@end
