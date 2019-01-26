//
//  DiscussCell.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscussCell.h"
#import "LikeRequest.h"

@interface DiscussCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelLike;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;


@end

@implementation DiscussCell{
    DiscussModel *_model;
    ZanAndReplayListModel *_model1;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.imageViewIcon, 17.5);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelContent.preferredMaxLayoutWidth = ScreenWidth - 68 - 15;
    [AppHelper addLineWithParentView:self.contentView];
    self.labelName.textColor = CBlackColor;
    self.labelTime.textColor = CGrayColor;
    self.labelContent.textColor = CBlackColor;
    self.labelLike.textColor = CGrayColor;
    
    self.imageViewLike.userInteractionEnabled = YES;
//    self.imageViewIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"headphoto%u.png",(arc4random() % 7 + 1)]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.likeBlock) {
            self.likeBlock(_model);
        }
    }];
    [self.imageViewLike addGestureRecognizer:tap];
}

+ (instancetype)shareInstance{
    static DiscussCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([DiscussCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model{
    DiscussCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}
+ (CGFloat)cellHeightWithZanAndReplayListModel:(ZanAndReplayListModel *)model {
    
    DiscussCell *cell = [self shareInstance];
    [cell configWithZanAndReplayListModel:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}
-(void)configWithZanAndReplayListModel:(ZanAndReplayListModel *)model {
    
    if (model) {
        _model1 = model;
        self.labelName.text = model.userName;
        model.userAvatar = SAFESTRING(model.userAvatar);
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelLike.hidden = YES;
        self.imageViewLike.hidden = YES;
        self.labelContent.text = model.content;
        self.labelTime.text = model.timeFormat;
       
    }
}
- (void)configWithDiscussModel:(DiscussModel *)model{
    if (model) {
        _model = model;
        self.labelName.text = model.userName;
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelLike.text = [NSString stringWithFormat:@"%ld",model.likeCount];
        if (!model.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"like.png"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"likeselect.png"];
        }
        self.labelContent.text = model.content;
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[model.createTime timeIntervalSince1970]*1000]];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
