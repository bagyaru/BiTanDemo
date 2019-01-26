//
//  BTUserCenter.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserCenter.h"
#import "TTTAttributedLabel.h"
#import "zlib.h"
#import "BTVersionReleaseRequest.h"
#import "THFVersionObj.h"
#import "BTSaveErrorLogRequest.h"
#import "BTSearchService.h"
#import "BTBiQuanXiangGuanCaoZuoRequest.h"
#import "BTViewControllerSetting.h"
#import "BTBitaneIndexModel.h"
#import "BTRecordModel.h"
#import "BTExchangeListModel.h"
#import "BTZFFFModel.h"
#import "BTPromptUpdateView.h"
#import "BTGetTanLiAlertView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "UIView+CLFrame.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
#import "BTExceptionalTPRequest.h"
#import "WBStatusHelper.h"

#define UILABEL_LINE_SPACE 2
#define anHour  3600
#define aMinute 60
#define NIKENAME_REGULAR @"@[a-zA-Z0-9_\\-\\u4e00-\\u9fa5]{2,12}"
#define CURRENCY_FUTURES_REGULAR @"#[^@#]+?#"
#define CURRENCY_FUTURES_REGULAR_New @"#\\[([^\\[]*)\\]\\(([^\\(]*)\\)#"
@implementation BTUserCenter
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        self.userInfo      = [BTUserInfo loadFromClassFile];
        self.detailMyInfo  = [MyInfoObJ loadFromClassFile];
    }
    return self;
}
#pragma mark -仅仅拉起登陆页面
-(void)loginoutPullView
{
    
   [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil];
}

#pragma mark -退出登录，回到首页吊起登陆
- (void)loginout
{
    [self clearData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_loginOutSuccess object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -清空本地用户数据
-(void)clearData
{
    self.userInfo = nil;
    self.detailMyInfo = nil;
    [BTGetUserInfoDefalut sharedManager].userInfo = nil;
    [BTUserInfo deleteClassFile];
    [MyInfoObJ deleteClassFile];
    [[BTSearchService sharedService] clearExchangeAuthorized];
    [AppHelper clearTanliTime];
    appDelegate.listModel = nil;
    
    
}
#pragma mark -退出登录，回到首页
-(void)loginoutGotoMain
{
    //    [self clearData];
    //    [getMainTabBar guideToHome];
    //    getMainTabBar.tabBar.hidden = NO;
}
#pragma mark -极光设置别名
-(void)JPUSHLogin {
    
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPUSHLogin"];
    //NSLog(@"%@",GetUUID);
    if (!ISNSStringValid(version)) {
        
        [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",TestOrOneLine,GetUUID] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"%ld%@",(long)iResCode,iAlias);
            if (iResCode == 0) {
                
                NSLog(@"设置别名成功");
                [[NSUserDefaults standardUserDefaults] setObject:@"JPUSHLogin" forKey:@"JPUSHLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } seq:10];
    }
    
}
#pragma mark -极光删除别名
-(void)JPUSHDeleteBM {
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            
            NSLog(@"删除别名成功");
        }
    } seq:10];
}
#pragma mark -判断是否登录
- (BOOL)isLogined
{
    if (self.userInfo.userId != 0 && self.userInfo.mobile.length != 0 && self.userInfo.token.length != 0)
    {
        return YES;
    }
    return NO;
}
-(void)reloadUserInfo {
    
    
}
//设置行间距
-(void)getLabelHight:(UILabel *)label Float:(CGFloat)floatN AddImage:(BOOL)isAdd{
    
    NSString * address = label.text;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //iOS - NSString换行符
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    label.text = address;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:floatN];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [label.text length])];
    if (isAdd) {
        
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"jinghua_icon"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, -2, 44, 16);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributedString1 insertAttributedString:string atIndex:0];
    }
    
    // 用label的attributedText属性来使用富文本
    [label setAttributedText:attributedString1];
    [label sizeToFit];
}

//UILabel自定义行间距时获取高度(1个label)
-(float)customGetContactHeight:(NSString*)contact FontOfSize:(CGFloat)font LabelMaxWidth:(CGFloat)width jianju:(CGFloat)jianju
{
    
    NSString * address = contact;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    //address = [address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    //address = [address stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contact = address;
    
    //获取tttLabel的高度
    //先通过NSMutableAttributedString设置和上面tttLabel一样的属性,例如行间距,字体
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contact];
    //自定义str和TTTAttributedLabel一样的行间距
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrapStyle setLineSpacing:jianju];
    //设置行间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, contact.length)];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, contact.length)];
    //得到自定义行间距的UILabel的高度
    CGFloat height = [TTTAttributedLabel sizeThatFitsAttributedString:attrString withConstraints:CGSizeMake(width, MAXFLOAT) limitedToNumberOfLines:0].height;
    
    
    return height;
    
}
//(无误差)UILabel自定义行间距切（自定义字体）时获取高度(1个label)
-(float)RightCustomGetContactHeight:(NSString*)contact FontOfSize:(UIFont *)font LabelMaxWidth:(CGFloat)width jianju:(CGFloat)jianju
{
    
    NSString * address = contact;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contact = address;
    
    //获取tttLabel的高度
    //先通过NSMutableAttributedString设置和上面tttLabel一样的属性,例如行间距,字体
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contact];
    //自定义str和TTTAttributedLabel一样的行间距
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrapStyle setLineSpacing:jianju];
    //设置行间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, contact.length)];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contact.length)];
    //得到自定义行间距的UILabel的高度
    CGFloat height = [TTTAttributedLabel sizeThatFitsAttributedString:attrString withConstraints:CGSizeMake(width, MAXFLOAT) limitedToNumberOfLines:0].height;
    
    
    return height;
    
}
//UILabel自定义行间距时获取高度(1个label)
-(float)customGetContactHeight:(NSString*)contact FontOfSize:(CGFloat)font LabelMaxWidth:(CGFloat)width
{
    
    NSString * address = contact;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    //address = [address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    //address = [address stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contact = address;
    
    //获取tttLabel的高度
    //先通过NSMutableAttributedString设置和上面tttLabel一样的属性,例如行间距,字体
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contact];
    //自定义str和TTTAttributedLabel一样的行间距
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrapStyle setLineSpacing:8.0];
    //设置行间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, contact.length)];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, contact.length)];
    //得到自定义行间距的UILabel的高度
    CGFloat height = [TTTAttributedLabel sizeThatFitsAttributedString:attrString withConstraints:CGSizeMake(width, MAXFLOAT) limitedToNumberOfLines:0].height;
    
    
    return height;
    
}
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font withHJJ:(CGFloat)HJJ withZJJ:(CGFloat)ZJJ{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HJJ; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(ZJJ)
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
//计算UILabel的高度(自定义行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withHJJ:(CGFloat)HJJ withZJJ:(CGFloat)ZJJ{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HJJ;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(ZJJ)
                          };
    //CGSize size = [[self DetermineWhetherTheFuturesOrCurrencyOnThePost:str] boundingRectWithSize:CGSizeMake(width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
