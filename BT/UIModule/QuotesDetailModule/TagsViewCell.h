//
//  TagsViewCell.h
//  TagsDemo
//
//  Created by Administrator on 16/1/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsFrame.h"

@protocol TagsViewCellDelegate<NSObject>

- (void)TagsViewCellClickIndex:(NSInteger)index;

@end

@interface TagsViewCell : UITableViewCell

+ (id)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TagsFrame *tagsFrame;

@property (nonatomic, weak) id<TagsViewCellDelegate>delegate;
@end
