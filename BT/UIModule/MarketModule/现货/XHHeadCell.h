//
//  XHHeadCell.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet BTLabel *contentL;
@property (weak, nonatomic) IBOutlet BTButton *detailBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *tag1L;

@property (weak, nonatomic) IBOutlet UILabel *tag2L;
@property (weak, nonatomic) IBOutlet UILabel *tag3L;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag3W;

-(void)creatUIWithDict:(NSMutableDictionary *)dict;

@end
