//
//  GradualChange.h
//  横向柱形图测试
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 huangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**   同时添加渐变  这时添加圆  圆角显示不完整  转为添加img  */
@interface GradualChange : NSObject
/**视图转为图片  横向和竖向的渐变不一样 */
+(UIImage*)viewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical;
/**首页 视图转为图片  横向和竖向的渐变不一样 */
+(UIImage*)HomeviewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical numb:(int)numb;

+(UIImage *)HomeviewChangeImg:(CGRect)rect isVerticalBar:(BOOL)isVertical;
@end
