//
//  HYShareActivityView.h


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYSharePlatformType){
    
    /**
     *  微信好友
     */
    HYSharePlatformTypeWechatSession            = 0,
    /**
     *  微信朋友圈
     */
    HYSharePlatformTypeWechatTimeline           = 1,
    
    /**
     *  新浪微博
     */
    HYSharePlatformTypeSinaWeibo                = 2,
    /**
     *  QQ空间
     */
    HYSharePlatformTypeQZone                    = 3,
    /**
     *  拷贝
     */
    HYSharePlatformTypeCopy                     = 4,
    
    /**
     *  QQ好友
     */
    HYSharePlatformTypeQQFriend                 = 5,
    /**
     *  回到首页
     */
    HYSharePlatformTypeToMain                   = 6,
    /**
     *  联系客服
     */
    HYSharePlatformTypeCallService              = 7,
    
    /**
     *  发送短信
     */
    HYSharePlatformTypeSMS                  = 8,
};




typedef void(^HYShayeTypeBlocks)(HYSharePlatformType type);

/**************分享的button****************/
@interface HYShareButtonView : UIView

@property(nonatomic,copy) NSString *shareTitle;
@property(nonatomic,copy) NSString *shareImage;
@property(nonatomic,copy) UIButton *shareBtn;
@property (nonatomic, assign) BOOL isShowTitle;

@property(nonatomic,assign) id delegate;
@end

@protocol HYShareButtonViewDelegate <NSObject>

@optional
-(void)onIconBtnPress:(HYShareButtonView *)button;


@end


/***************分享界面****************/

@interface HYShareActivityView : BTView

/**
 *  普通分享
 *
 *  @param buttons   分享button
 *  @param shareType 回调
 *
 *  @return HYShareActivityView
 */
- (instancetype)initWithButtons:(NSArray *)buttons
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;
/**
 *  快讯分享
 *
 *  @param buttons   分享button
 *  @param shareType 回调
 *  @param title     分享类型
 *  @param iv        快讯图片
 *  @return HYShareActivityView
 */
- (instancetype)initWithButtons:(NSArray *)buttons
                          title:(NSString *)title
                          image:(UIImageView *)iv
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;


//截屏分享
- (instancetype)initWithButtons:(NSArray *)buttons
                          image:(UIImageView *)iv
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;

/**
 *  帖子分享
 *
 *  @param buttons   分享button
 *  @param shareType 回调
 *  @param title     分享类型
 *  @return HYShareActivityView
 */
- (instancetype)initWithButtons:(NSArray *)buttons
                          title:(NSString *)title
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;


-(void)show;

-(void)hide;

@property(nonatomic,assign) id delegate;

@end
@protocol HYShareActivityViewDelegate <NSObject>

-(void)closeView;

@end

/*******商品分享中间界面*************/

@interface HYShareContentView : UIView

@property (nonatomic,copy) NSString *sharePay;

@end
