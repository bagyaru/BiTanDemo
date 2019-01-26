//
//  TCommentDetailCell.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDetailObj.h"
@interface TCommentDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet BTLabel *nameL;
@property (weak, nonatomic) IBOutlet BTLabel *timeL;
@property (weak, nonatomic) IBOutlet BTLabel *contentL;
-(void)creatUIWith:(CommentDetailObj *)obj;

@end
