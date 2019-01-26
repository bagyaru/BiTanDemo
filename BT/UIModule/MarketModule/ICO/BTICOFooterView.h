//
//  BTICOFooterView.h
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTICOFooterView : BTView

@property (weak, nonatomic) IBOutlet UIView *photoHeaderView;
@property (weak, nonatomic) IBOutlet UIView *linkHeaderView;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *linkScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkTopCons;


- (void)setPhoto:(NSArray*)photoInfo;
- (void)setLink:(NSArray*)links;


@end
