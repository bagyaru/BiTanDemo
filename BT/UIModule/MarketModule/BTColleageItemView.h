//
//  BTColleageItemView.h
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTColleageItemView : BTView

@property (nonatomic, assign) NSInteger index;

- (void)setTypes:(NSDictionary*)types;

@end

NS_ASSUME_NONNULL_END