- (NSString *)DetermineWhetherTheFuturesOrCurrencyOnThePost:(NSString *)str {
    
    __block NSMutableString *changeStr = [NSMutableString stringWithString:str];
    __block NSString *resoultStr = @"";
    NSLog(@"%@",changeStr);
    [NSRegularExpression arrayOfCheckStringWithRegularExpression:NIKENAME_REGULAR expression:CURRENCY_FUTURES_REGULAR_New checkString:str completion:^(NSMutableArray *aitStrArray, NSMutableArray *aitRangArray, NSMutableArray *jingStrArr, NSMutableArray *jingRangeArr) {
        
        //变色的字体加 点击事件 数组
        for (int i = 0; i < jingRangeArr.count; i++) {//说明有符合（期货与币种的帖子）的正则
            
            NSString *jingStr = jingStrArr[i];
            NSRange jingRange = [jingRangeArr[i] rangeValue];
            //获取用户可以看到的信息
            NSRange startRange = [jingStr rangeOfString:@"["];
            NSRange endRange = [jingStr rangeOfString:@"]"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            //替换成处理过的字符串
            NSString *showStr = [NSString stringWithFormat:@"#%@#",[jingStr substringWithRange:range]];
            //更新 UIlabel展示的文字
            resoultStr = [changeStr stringByReplacingCharactersInRange:jingRange withString:showStr];
        }
        
    }];
    
    NSLog(@"%@",resoultStr);
    
    return resoultStr;
}
- (NSString *)minutestimeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
//获得当前的时间字符串
- (NSString *)nowTimeWithDate:(NSDate *)date {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    
    NSString * nowDate = [dateFormatter stringFromDate:date];
    
    return nowDate;
}
-(NSArray *)jsonStringChangeArray:(NSString *)jsonStr {
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
    }
    //NSLog(@"%@",[dic objectForKey:@"contentslide"]);
    
    return dic;
}
-(NSDictionary *)jsonStringChangeDict:(NSString *)jsonStr {
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
    }
    //NSLog(@"%@",[dic objectForKey:@"contentslide"]);
    
    return dic;
}

-(NSString *)dictionaryToJSONString:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


-(NSString *)arrayToJSONString:(NSMutableArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
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
- (void)writeDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate date] forKey:@"updateTimeDate"];
}

- (NSDate *)readDatatime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"updateTimeDate"];
}
-(void)loadVesionCheck {
    
//    NSDate *date = [self readDatatime];
//    if (date == nil || ([[NSDate date] day] != date.day)) {//同一天只提示一次
//
//    }
    
    BTVersionReleaseRequest *api = [[BTVersionReleaseRequest alloc] initWithBTVersionReleaseRequest];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if ([request.data isKindOfClass:[NSDictionary class]]) {
            
            THFVersionObj *obj = [THFVersionObj objectWithDictionary:request.data];
            
            NSLog(@"%ld",(long)obj.buildVersion);
            NSLog(@"%ld",(long)obj.forceUpdate);
            if (obj.buildVersion > VersionNumber.integerValue) {
                
                [BTPromptUpdateView showWithRecordModel:obj completion:^(THFVersionObj *model) {
                    
                    
                }];
            }
        }
        
        //成功倒计时
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
   
}
-(NSString *)getImageURLSizeWithWeight:(NSInteger)weight andHeight:(NSInteger)height {
    
   //NSString *sizeStr = [NSString stringWithFormat:@"imageMogr2/auto-orient/thumbnail/%ldx%ld/blur/1x0/quality/100/imageslim",weight,height];
    
    return @"";
}
- (void)extracted:(BTSaveErrorLogRequest *)api {
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"上传成功");
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

