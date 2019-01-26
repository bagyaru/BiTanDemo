//
//  BTNewDianZanAndReplayDetailHeadView.h
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "DiscussModel.h"

typedef void(^LikeBlock)(DiscussModel *model);

@interface BTNewDianZanAndReplayDetailHeadView : BTView

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelLike;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSource;

@property (weak, nonatomic) IBOutlet UILabel *labelSource;

@property (nonatomic, copy) LikeBlock likeBlock;

@property (nonatomic,strong)DiscussModel *model;

@end
