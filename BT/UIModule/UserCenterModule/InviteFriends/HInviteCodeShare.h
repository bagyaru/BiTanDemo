//
//  HInviteCodeShare.h
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HInviteCodeShare : NSObject

SINGLETON_FOR_HEADER(HInviteCodeShare);

- (void)shareWithContent:(NSString*)content reward:(NSInteger)reward;

@end
