//
//  BTNewSameCommentsCell.m
//  BT
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewSameCommentsCell.h"
#import "ZJUnFoldView.h"
#import "ZJUnFoldView+Untils.h"

@interface BTNewSameCommentsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelLike;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;
@property (weak, nonatomic) IBOutlet UIImageView *LikeBigIV;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *replyL;
@property (weak, nonatomic) IBOutlet BTButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelDian;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic ,strong) ZJUnFoldView *unFoldView;
@property (nonatomic ,strong) DiscussModel *model;
@end
@implementation BTNewSameCommentsCell{
    ZanAndReplayListModel *_model1;
}
+ (instancetype)shareInstance{
    static BTNewSameCommentsCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([BTNewSameCommentsCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}
+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model {
    
    BTNewSameCommentsCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    return cell.heightCell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.imageViewIcon, 18);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelName.textColor = CFontColor8;
    self.labelTime.textColor = CFontColor11;
    self.labelLike.textColor = CFontColor8;
    self.LikeBigIV.userInteractionEnabled     = YES;
    self.labelName.userInteractionEnabled     = YES;
    self.topView.userInteractionEnabled       = YES;
    self.imageViewIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.likeBlock) {
            self.likeBlock(_model);
        }
    }];
    [self.LikeBigIV addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap_topView = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTNewSameCommentsCellCopyLableWithDiscussModel:)]) {
            
            [self.delegate BTNewSameCommentsCellCopyLableWithDiscussModel:self.model];
        }
        
    }];
    [self.topView addGestureRecognizer:tap_topView];
    
    [self.imageViewIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    if (ISNSStringValid(SAFESTRING(self.model.userName))) {
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(self.model.userName)}];
    }
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
        //[self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.userAvatar andImageView:self.imageViewIcon andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
        self.labelLike.text = [NSString stringWithFormat:@"%ld",(long)model.likeCount];
        model.likeCount > 0 ? (self.labelLike.textColor = MainBg_Color) : (self.labelLike.textColor = CFontColor8);
        if (!model.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"xin-nor"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"xin-sel"];
        }
        
         self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[model.createTime timeIntervalSince1970]*1000]];
        
        if (self.isCommentsNumber) {//评论详情 头部cell不用显示回复条数
            
            self.replyL.hidden    = YES;
            self.labelDian.hidden = YES;
        }else {
            self.replyL.hidden    = NO;
            self.labelDian.hidden = NO;
            if (model.replyCount > 0) {
                ViewRadius(self.replyL, 9);
                self.replyL.backgroundColor = ViewBGColor;
                self.replyL.text = [NSString stringWithFormat:@"  %@%@  ",@(model.replyCount),[APPLanguageService wyhSearchContentWith:@"huifu"]];
            }else {
                
                ViewRadius(self.replyL, 0);
                self.replyL.backgroundColor = KClearColor;
                self.replyL.text = [NSString stringWithFormat:@"%@",[APPLanguageService wyhSearchContentWith:@"huifu"]];
            }
        }
        //防止计算不准确 去掉空格
        model.content = [model.content stringByReplacingOccurrencesOfString:@"" withString:@""];
        model.content = [model.content stringByReplacingOccurrencesOfString:@"" withString:@""];
        model.refContent = [model.refContent stringByReplacingOccurrencesOfString:@"" withString:@""];
        model.refContent = [model.refContent stringByReplacingOccurrencesOfString:@"" withString:@""];
        if (ISNSStringValid(SAFESTRING(model.refContent)) && ISNSStringValid(SAFESTRING(model.refUserName))) {//回复 评论的回复
            
            [self creatContentViewWith:[NSString stringWithFormat:@"%@//@%@：%@",model.content,model.refUserName,model.refContent]];
        }else {//回复 评论
            
            [self creatContentViewWith:model.content];
        }
        
        if (model.userId == getUserCenter.userInfo.userId) {//只有自己才能删除自己的评论
            
            self.cancelBtn.hidden = NO;
        }else {
            
            self.cancelBtn.hidden = YES;
        }
    }
}
-(void)creatContentViewWith:(NSString *)content {
    CGFloat height = [getUserCenter getSpaceLabelHeight:content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-61-15 withHJJ:7.0 withZJJ:0.0];
   
    if (_model.IsOrNoLookDetail) {//点击了查看全文
        
        self.commentsViewHeight.constant = height;
        self.heightCell = 95+height;
        if (_model.isAddOneLine) {
            self.commentsViewHeight.constant = height+24;
            self.heightCell = 95+height+24;
        }
    }else {
        if (height > 150) {//未点击查看全文 但是超过6行的 只展示6行
            self.commentsViewHeight.constant = 150;
            self.heightCell = 95+150;
        }else {//原文小于等于6行
            self.commentsViewHeight.constant = height;
            self.heightCell = 95+height;
        }
    }
    // 1.获取属性字符串：自定义内容和属性
   ZJUnFoldAttributedString * unFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:content
                                                          contentFont:SYSTEMFONT(16)
                                                         contentColor:[ZJUnFoldView colorWithHexString:@"#333333"]
                                                         unFoldString:[APPLanguageService wyhSearchContentWith:@"quanwen"]
                                                           foldString:@" "
                                                           unFoldFont:SYSTEMFONT(16)
                                                          unFoldColor:MainBg_Color
                                                          lineSpacing:7.0];
    [self.commentsView removeAllSubviews];
    // 2.添加展开视图
    _unFoldView = [[ZJUnFoldView alloc] initWithAttributedString:unFoldAttrStr maxWidth:ScreenWidth-61-15 isDefaultUnFold:_model.IsOrNoLookDetail foldLines:6 location:2];
    _unFoldView.frame = CGRectMake(0, 0, ScreenWidth-61-15, self.commentsViewHeight.constant);
    
    _unFoldView.unFoldLabel.frame = CGRectMake(0, _unFoldView.unFoldLabel.frame.origin.y, _unFoldView.unFoldLabel.frame.size.width, self.commentsViewHeight.constant);
    NSLog(@"%f %.0f",_unFoldView.frame.size.height,self.commentsViewHeight.constant);
    [self.commentsView addSubview:_unFoldView];