-(void)saveErrorLogToServiceWith:(NSString *)apiUrl errorMsg:(NSString *)errorMsg {
    
    BTSaveErrorLogRequest *api = [[BTSaveErrorLogRequest  alloc] initWithApiUrl:apiUrl errorMsg:errorMsg];
    
    [self extracted:api];
}
-(void)creatRemindViewWithString:(NSString *)title {//记账
    
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    self.RemindView.backgroundColor = [UIColor clearColor];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.RemindView];
    self.RemindView.contentL.text = title;
    ViewRadius(self.RemindView.goDetailBtn, 18);
    [self.RemindView.cancellBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.RemindView.goDetailBtn addTarget:self action:@selector(goDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)creatRemindViewWithString:(NSString *)title dict:(NSDictionary *)dict {
    NSInteger View_Y = 80*(self.PriceWarningViewNumber+1);
   BTPriceWarningAlertView *PriceWarningView = [BTPriceWarningAlertView loadFromXib];
    
    self.dict = dict;
    PriceWarningView.dict = dict;
    PriceWarningView.title = title;
    [kAppWindow addSubview:PriceWarningView];
    PriceWarningView.frame = CGRectMake(15, ScreenHeight, ScreenWidth-30, 60);
    self.PriceWarningViewNumber++;
    PriceWarningView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        PriceWarningView.alpha = 1;
        PriceWarningView.frame = CGRectMake(15, ScreenHeight-kTabBarHeight-View_Y, ScreenWidth-30, 60);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        PriceWarningView.alpha = 1;
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             PriceWarningView.alpha = 0;
                             PriceWarningView.frame = CGRectMake(15, ScreenHeight, ScreenWidth-30, 60);
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 
                                 [PriceWarningView removeFromSuperview];
                                 self.PriceWarningViewNumber--;
                             }
                             
                         }];
    });
}
//去币详情
-(void)goBZDetailBtnClick {
    
    [self.RemindView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.RemindView = nil;
    self.backView  = nil;
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:self.dict];
}
//去记账页面
-(void)goDetailBtnClick {
    
    [self.RemindView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.RemindView = nil;
    self.backView  = nil;
    NSLog(@"%@",[BTCMInstance instanceWithControllerName:@"LncomeStatisticsMain"]);
    if (![BTCMInstance instanceWithControllerName:@"LncomeStatisticsMain"]) {
        
        [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];
    }
}
-(void)closeBtnClick {
    
    [AnalysisService alaysisHome_windows_button_00];
    [self.RemindView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.RemindView = nil;
    self.backView  = nil;
    
}
-(void)shareSuccseGetTanLiWithType:(NSInteger)type withTime:(CGFloat)time {
    if ([self isLogined]) {
        
        //不占用主线程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            
            BTMyCoinRewardRequest *api = [[BTMyCoinRewardRequest alloc] initWithType:type userId:self.userInfo.userId];
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                NSLog(@"成功");
                NSInteger reward = [request.data[@"reward"] integerValue];
                if (reward != 0) {//任务没有超过次数
                    
                    [self showTanLiJiangLiToast:[NSString stringWithFormat:@"+%ldTP",reward]];
//                    BTGetTanLiAlertView *alert = [BTGetTanLiAlertView loadFromXib];
//                    alert.isClear = YES;
//                    alert.dict = @{@"tp":[NSString stringWithFormat:@"+%ldTP",reward],@"name":request.data[@"getway"]};
//                    [alert show];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
//
//                        [alert __hide];
//                    });
                }
                
            } failure:^(__kindof BTBaseRequest *request) {
                NSLog(@"失败");
            }];
        });//这句话的意思是1.5秒后，把label移出视图
    }
}
-(void)showTanLiJiangLiToast:(NSString *)tp {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = isNightMode ? ViewBGNightColor : KWhiteColor;
    view.layer.cornerRadius = 22.0f;
    view.layer.masksToBounds = NO;
    
    view.layer.shadowColor = FirstColor.CGColor;
    view.layer.shadowOpacity = 0.06f;
    view.layer.shadowRadius = 22.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    [kAppWindow addSubview:view];
    
    UIImageView *imageIV = [[UIImageView alloc] init];
    imageIV.image = IMAGE_NAMED(@"ic_tanli-yilingqu");
    imageIV.frame = CGRectMake(15, 6, 32, 32);
    [view addSubview:imageIV];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.frame    = CGRectMake(15+32+10, 11, 40, 22);
    numberLabel.text = tp;
    numberLabel.font = SYSTEMFONT(16);
    numberLabel.textColor = CBlackColor;
    [view addSubview:numberLabel];
    
    view.frame = CGRectMake((ScreenWidth-112)/2, ScreenHeight, 112, 44);
    view.alpha = 0;
    [self shakeToShow:view isHidden:NO];
    [UIView animateWithDuration:1.0 animations:^{
        view.alpha = 1;
        view.frame = CGRectMake((ScreenWidth-112)/2, ScreenHeight-kTabBarHeight-20-44, 112, 44);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        view.alpha = 1;
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             view.alpha = 0;
                            
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 
                                 [view removeFromSuperview];
                             }
                             
                         }];
    });
}
- (void)shakeToShow:(UIView*)aView isHidden:(BOOL)isHidden

