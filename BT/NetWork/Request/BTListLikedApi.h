//
//  BTListLikedApi.h
//  BT
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTListLikedApi : BTBaseRequest
- (id)initWithUserId:(NSInteger)userId CurrentPage:(NSInteger)currentPage;
@end
