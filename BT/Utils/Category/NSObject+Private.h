//
//  NSObject+Private.h
//  HaiYun
//
//  Created by YanLu on 16/3/30.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (HYPrivate)
- (id)HYPerformSelector:(NSString *)aSelectorName;
- (id)HYPerformSelector:(NSString *)aSelectorName withObject:(id)object;
- (id)HYPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2;
@end


@interface NSString (HYPrivate)

- (NSString *) sha1;
+ (NSString *) GetSand;
//转换成中间有星号的字符串
- (NSString*)setSecuretext:(NSString*)str;

+ (NSString *)HYstringWithBase64EncodedString:(NSString *)string;
- (NSString *)HYbase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)HYbase64EncodedString;
- (NSString *)HYbase64DecodedString;
- (NSData *)HYbase64DecodedData;

- (NSString *)initial;
@end

@interface UIView(HYblock) <UIAlertViewDelegate>


//UIAlertView
-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;
@end

@interface NSDictionary (HYPrivate)
- (NSString*)JSONString;
- (NSString *)HYValueForKey:(NSString *)key;
- (NSMutableArray *)HYNSArrayValueForKey:(NSString *)key;
- (NSMutableDictionary *)HYNSDictionaryValueForKey:(NSString *)key;
- (BOOL)isAction:(NSString *)nsAction;
- (int) GetErrorNO;
- (BOOL)isSuccess;
@end

@interface NSMutableDictionary(HYPrivate)
- (void)HYSetObject:(NSString *)anObject forKey:(id <NSCopying>)aKey;
@end

@interface NSArray (HYPrivate)
- (NSString *)HYObjectAtIndex:(NSUInteger)index;
- (NSMutableArray *)HYNSArrayObjectAtIndex:(NSUInteger)index;
- (NSMutableDictionary *)HYNSDictionaryObjectAtIndex:(NSUInteger)index;
@end

@interface UIImageView (HYPrivate)
-(void)SetlayerShap:(CGSize)size;//Imageview 设置圆形显示
@end

@interface NSData (HYPrivate)
+ (NSData *)HYdataWithBase64EncodedString:(NSString *)string;
- (NSString *)HYbase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)HYbase64EncodedString;
@end


@interface UILabel (HYPrivate)

- (void)HYPriceChangeFont:(CGFloat)font colors:(UIColor *)color isTop:(BOOL)flagTop;

@end

@interface UIImage (HYPrivate)

//UIImage尺寸处理
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
//resize
- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

/**
 * 将图片切成圆角图片
 *
 * @param size 返回图片的大小
 * @param r 圆角的大小
 *
 * @return 图片对象
 */
- (UIImage *)imageWithRoundedSize:(CGSize)size radius:(NSInteger)r;
- (UIImage *)rrImageWithCornerRadius:(CGFloat)radius;

/**
 *  播放GIF图片，放到imageView里面自动播放
 *
 *  @param theData  GIF图片的data
 *
 *  @return 返回一个GIF的图片
 */
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;
//取图片上某点的颜色值
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 * 把图片旋转到指定角度
 *
 * @param degrees 旋转的度数,如：300
 *
 * @return 选择后的图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  创建单色颜色值Image
 *
 *  @param color
 *  @param size
 *
 *  @return image
 */
+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size;

@end

