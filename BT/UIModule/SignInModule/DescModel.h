//
//  DescModel.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DescModel : NSObject

/**图片*/
@property (nonatomic,copy) NSString *imgStr;
/**主标题*/
@property (nonatomic,copy) NSString *mainTitle;
/**详细说明*/
@property (nonatomic,copy) NSString *descTitle;

@end