//    _unFoldView.backgroundColor = KRedColor;
//    _unFoldView.unFoldLabel.backgroundColor = KGrayColor;
//    self.commentsView.backgroundColor = KBlackColor;
    WS(ws);
    _unFoldView.unFoldActionBlock = ^(BOOL isUnFold) {
        NSLog(@"哈哈哈哈哈");
        if (ws.lookAllBlock) {
            ws.lookAllBlock(ws.indexPath.row, isUnFold);
        }
    };
    
    //变色
    [getUserCenter postNikeNameChangeUILabelRangeColor:_unFoldView.unFoldLabel and:content color:MainBg_Color font:16.0f];
    
//    if (ISNSStringValid(SAFESTRING(_model.refContent)) && ISNSStringValid(SAFESTRING(_model.refUserName))) {//被回复的用户昵称标记颜色
//        [getUserCenter replyChangeUILabelRangeColor:_unFoldView.unFoldLabel and:[NSString stringWithFormat:@"@%@",_model.refUserName] color:MainBg_Color font:16.0f];
//    }
    
    //点击 评论/回复label的回调
    _unFoldView.unFoldLabel.child_ID = _model.commentId;
    _unFoldView.unFoldLabel.userName = _model.userName;
    _unFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
    
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(BTNewSameCommentsCellCopyLableWithDiscussModel:)]) {
            
            [ws.delegate BTNewSameCommentsCellCopyLableWithDiscussModel:ws.model];
        }
        
    };
}
//删除
- (IBAction)cancelBtnClcik:(BTButton *)sender {
    
    NSMutableArray *data =@[].mutableCopy;
    BTGroupListModel *deletModel = [[BTGroupListModel alloc] init];
    deletModel.groupName = [APPLanguageService wyhSearchContentWith:@"querenshanchu"];//@"全部";
    [data addObject:deletModel];
    [CommentsAlertView showWithArr:data type:1 completion:^(NSString *groupName) {
        
        if (self.deletBlock) {
            self.deletBlock(_model);
        }
    }];
}
- (IBAction)goCommentsDetailBtnClick:(UIButton *)sender {
    
    NSLog(@"去详情");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTNewSameCommentsCellCopyLableWithDiscussModel:)]) {
        
        [self.delegate BTNewSameCommentsCellCopyLableWithDiscussModel:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
