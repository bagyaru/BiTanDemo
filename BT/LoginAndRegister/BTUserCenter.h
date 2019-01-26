//
//  BTUserCenter.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTUserInfo.h"
#import "MyInfoObJ.h"
#import "ChargeAccountRemindView.h"
#import "BTMyCoinRewardRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIWindow+MKExtension.h"

#import "BTExceptionalView.h"
#import "BTLackOfExceptionalView.h"
#import "BTExceptionalCeilingView.h"

#import "BTReadSingleMessageRequest.h"
#import "BTPriceWarningAlertView.h"
typedef void (^ReadSingleMessageCompletionBlock)(void);
typedef void(^sharePostContentBlock)(NSString *content);//查看详情
@interface BTUserCenter : NSObject
@property (nonatomic, strong) BTUserInfo              *userInfo;
@property (nonatomic, strong) MyInfoObJ               *detailMyInfo;
@property (nonatomic, strong) UIView                  *backView;
@property (nonatomic, strong) ChargeAccountRemindView *RemindView;
@property (nonatomic, strong) BTPriceWarningAlertView *PriceWarningView;
@property (nonatomic, strong) NSDictionary            *dict;
@property (nonatomic, assign) NSInteger PriceWarningViewNumber;

@property (nonatomic, copy) ReadSingleMessageCompletionBlock block;
@property (nonatomic, copy) sharePostContentBlock shareBlock;

/**
 *  拉起登陆界面
 */
-(void)loginoutPullView;
/**
 *  退出登录，并且清空本地信息并回到首页
 */
- (void)loginout;

/**
 *  退出登录，并且清空本地信息回到首页
 */
-(void)loginoutGotoMain;
/**
 *  判断是否登录
 *
 *  @return YES登录，NO未登录
 */
- (BOOL)isLogined;

/**
 *  刷新用户信息，如头像昵称等
 */
- (void)reloadUserInfo;

/**
 *  极光绑定别名
 */
-(void)JPUSHLogin;
/**
 *  极光删除别名
 */
-(void)JPUSHDeleteBM;
/**
 *  检测版本
 */
-(void)loadVesionCheck;
/**
 *  MD5加密
 */
- (NSString *)md5:(NSString *)input;
//行间距
-(void)getLabelHight:(UILabel *)label Float:(CGFloat)floatN AddImage:(BOOL)isAdd;
//UILabel自定义行间距时获取高度 (问答）
-(float)customGetContactHeight:(NSString*)contact FontOfSize:(CGFloat)font LabelMaxWidth:(CGFloat)width jianju:(CGFloat)jianju;
//UILabel自定义行间距时获取高度(1个label)
-(float)customGetContactHeight:(NSString*)contact FontOfSize:(CGFloat)font LabelMaxWidth:(CGFloat)width;
//(无误差)UILabel自定义行间距切（自定义字体）时获取高度(1个label)
-(float)RightCustomGetContactHeight:(NSString*)contact FontOfSize:(UIFont *)font LabelMaxWidth:(CGFloat)width jianju:(CGFloat)jianju;
//时间戳转时间(到分钟)
- (NSString *)minutestimeWithTimeIntervalString:(NSString *)timeString;
//获得当前的时间字符串
- (NSString *)nowTimeWithDate:(NSDate *)date;
//时间戳转时间
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//获取当前时间戳有两种方法(以秒为单位)
- (NSString *)getNowTimeTimestamp;

//json字符串转字典
-(NSArray *)jsonStringChangeArray:(NSString *)jsonStr;
//json字符串转数组
-(NSDictionary *)jsonStringChangeDict:(NSString *)jsonStr;
//字典转json字符串
-(NSString *)dictionaryToJSONString:(NSDictionary *)dictionary;
//数组转json字符串
-(NSString *)arrayToJSONString:(NSMutableArray *)array;
//gzip解压
-(NSData *)uncompressZippedData:(NSData *)compressedData;
-(NSString *)getImageURLSizeWithWeight:(NSInteger)weight andHeight:(NSInteger)height;
//错误日志传给后台
-(void)saveErrorLogToServiceWith:(NSString *)apiUrl errorMsg:(NSString *)errorMsg;
//推送提醒View
-(void)creatRemindViewWithString:(NSString *)title;
//价格预警
-(void)creatRemindViewWithString:(NSString *)title dict:(NSDictionary *)dict;
//分享成功获取探力
-(void)shareSuccseGetTanLiWithType:(NSInteger)type withTime:(CGFloat)time;
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font withHJJ:(CGFloat)HJJ withZJJ:(CGFloat)ZJJ;
//计算UILabel的高度(自定义行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withHJJ:(CGFloat)HJJ withZJJ:(CGFloat)ZJJ;
//去除带#中的多余字符串
- (NSString *)DetermineWhetherTheFuturesOrCurrencyOnThePost:(NSString *)str;
//分享埋点
-(void)shareBuriedPointWithType:(NSInteger)type withWhereVc:(NSInteger)whereVC;
//币圈操作数据统计
-(void)biQuanXiangGuanCaoZuo:(NSInteger)articleId articleInfoType:(NSInteger)articleInfoType;

////修改字符串某一位置的颜色
-(void)changeUILabelColor:(UILabel *)label and:(NSString *)str and:(NSString *)str1 color:(UIColor *)color;
//修改 回复 被回复人的昵称颜色
-(void)replyChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font;

//修改 回复 被回复人的昵称颜色
-(void)postNikeNameChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font;
//原贴 回复 被回复人的昵称颜色
-(void)sourcePostNikeNameChangeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color font:(CGFloat)font;
//分享出去对#帖子#的处理
-(void)sharePostContentWithTitle:(NSString *)title completion:(sharePostContentBlock)shareBlock;;

//首页 滚动新闻
-(void)changeUILabelRangeColor:(UILabel *)label and:(NSString *)str color:(UIColor *)color;
//获取时间差值
- (NSInteger)timeDifferenceWithType:(NSString *)type;
//删除时间差值
- (void)removeTimeDifferenceWithType:(NSString *)type;
//出来手机号带***
-(NSString *)getPhone:(NSString *)phone;
//进入上一次退出时的页面
-(void)enterTheHistoryVC;
//预览图片
-(void)PreviewImageSCreatPhotoBrowserVCWithImages:(NSArray *)images andIndexPath:(NSInteger)index;
- (UIViewController *)getTopViewController;
/**
 *  新的时间显示规则
 */
-(NSString *)NewTimePresentationStringWithTimeStamp:(NSString *)timeStamp;
//社区-要闻、探报、攻略、帖子、讨论详情内，文章结尾处均添加打赏作者功能
-(void)ExceptionalAuthorsWithID:(NSInteger)detailID andType:(NSInteger)type;
//1=通知2=评论3=点赞4=@我 单条读取消息
-(void)ReadSingleMessageWithMessageId:(NSInteger)messageId andType:(NSInteger)type andUnread:(BOOL)unread completion:(ReadSingleMessageCompletionBlock)block;
//头像加V处理
-(void)imageViewPhotoAddVChuLiWithImageUrl:(NSString *)urlStr andImageView:(UIImageView *)imageView andAuthStatus:(NSInteger)authStatus andAuthType:(NSInteger)authType addSuperView:(UIView *)view;
//计算宽度
-(CGFloat)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text;
@end
