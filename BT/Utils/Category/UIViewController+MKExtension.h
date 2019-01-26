//
//  UIViewController+MKExtension.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MKExtension)

/**
 @brief 从类名的StoryBoard创建
 @discussion 
    使用这个的原因的：
        1、集中使用StoryBoard不利于协作，当项目过大时效率也低了；
        2、有些功能在xib中没有，只有在StoryBoard中才有，如UICollectionViewCell的Identifier
 */

+ (id)create;
+ (id)createSbWith:(NSString *)name andId:(NSString *)vcID;


@end
