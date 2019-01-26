//
//  BTAppWatchCell.h
//  BTAppWatch Extension
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTAppWatchModel.h"
#import "NSNumber+AppWatchUtils.h"
@interface BTAppWatchCell : NSObject
/** 设置cell的内容 */
- (void)setCellContent:(BTAppWatchModel *)content;
@end
