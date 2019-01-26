//
//  BTSheQuFocusListRequest.h
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTSheQuFocusListRequest : BTBaseRequest
//@property (nonatomic,assign)NSInteger pageSize;
-(id)initWithCurrentPage:(NSInteger)currentPage;
@end

NS_ASSUME_NONNULL_END
