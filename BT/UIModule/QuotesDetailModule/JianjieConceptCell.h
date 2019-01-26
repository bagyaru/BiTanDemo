//
//  JianjieConceptCell.h
//  BT
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTJianjieModel.h"

@protocol JianjieConceptCellDelegate<NSObject>

- (void)tapConcept:(NSInteger)index;

@end

@interface JianjieConceptCell : UITableViewCell

@property (nonatomic, strong) BTJianjieModel *model;
@property (nonatomic, strong) NSArray *info;

@property (nonatomic, weak) id<JianjieConceptCellDelegate>delegate;

@end
