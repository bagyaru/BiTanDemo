//
//  BTPostMainListRequest.h
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTPostMainListRequest : BTBaseRequest
@property (nonatomic,assign)NSInteger type;//列表类型（传1 返回全部列表，不传表示是否原创）
@property (nonatomic,assign)BOOL original;//是否原创，true=是false=不是 不传=全部
-(id)initWithIndex:(NSInteger)index ;
@end
