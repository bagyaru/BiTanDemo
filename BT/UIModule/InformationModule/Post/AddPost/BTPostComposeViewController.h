//
//  BTPostComposeViewController.h
//  BT
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBStatusComposeViewType) {
    WBStatusComposeViewTypeStatus,  ///< 发微博
    WBStatusComposeViewTypeRetweet, ///< 转发微博
    WBStatusComposeViewTypeComment, ///< 发评论
};

/// 发布微博
@interface BTPostComposeViewController : UIViewController
@property (nonatomic, assign) WBStatusComposeViewType type;
@property (nonatomic, copy) void (^dismiss)(void);

@end
