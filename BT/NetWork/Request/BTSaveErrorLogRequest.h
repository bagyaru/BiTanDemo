//
//  BTSaveErrorLogRequest.h
//  BT
//
//  Created by admin on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTSaveErrorLogRequest : BTBaseRequest
- (id)initWithApiUrl:(NSString *)apiUrl errorMsg:(NSString *)errorMsg;
@end
