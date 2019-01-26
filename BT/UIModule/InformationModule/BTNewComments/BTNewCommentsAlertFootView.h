//
//  BTNewCommentsAlertFootView.h
//  BT
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "DiscussModel.h"
@interface BTNewCommentsAlertFootView : BTView
typedef void(^LikeBlock)(DiscussModel *model);
@property (nonatomic, copy) LikeBlock likeBlock;
@property (nonatomic, copy) DiscussModel *model;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *shareImageURL;
@property (nonatomic,strong)NSString *shareTitle;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIV;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet BTButton *PLBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewWeight;
@property (weak, nonatomic) IBOutlet UIImageView *shareIV;
@property (nonatomic,assign) BOOL isHaveShare;

@end
