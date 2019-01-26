//
//  BTHelpCenterModel.h
//  BT
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTHelpCenterModel : BTBaseObject
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *answerEn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleEn;

@end
