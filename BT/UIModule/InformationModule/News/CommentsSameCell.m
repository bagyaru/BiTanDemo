//
//  CommentsSameCell.m
//  BT
//
//  Created by admin on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentsSameCell.h"
#import "SecondaryCommentsView.h"
#import "MoreCommentsView.h"
//#import "NSAttributedString+YYText.h"
@interface CommentsSameCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelLike;

@property (weak, nonatomic) IBOutlet BTCopyLabel *labelContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;
@property (weak, nonatomic) IBOutlet UIImageView *LikeBigIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connentsViewHeight;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianjuConstraint;
@end
@implementation CommentsSameCell{
    DiscussModel *_model;
    ZanAndReplayListModel *_model1;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.imageViewIcon, 20);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelContent.preferredMaxLayoutWidth = ScreenWidth - 68 - 15;
    [AppHelper addLineWithParentView:self.contentView];
    self.labelName.textColor = CFontColor8;
    self.labelTime.textColor = CFontColor11;
    self.labelContent.textColor = CFontColor8;
    self.labelLike.textColor = CFontColor8;
    self.LikeBigIV.userInteractionEnabled = YES;

    //    self.imageViewIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"headphoto%u.png",(arc4random() % 7 + 1)]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.likeBlock) {
            self.likeBlock(_model);
        }
    }];
    [self.LikeBigIV addGestureRecognizer:tap];
}
+ (instancetype)shareInstance{
    static CommentsSameCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([CommentsSameCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model{
    CommentsSameCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

-(void)setIsShowLike:(BOOL)isShowLike {
    
    _isShowLike = isShowLike;
    
    if (!isShowLike) {
        
        self.imageViewLike.hidden = YES;
        self.labelLike.hidden = YES;
        self.contentView.backgroundColor = CFontColor7;
    }
}
- (void)configWithDiscussModel:(DiscussModel *)model{
    if (model) {
        _model = model;
        self.labelName.text = model.userName;
        model.userAvatar = SAFESTRING(model.userAvatar);
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelLike.text = [NSString stringWithFormat:@"%ld",(long)model.likeCount];
        model.likeCount > 0 ? (self.labelLike.textColor = MainBg_Color) : (self.labelLike.textColor = CFontColor8);
        if (!model.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"xin-nor"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"xin-sel"];
        }
        self.labelContent.text = model.content;
        [getUserCenter setLabelSpace:self.labelContent withValue:model.content withFont:SYSTEMFONT(14) withHJJ:5.0 withZJJ:0.0];
        
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[model.createTime timeIntervalSince1970]*1000]];
        
        self.connentsViewHeight.constant = 0;
        self.commentsView.hidden = YES;
        if (model.commentsArray.count > 0) {

            self.commentsView.hidden = NO;
            self.jianjuConstraint.constant = 10;
            if (!model.isOrNo) {
                
                for (UIView *subView in self.commentsView.subviews) {
                    
                    [subView removeFromSuperview];
                }
                
                self.connentsViewHeight.constant = 0;
                
                CGFloat ZONGHeight = 0.0;
                
                for (int i = 0; i < (model.commentsArray.count > 3 ? 3 : model.commentsArray.count); i++) {
                    
                    DiscussModel *M = model.commentsArray[i];
                    
                    CGFloat height = [getUserCenter getSpaceLabelHeight:M.content withFont:SYSTEMFONT(12) withWidth:ScreenWidth-110 withHJJ:4.0 withZJJ:0.0];
                    if (model.commentsArray.count <= 3 && i == model.commentsArray.count-1) {
                        
                        height = height+15;
                    }
                    UIView *back = [[UIView alloc] init];
                    back.frame = CGRectMake(0, ZONGHeight, self.commentsView.frame.size.width, 37+height);
                    SecondaryCommentsView *V = [SecondaryCommentsView loadFromXib];
                    V.nameL.text = M.userName;
                    V.contentL.text = M.content;
                    [getUserCenter setLabelSpace:V.contentL withValue:M.content withFont:SYSTEMFONT(12) withHJJ:4.0 withZJJ:0.0];
                    V.frame = CGRectMake(0, 0, self.commentsView.frame.size.width, 37+height);
                    [back addSubview:V];
                    [self.commentsView addSubview:back];
                    ZONGHeight = ZONGHeight + height + 37;
                    
                }
                if (model.commentsArray.count > 3) {
                    
                    UIView *back1 = [[UIView alloc] init];
                    back1.frame = CGRectMake(0, ZONGHeight, self.commentsView.frame.size.width, 60);
                    MoreCommentsView *V1 = [MoreCommentsView loadFromXib];
                    V1.frame = CGRectMake(0, 0, self.commentsView.frame.size.width, 60);
                    V1.L.text = [NSString stringWithFormat:@"%@%ld%@",[APPLanguageService wyhSearchContentWith:@"chakanall"],(unsigned long)model.commentsArray.count,[APPLanguageService wyhSearchContentWith:@"tiaohuifu"]];
                    [V1.B addTarget:self action:@selector(goCommentsDetailClick) forControlEvents:UIControlEventTouchUpInside];
                    [back1 addSubview:V1];
                    [self.commentsView addSubview:back1];
                    self.connentsViewHeight.constant = ZONGHeight+60;
                }else {
                    self.connentsViewHeight.constant = ZONGHeight;
                }
                
//                if (self.delegate && [self.delegate respondsToSelector:@selector(CommentsSameCellWith:withCellHeight:)]) {
//
//                    [self.delegate CommentsSameCellWith:self.indexPath withCellHeight:self.connentsViewHeight.constant];
//                }
            }else {
                
                self.connentsViewHeight.constant = model.cellHeight;
            }
            
        }else {

            self.commentsView.hidden = YES;
            self.jianjuConstraint.constant = 0;
            self.connentsViewHeight.constant = 0;
        }
        //点击 评论/回复label的回调
        self.labelContent.child_ID = model.commentId;
        self.labelContent.userName = model.userName;
        WS(ws);
        self.labelContent.copyBlock = ^(NSString *commentID, NSString *userName) {
            
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(CommentsSameCellCopyLableWith:userName:)]) {
                [ws.delegate CommentsSameCellCopyLableWith:commentID userName:userName];
            }
        };
    }
}
-(void)goCommentsDetailClick {
    
    NSLog(@"%@",_model.userName);
    [BTCMInstance pushViewControllerWithName:@"CommentsDetailVC" andParams:@{@"commentId":_model.commentId}];
}
+ (CGFloat)cellHeightWithZanAndReplayListModel:(ZanAndReplayListModel *)model {
    
    CommentsSameCell *cell = [self shareInstance];
    [cell configWithZanAndReplayListModel:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}
-(void)configWithZanAndReplayListModel:(ZanAndReplayListModel *)model {
    
    if (model) {
        _model1 = model;
        model.userAvatar = SAFESTRING(model.userAvatar);
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelLike.hidden = YES;
        self.imageViewLike.hidden = YES;
        self.labelContent.text = model.content;
        self.labelTime.text = model.timeFormat;
        if (model.isOrNo) {
            
             self.labelName.text = [NSString stringWithFormat:@"%@%@",model.userName,[APPLanguageService wyhSearchContentWith:@"zanlnidepinglun"]];
        }else {
            
            self.labelName.text = [NSString stringWithFormat:@"%@%@",model.userName,[APPLanguageService wyhSearchContentWith:@"pinglunlni"]];
        }
        self.connentsViewHeight.constant = 0;
        self.jianjuConstraint.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