{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 1.0;// 动画时间
    
    NSMutableArray *values = [NSMutableArray array];
    
    if (!isHidden) {//显示
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
    
    animation.values = values;
    
    [aView.layer addAnimation:animation forKey:nil];
    
}
-(void)biQuanXiangGuanCaoZuo:(NSInteger)articleId articleInfoType:(NSInteger)articleInfoType {
    //articleInfoType 操作类型 2分享 3收藏 4评论 5点赞
    BTBiQuanXiangGuanCaoZuoRequest *api = [[BTBiQuanXiangGuanCaoZuoRequest alloc] initWithArticleId:articleId articleInfoType:articleInfoType];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"成功");
    } failure:^(__kindof BTBaseRequest *request) {
        NSLog(@"失败");
    }];
}
#pragma mark lazy
-(UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] init];
        _backView.frame = ScreenBounds;
    }
    
    return _backView;
}
-(ChargeAccountRemindView *)RemindView {
    
    if (!_RemindView) {
        
        _RemindView = [ChargeAccountRemindView loadFromXib];
        _RemindView.frame = ScreenBounds;
    }
    
    return _RemindView;
}
-(BTPriceWarningAlertView *)PriceWarningView {
    
    if (!_PriceWarningView) {
        _PriceWarningView = [BTPriceWarningAlertView loadFromXib];
    }
    return _PriceWarningView;
}
-(void)shareBuriedPointWithType:(NSInteger)type withWhereVc:(NSInteger)whereVC {
    
    if (whereVC == 10) {//资讯分享
        
        switch (type) {
            case 0:
                [AnalysisService alaysisWeChat_info_sharing];
                break;
            case 1:
                 [AnalysisService alaysisWeibo_info_sharing];
                break;
            case 2:
                [AnalysisService alaysisMoments_info_sharing];
                break;
            default:
                break;
        }
        
    } else {//截屏分享
        
        switch (type) {
            case 0:
                [AnalysisService alaysisWeChat_screenshot_sharing];
                break;
            case 1:
                [AnalysisService alaysisWeibo_screenshot_sharing];
                break;
            case 2:
                [AnalysisService alaysisMoments_screenshot_sharing];
                break;
            default:
                break;
        }
    }
    
}
-(void)changeUILabelColor:(UILabel *)label and:(NSString *)str and:(NSString *)str1 color:(UIColor *)color{
    label.textColor = isNightMode ? ThirdNightColor :ThirdDayColor;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:label.text];
    //需要设置的位置
    NSRange redRange1 = NSMakeRange([[attributedString1 string] rangeOfString:str].location, [[attributedString1 string] rangeOfString:str].length);
    NSRange redRange2 = NSMakeRange([[attributedString1 string] rangeOfString:str1].location, [[attributedString1 string] rangeOfString:str1].length);
    //设置颜色
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:color range:redRange1];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:color range:redRange2];
    
    [label setAttributedText:attributedString1];
    
}
-(void)changeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color{
    
    label.textColor = isNightMode ? FirstNightColor :FirstDayColor;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:label.text];
    //需要设置的位置
    NSRange redRange1 = NSMakeRange([[attributedString1 string] rangeOfString:str].location, [[attributedString1 string] rangeOfString:str].length);
    //设置颜色
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:color range:redRange1];
    //[attributedString1 addAttribute:NSFontAttributeName value:FONT(@"PingFangSC-Medium", 14) range:redRange1];
    [label setAttributedText:attributedString1];
}
-(void)replyChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 7.0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    label.textColor = CFontColor16;
    NSDictionary *dic = @{NSFontAttributeName:SYSTEMFONT(font), NSParagraphStyleAttributeName:paraStyle};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
    //需要设置的位置
    NSRange redRange = NSMakeRange([[attributedString string] rangeOfString:str].location, [[attributedString string] rangeOfString:str].length);
    //设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    [label setAttributedText:attributedString];
}
-(void)sharePostContentWithTitle:(NSString *)title completion:(sharePostContentBlock)shareBlock {
    
    self.shareBlock = shareBlock;
    [NSRegularExpression arrayOfCheckStringWithRegularExpression:NIKENAME_REGULAR expression:CURRENCY_FUTURES_REGULAR_New checkString:title completion:^(NSMutableArray *aitStrArray, NSMutableArray *aitRangArray, NSMutableArray *jingStrArr, NSMutableArray *jingRangeArr) {
        
        NSLog(@"%@  %@==%@  %@",aitStrArray,aitRangArray,jingStrArr,jingRangeArr);
        //变色的字体加 点击事件 数组
        NSMutableString *changeStr = [[NSMutableString alloc] initWithFormat:@"%@",title];
        for (int i = 0; i < jingRangeArr.count; i++) {//说明有符合（期货与币种的帖子）的正则
            
            NSString *jingStr = jingStrArr[i];
            NSRange jingRange = [jingRangeArr[i] rangeValue];
            //获取用户可以看到的信息
            NSRange startRange = [jingStr rangeOfString:@"["];
            NSRange endRange = [jingStr rangeOfString:@"]"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            //替换成处理过的字符串
            NSString *showStr = [NSString stringWithFormat:@"#%@#",[jingStr substringWithRange:range]];
            //更新 UIlabel展示的文字
            changeStr = [changeStr stringByReplacingCharactersInRange:jingRange withString:showStr];
        }
        self.shareBlock(changeStr);
    }];
}
-(void)postNikeNameChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font {
    [NSRegularExpression arrayOfCheckStringWithRegularExpression:NIKENAME_REGULAR expression:CURRENCY_FUTURES_REGULAR_New checkString:str completion:^(NSMutableArray *aitStrArray, NSMutableArray *aitRangArray, NSMutableArray *jingStrArr, NSMutableArray *jingRangeArr) {
        
        //NSLog(@"%@  %@==%@  %@",aitStrArray,aitRangArray,jingStrArr,jingRangeArr);
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 7.0;
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        label.textColor = isNightMode ? FirstNightColor :FirstDayColor;
        NSDictionary *dic = @{NSFontAttributeName:SYSTEMFONT(font), NSParagraphStyleAttributeName:paraStyle};
        //变色的字体加 点击事件 数组
        NSMutableArray *changeColorClickArray = @[].mutableCopy;
        //设置颜色
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
        for (int i = 0; i < jingRangeArr.count; i++) {//说明有符合（期货与币种的帖子）的正则
            
            NSString *jingStr = jingStrArr[i];
            NSRange jingRange = [jingRangeArr[i] rangeValue];
            //获取用户可以看到的信息
            NSRange startRange = [jingStr rangeOfString:@"["];
            NSRange endRange = [jingStr rangeOfString:@"]"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            //替换成处理过的字符串
            NSString *showStr = [NSString stringWithFormat:@"#%@#",[jingStr substringWithRange:range]];
            //更新 UIlabel展示的文字
            label.text = [label.text stringByReplacingCharactersInRange:jingRange withString:showStr];
            //替换内容改变之后的富文本
            NSAttributedString *changeAttr = [[NSAttributedString alloc] initWithString:showStr attributes:dic];
            [attributedString replaceCharactersInRange:jingRange withAttributedString:changeAttr];
            //添加需要变色的range
            [attributedString addAttribute:NSForegroundColorAttributeName value:MainBg_Color range:NSMakeRange(jingRange.location, showStr.length)];
            //添加变色并可以点击的数据
            [changeColorClickArray addObject:showStr];
        }
        
        for (int j = 0; j < aitRangArray.count; j++) {
            //如果符合（期货与币种的帖子）的正则 @昵称的range也改变了 在最新的基础上获取@昵称的rang
            NSRange afterJingChangeRange = [label.text rangeOfString:aitStrArray[j]];
            NSRange beforeJingChangeRange = [aitRangArray[j] rangeValue];
            //防止一样的昵称 只变色一个
            if ((afterJingChangeRange.location != beforeJingChangeRange.location || afterJingChangeRange.length != beforeJingChangeRange.length) && [label.text containsString:aitStrArray[j]]) {
                NSInteger totalLength = beforeJingChangeRange.location + beforeJingChangeRange.length;
                afterJingChangeRange.location = totalLength > label.text.length ? afterJingChangeRange.location : beforeJingChangeRange.location;
                afterJingChangeRange.length   = beforeJingChangeRange.length;
            }
            //添加需要变色的range
            [attributedString addAttribute:NSForegroundColorAttributeName value:MainBg_Color range:afterJingChangeRange];
            //添加变色并可以点击的数据
            [changeColorClickArray addObject:aitStrArray[j]];
        }

        [label setAttributedText:attributedString];
        [label yb_addAttributeTapActionWithStrings:changeColorClickArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
            //验证是否有符合（期货与币种的帖子）的正则
           BOOL isHaveJing = [NSRegularExpression isMatchRegularExpression:CURRENCY_FUTURES_REGULAR checkString:string];
            if (isHaveJing) {//说明是 币种或者期货
                NSString *jingAllStr = jingStrArr[index];
            
                //获取需要跳转的参数
                NSRange startRange = [jingAllStr rangeOfString:@"("];
                NSRange endRange = [jingAllStr rangeOfString:@")"];
                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                //()里边的内容
                NSString * goDetailParameter = [jingAllStr substringWithRange:range];
                NSLog(@"%@",goDetailParameter);
                //判断是否是“1”开头 代表是币
                if ([goDetailParameter hasPrefix:@"1"]) {
                    
                    NSArray *goDetailParameterArray = [goDetailParameter componentsSeparatedByString:@"&"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    NSString *exchangeName = goDetailParameterArray[1];//交易所名字
                    NSString *exchangeCode = goDetailParameterArray[2];//交易所code
                    NSString *currencyStr  = goDetailParameterArray[3];//币种代码
                    
                    
                    if ([currencyStr containsString:@"/"]) {//交易对
                        [dict setObject:[currencyStr componentsSeparatedByString:@"/"][0] forKey:@"currencyCode"];
                        [dict setObject:[currencyStr componentsSeparatedByString:@"/"][1] forKey:@"currencyCodeRelation"];
                        [dict setObject:exchangeName forKey:@"exchangeName"];
                        [dict setObject:exchangeCode forKey:@"exchangeCode"];
                    }else {//币种
                        
                        [dict setObject:currencyStr  forKey:@"kindCode"];
                        [dict setObject:exchangeName forKey:@"exchangeName"];
                        [dict setObject:exchangeCode forKey:@"exchangeCode"];
                    }
                    if (dict.count > 0) {
                        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dict];
                    }
                    
                }else {//代表是期货（以2开头）
                    
                    NSArray *goDetailParameterArray = [goDetailParameter componentsSeparatedByString:@"&"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    NSString *exchangeCode = goDetailParameterArray[1];//交易所名字
                    NSString *kindName     = goDetailParameterArray[2];//交易所code
                    NSString *kindCode     = goDetailParameterArray[3];//币种代码
                    
                    [dict setObject:exchangeCode  forKey:@"exchangeCode"];
                    [dict setObject:kindName      forKey:@"kindName"];
                    [dict setObject:kindCode      forKey:@"kindCode"];
                    if (dict.count > 0) {
                        [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dict];
                    }
                }
                
            }else {//代表是@昵称 进个人主页
               
//                NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
//                YBAlertShow(message, @"取消");
//                if (![getUserCenter isLogined]) {
//                    [AnalysisService alaysisMine_login];
//                    [getUserCenter loginoutPullView];
//                    return;
//                }
//                [AnalysisService alaysisMine_editor];
                
                [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING([string stringByReplacingOccurrencesOfString:@"@" withString:@""])}];
            }
                
                
        }];
    }];
}
-(void)sourcePostNikeNameChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font {
    [NSRegularExpression arrayOfCheckStringWithRegularExpression:NIKENAME_REGULAR expression:CURRENCY_FUTURES_REGULAR_New checkString:str completion:^(NSMutableArray *aitStrArray, NSMutableArray *aitRangArray, NSMutableArray *jingStrArr, NSMutableArray *jingRangeArr) {
        
        //NSLog(@"%@  %@==%@  %@",aitStrArray,aitRangArray,jingStrArr,jingRangeArr);
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 7.0;
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        label.textColor = color;
        NSDictionary *dic = @{NSFontAttributeName:SYSTEMFONT(font), NSParagraphStyleAttributeName:paraStyle};
        //变色的字体加 点击事件 数组
        NSMutableArray *changeColorClickArray = @[].mutableCopy;
        //设置颜色
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
        for (int i = 0; i < jingRangeArr.count; i++) {//说明有符合（期货与币种的帖子）的正则
            
            NSString *jingStr = jingStrArr[i];
            NSRange jingRange = [jingRangeArr[i] rangeValue];
            //获取用户可以看到的信息
            NSRange startRange = [jingStr rangeOfString:@"["];
            NSRange endRange = [jingStr rangeOfString:@"]"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            //替换成处理过的字符串
            NSString *showStr = [NSString stringWithFormat:@"#%@#",[jingStr substringWithRange:range]];
            //更新 UIlabel展示的文字
            label.text = [label.text stringByReplacingCharactersInRange:jingRange withString:showStr];
            //替换内容改变之后的富文本
            NSAttributedString *changeAttr = [[NSAttributedString alloc] initWithString:showStr attributes:dic];
            [attributedString replaceCharactersInRange:jingRange withAttributedString:changeAttr];
            //添加需要变色的range
            [attributedString addAttribute:NSForegroundColorAttributeName value:MainBg_Color range:NSMakeRange(jingRange.location, showStr.length)];
            //添加变色并可以点击的数据
            [changeColorClickArray addObject:showStr];
        }
        
        for (int j = 0; j < aitRangArray.count; j++) {
            //如果符合（期货与币种的帖子）的正则 @昵称的range也改变了 在最新的基础上获取@昵称的rang
            NSRange afterJingChangeRange = [label.text rangeOfString:aitStrArray[j]];
            NSRange beforeJingChangeRange = [aitRangArray[j] rangeValue];
            //防止一样的昵称 只变色一个
            if ((afterJingChangeRange.location != beforeJingChangeRange.location || afterJingChangeRange.length != beforeJingChangeRange.length) && [label.text containsString:aitStrArray[j]]) {
                NSInteger totalLength = beforeJingChangeRange.location + beforeJingChangeRange.length;
                afterJingChangeRange.location = totalLength > label.text.length ? afterJingChangeRange.location : beforeJingChangeRange.location;
                afterJingChangeRange.length   = beforeJingChangeRange.length;
            }
            //添加需要变色的range
            [attributedString addAttribute:NSForegroundColorAttributeName value:MainBg_Color range:afterJingChangeRange];
            //添加变色并可以点击的数据
            [changeColorClickArray addObject:aitStrArray[j]];
        }
        
        [label setAttributedText:attributedString];
        [label yb_addAttributeTapActionWithStrings:changeColorClickArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
            //验证是否有符合（期货与币种的帖子）的正则
            BOOL isHaveJing = [NSRegularExpression isMatchRegularExpression:CURRENCY_FUTURES_REGULAR checkString:string];
            if (isHaveJing) {//说明是 币种或者期货
                NSString *jingAllStr = jingStrArr[index];
                
                //获取需要跳转的参数
                NSRange startRange = [jingAllStr rangeOfString:@"("];
                NSRange endRange = [jingAllStr rangeOfString:@")"];
                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                //()里边的内容
                NSString * goDetailParameter = [jingAllStr substringWithRange:range];
                NSLog(@"%@",goDetailParameter);
                //判断是否是“1”开头 代表是币
                if ([goDetailParameter hasPrefix:@"1"]) {
                    
                    NSArray *goDetailParameterArray = [goDetailParameter componentsSeparatedByString:@"&"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    NSString *exchangeName = goDetailParameterArray[1];//交易所名字
                    NSString *exchangeCode = goDetailParameterArray[2];//交易所code
                    NSString *currencyStr  = goDetailParameterArray[3];//币种代码
                    
                    
                    if ([currencyStr containsString:@"/"]) {//交易对
                        [dict setObject:[currencyStr componentsSeparatedByString:@"/"][0] forKey:@"currencyCode"];
                        [dict setObject:[currencyStr componentsSeparatedByString:@"/"][1] forKey:@"currencyCodeRelation"];
                        [dict setObject:exchangeName forKey:@"exchangeName"];
                        [dict setObject:exchangeCode forKey:@"exchangeCode"];
                    }else {//币种
                        
                        [dict setObject:currencyStr  forKey:@"kindCode"];
                        [dict setObject:exchangeName forKey:@"exchangeName"];
                        [dict setObject:exchangeCode forKey:@"exchangeCode"];
                    }
                    if (dict.count > 0) {
                        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dict];
                    }
                    
                }else {//代表是期货（以2开头）
                    
                    NSArray *goDetailParameterArray = [goDetailParameter componentsSeparatedByString:@"&"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    
                    NSString *exchangeCode = goDetailParameterArray[1];//交易所名字
                    NSString *kindName     = goDetailParameterArray[2];//交易所code
                    NSString *kindCode     = goDetailParameterArray[3];//币种代码
                    
                    [dict setObject:exchangeCode  forKey:@"exchangeCode"];
                    [dict setObject:kindName      forKey:@"kindName"];
                    [dict setObject:kindCode      forKey:@"kindCode"];
                    if (dict.count > 0) {
                        [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dict];
                    }
                }
                
            }else {//代表是@昵称 进个人主页
                
                [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING([string stringByReplacingOccurrencesOfString:@"@" withString:@""])}];
            }
            
            
        }];
    }];
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
        }}
    return rangeArray;
}
- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
- (NSInteger)timeDifferenceWithType:(NSString *)type {
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
   
    if ([userdefault objectForKey:type]) {//存在验证码时间
        
        //日期格式
        
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
        
        [myFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //验证码时间字符串
        
        NSString *orderedTime = [userdefault valueForKey:type];
        
        //验证码时间1
        
        NSDate *orderedDate = [myFormatter dateFromString:orderedTime];
        
        NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
        
        NSInteger interval1 = [zone1 secondsFromGMTForDate:orderedDate];
        
        NSDate *localDate1 = [orderedDate dateByAddingTimeInterval:interval1];
        
        
        
        //当前时间2
        
        NSDate *currentDate = [NSDate date];
        
        NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
        
        NSInteger interval2 = [zone2 secondsFromGMTForDate:currentDate];
        
        NSDate *localDate2 = [currentDate dateByAddingTimeInterval:interval2];
        
        // 时间2与时间1之间的时间差（秒）
        
        double intervalTime = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
        
        int iTime = (int)intervalTime;
        
        if (iTime >= 60) {//过期
            //[userdefault setObject:[self timeDifference_NowTimeWithDate:[NSDate date]] forKey:type];
            [userdefault removeObjectForKey:type];
            [userdefault synchronize];
            return 60;
            
        }else{
            
            return 60-iTime;//未过期
        };
        
    }else{//不存在登录时间
        
        [userdefault setObject:[self timeDifference_NowTimeWithDate:[NSDate date]] forKey:type];
        [userdefault synchronize];
        return 60;
    }
}
- (void)removeTimeDifferenceWithType:(NSString *)type {
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault removeObjectForKey:type];
    [userdefault synchronize];
    [self timeDifferenceWithType:type];
}
- (NSString *)timeDifference_NowTimeWithDate:(NSDate *)date {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * nowDate = [dateFormatter stringFromDate:date];
    
    return nowDate;
}
-(NSString *)getMiddleStars:(NSInteger)count {
    
    NSString *s = @"";
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            
            s = [NSString stringWithFormat:@"%@*",s];
        }
    }
    return s;
}
-(NSString *)getPhone:(NSString *)phone {
    
    if ([phone length] > 10) {
        
        NSString *head = [phone substringToIndex:3];
        NSString *foot = [phone substringFromIndex:[phone length] - 4];
        NSString *midd = [self getMiddleStars:[phone length] - 7];
        
        return [NSString stringWithFormat:@"%@%@%@",head,midd,foot];
    }else {
        
        NSString *head = [phone substringToIndex:2];
        NSString *foot = [phone substringFromIndex:[phone length] - 2];
        NSString *midd = [self getMiddleStars:[phone length] - 4];
        return [NSString stringWithFormat:@"%@%@%@",head,midd,foot];
    }
}
-(void)enterTheHistoryVC {
    
    NSDictionary *ctrlDict = BTViewControllerMap();
    NSLog(@"BTClassName = %@ and BTClassParameters = %@ BTGetMainTabBarSelectedIndex=%ld", [UserDefaults objectForKey:BTClassName], [UserDefaults objectForKey:BTClassParameters],[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]);
    
    if (ISNSStringValid([UserDefaults objectForKey:BTClassName])) {
        
        [ctrlDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSLog(@"key = %@ and obj = %@", key, obj);
            
            if ([obj isEqualToString:[UserDefaults objectForKey:BTClassName]]) {
                
                if (ISStringEqualToString(obj, @"BTExchangeContainerVC")) {
                    
                    BTExchangeListModel *model = [BTExchangeListModel modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
                    [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
                    [BTCMInstance pushViewControllerWithName:key andParams:@{@"model":model}];
                    return;
                }
                if (ISStringEqualToString(obj, @"QiHuoListViewController")) {
                    if ([[UserDefaults objectForKey:BTClassParameters] isKindOfClass:[NSDictionary class]]) {
                        
                        BTExchangeListModel *model = [BTExchangeListModel modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
                        [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
                        [BTCMInstance pushViewControllerWithName:key andParams:@{@"model":model}];
                        
                        return;
                    }else {
                        [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
                        [BTCMInstance pushViewControllerWithName:key andParams:nil];
                        return;
                    }
                }
                [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
                [BTCMInstance pushViewControllerWithName:key andParams:[UserDefaults objectForKey:BTClassParameters]];
                
            }
            
        }];
    }else {
        
        [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
    }
    
//    if (ISNSStringValid([UserDefaults objectForKey:BTClassName])) {
//
//        [ctrlDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//
//            NSLog(@"key = %@ and obj = %@", key, obj);
//
//            if ([obj isEqualToString:[UserDefaults objectForKey:BTClassName]]) {
//
//                if (ISStringEqualToString(obj, @"BTExchangeContainerVC")) {
//
//                    BTExchangeListModel *model = [BTExchangeListModel modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
//                    [BTCMInstance pushViewControllerWithName:key andParams:@{@"model":model}];
//                    return;
//                }
//
//                if (ISStringEqualToString(obj, @"H5ViewController")) {
//                    H5Node *node = [H5Node modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
//                    [BTCMInstance pushViewControllerWithName:key andParams:@{@"node":node}];
//                    return;
//                }
//                if (ISStringEqualToString(obj, @"BTIndexDetailViewController")) {
//                    BTBitaneIndexModel *model = [BTBitaneIndexModel modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
//                    [BTCMInstance pushViewControllerWithName:key andParams:@{@"model":model}];
//                    return;
//                }
//
//                if (ISStringEqualToString(obj, @"BTZFFBDetailViewController")) {//涨幅分布
//
//                    NSMutableArray *parametersArray = [UserDefaults objectForKey:BTClassParameters];
//                    NSMutableArray *dataArray = @[].mutableCopy;
//                    for (NSDictionary *dic in parametersArray) {
//                        NSMutableDictionary *smallDict = @{}.mutableCopy;
//                        NSArray *arr = dic[@"arr"];
//                        NSMutableArray *smallArr = @[].mutableCopy;
//                        for (NSDictionary *dict in arr) {
//                            BTZFFFModel *model = [BTZFFFModel modelWithJSON:dict];
//                            [smallArr addObject:model];
//                        }
//                        [smallDict setValue:smallArr forKey:@"arr"];
//                        [smallDict setValue:dic[@"total"] forKey:@"total"];
//                        [dataArray addObject:smallDict];
//                    }
//                    [BTCMInstance pushViewControllerWithName:key andParams:@{@"dataArray":dataArray}];
//                    return;
//                }
//
//                if (ISStringEqualToString(obj, @"BTNewAddRecordViewController")) {//币记账
//                    NSDictionary *dict = [UserDefaults objectForKey:BTClassParameters];
//                    if (dict.count > 2) {
//
//                        BTRecordModel *model = [BTRecordModel modelWithJSON:[UserDefaults objectForKey:BTClassParameters]];
//                        [BTCMInstance pushViewControllerWithName:key andParams:@{@"model":model}];
//                    }else {
//                        [BTCMInstance pushViewControllerWithName:key andParams:dict];
//                    }
//                    return;
//                }
//                [BTCMInstance pushViewControllerWithName:key andParams:[UserDefaults objectForKey:BTClassParameters]];
//            }
//
//        }];
//    }else {
//
//        [getMainTabBar setSelectedIndex:[UserDefaults integerForKey:BTGetMainTabBarSelectedIndex]];
//    }
}
- (void)PreviewImageSCreatPhotoBrowserVCWithImages:(NSArray *)images andIndexPath:(NSInteger)index {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < images.count; i++) {
        
        NSString *imageUrl = images[i];
        imageUrl = [NSString stringWithFormat:@"%@",([imageUrl hasPrefix:@"http"]||[imageUrl hasPrefix:@"https"])?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl]];
        //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        [arr addObject:imageUrl];
    }
    
    CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
    // 传入图片数组
    pictureVC.picArray = arr;
    // 标记点击的是哪一张图片
    pictureVC.touchIndex = index;
    //pictureVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
    CLPresent *present = [CLPresent sharedCLPresent];
    pictureVC.modalPresentationStyle = UIModalPresentationCustom;
    pictureVC.transitioningDelegate = present;
    [getMainTabBar presentViewController:pictureVC animated:YES completion:nil];
}
//获取当前时间戳有两种方法(以秒为单位)
- (NSString *)getNowTimeTimestamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}
- (UIViewController *)getTopViewController
{
    //如果有alertview的时候keywindow就取不对了
    UIViewController *topViewController =  [[UIApplication sharedApplication].windows[0] topViewController];
    if ([topViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *t = (UITabBarController *)topViewController;
        topViewController = [t selectedViewController];
    }
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        topViewController = [[(UINavigationController *)topViewController viewControllers] lastObject];
    }
    return topViewController;
}
-(NSString *)NewTimePresentationStringWithTimeStamp:(NSString *)timeStamp {
    
    //return [WBStatusHelper stringWithTimeInterval:timeStamp];

    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970];
    //将传入的参数转化为时间戳
    double dateStamp = [timeStamp doubleValue]/1000.0;
    //计算时间间隔，即当前时间减去传入的时间
    double interval = currentDateStamp - dateStamp;
    //获取当前时间的小时单位（24小时制）
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H"];
    int nowHour = [[formatter stringFromDate:currentDate] intValue];
    //获取当前时间的分钟单位
    NSDateFormatter *minFormatter = [NSDateFormatter new];
    [minFormatter setDateFormat:@"m"];
    int nowMinute = [[minFormatter stringFromDate:currentDate] intValue];
    //今天0点的时间戳
    double todayZeroClock = currentDateStamp - anHour * nowHour - aMinute * nowMinute;
    //时间格式化，为输出做准备

    NSDateFormatter *YesterdayFormat = [NSDateFormatter new];
    [YesterdayFormat setDateFormat:@"HH:mm"];

    NSDateFormatter *outYesterdayFormat = [NSDateFormatter new];
    [outYesterdayFormat setDateFormat:@"MM-dd HH:mm"];

    NSDateFormatter *outThisYearFormat = [NSDateFormatter new];
    [outThisYearFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
    //进行条件判断，满足不同的条件返回不同的结果
    if (interval < aMinute) {
        //一分钟内
        return [APPLanguageService wyhSearchContentWith:@"ganggang"];
    } else if (todayZeroClock - dateStamp > 24 * anHour && todayZeroClock - dateStamp < 365 * 24 * anHour) {
        // 间隔超过48小时，显示：xx月xx日 xx：xx（本年的不需要展示年份）
        return [outYesterdayFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
    } else if (todayZeroClock - dateStamp > 365 * 24 * anHour) {
        //间隔超过一年，显示：xxxx年xx月xx日 xx：xx
        return [outThisYearFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]];
    } else if (todayZeroClock - dateStamp > 0 && todayZeroClock - dateStamp < 24 * anHour) {
        //间隔超过24小时，不超过48小时，显示：昨天xx：xx
        return [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"zuotian"],[YesterdayFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateStamp]]];
    } else if (interval < anHour) {
        //一小时内，显示：xx分钟前
        return [NSString stringWithFormat:@"%.0f%@", (currentDateStamp - dateStamp) / aMinute,[APPLanguageService wyhSearchContentWith:@"fengzhongqian"]];
    } else {
        //小于24小时，显示：xx小时前
        return [NSString stringWithFormat:@"%.0f%@", (currentDateStamp - dateStamp) / anHour,[APPLanguageService wyhSearchContentWith:@"xiaoshiqian"]];
    }
}
//将时间戳转换成NSDate,加上时区偏移
-(NSDate*)zoneChange:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    return localeDate;
}
-(void)ExceptionalAuthorsWithID:(NSInteger)detailID andType:(NSInteger)type {
    
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
   //奖励类型1资讯2帖子3探报4讨论
    [BTExceptionalView showWithRecordModel:@[@"1",@"10",@"100",@"200"] completion:^(NSString * _Nonnull exceptional) {
        BTExceptionalTPRequest *api = [[BTExceptionalTPRequest
                                        alloc] initWithPostId:detailID type:type num:exceptional.integerValue];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            NSLog(@"%@",request.data);
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"dashangchenggong"] wait:YES];
            
        } failure:^(__kindof BTBaseRequest *request) {
        
            if (request.code == 1011) {//超过5次
                [BTExceptionalCeilingView showExceptionalCeilingView];
            }
            if (request.code == 2000) {//探力不足
                [BTLackOfExceptionalView showLackOfExceptionalView];
            }
        }];
        //[BTLackOfExceptionalView showLackOfExceptionalView];
    }];
}
-(void)ReadSingleMessageWithMessageId:(NSInteger)messageId andType:(NSInteger)type andUnread:(BOOL)unread completion:(ReadSingleMessageCompletionBlock)block{
    self.block = block;
    if (unread) {
        BTReadSingleMessageRequest *api = [[BTReadSingleMessageRequest alloc] initWithType:type messageId:messageId];
        
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            NSLog(@"%@",request.data);
            if (self.block) {
                self.block();
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }
}
-(void)imageViewPhotoAddVChuLiWithImageUrl:(NSString *)urlStr andImageView:(UIImageView *)imageView andAuthStatus:(NSInteger)authStatus andAuthType:(NSInteger)authType addSuperView:(UIView *)view{
    //authStatus 认证状态 1 待审核2已通过3未通过4已取消
    //authType 认证类型 1机构认证2社区达人3专栏作者
    [imageView sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(urlStr) hasPrefix:@"http"]?urlStr:[NSString stringWithFormat:@"%@%@",PhotoImageURL,urlStr]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    if (authStatus == 2) {
        NSString *imageName_V = @"";
        CGFloat heightAndWidth = 0.0;
        if (authType != 0) {
            //imageName_V = [NSString stringWithFormat:@"%ld_%@",authType,imageView.size.width < 20 ? @"小" : (imageView.size.width > 40 ? @"大" : @"中")];
            if (imageView.size.width < 20) {
                imageName_V = [NSString stringWithFormat:@"%ld_%@",(long)authType,@"小"];
                heightAndWidth = 8.0;
            }else if (imageView.size.width > 40) {
                
                imageName_V = [NSString stringWithFormat:@"%ld_%@",(long)authType,@"大"];
                heightAndWidth = 20.0;
            }else {
                
                imageName_V = [NSString stringWithFormat:@"%ld_%@",(long)authType,@"中"];
                heightAndWidth = 14.0;
            }
        }
        UIImageView *iv = (UIImageView*)[view viewWithTag:87541599];
        if (!iv) {
            iv = [[UIImageView alloc] init];
            iv.image = IMAGE_NAMED(imageName_V);
            iv.tag = 87541599;
            iv.frame = CGRectMake(VIEW_BX(imageView)-heightAndWidth, VIEW_BY(imageView)-heightAndWidth, heightAndWidth, heightAndWidth);
            [view addSubview:iv];
        }else {
            
            iv.image = IMAGE_NAMED(imageName_V);
        }
    }else {
        
        UIImageView *iv = (UIImageView*)[view viewWithTag:87541599];
        if (iv) {
            [iv removeFromSuperview];
            iv = nil;
        }
    }
}
-(UIImage *)getNewImageFromImage:(UIImage *)im andCGSizeMake:(CGSize)size{
    CGFloat scale = [[UIScreen mainScreen] scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [im drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();
    return newImage;
}
-(CGFloat)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect rect = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return rect.size.width;
}
@end
