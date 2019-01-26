//
//  BTMyPostCommentsCell.m
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostCommentsCell.h"
#import "ZJUnFoldView.h"
#import "ZJUnFoldView+Untils.h"
@interface BTMyPostCommentsCell ()
@property (nonatomic ,strong) ZJUnFoldView *unFoldView;
@property (nonatomic ,strong) DiscussModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceImageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceImageLeft;

@end
@implementation BTMyPostCommentsCell
+ (instancetype)shareInstance{
    static BTMyPostCommentsCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([BTMyPostCommentsCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}
+ (CGFloat)cellHeightWithDiscussModel:(DiscussModel *)model {
    
    BTMyPostCommentsCell *cell = [self shareInstance];
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
    self.labelName.userInteractionEnabled = YES;
    self.imageViewIcon.userInteractionEnabled = YES;
    [self.imageViewIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    // Initialization code
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(_model.userName)}];
}
- (void)configWithDiscussModel:(DiscussModel *)model{
    if (model) {
        _model = model;
        //防止计算不准确 去掉空格
        _model.content = [_model.content stringByReplacingOccurrencesOfString:@"" withString:@""];
         _model.content = [_model.content stringByReplacingOccurrencesOfString:@"" withString:@""];
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
    
        if ([model.sourceInfo isKindOfClass:[NSDictionary class]] && model.sourceInfo.count > 0) {
            self.labelSource.text  = [NSString stringWithFormat:@"@%@:%@",model.sourceInfo[@"userName"],[model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            
            //变色
            [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelSource and:[NSString stringWithFormat:@"@%@:%@",model.sourceInfo[@"userName"],[model.sourceInfo[@"title"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]] color:MainBg_Color font:14.0f];
            self.sourceImageW.constant = 40;
            self.sourceImageH.constant = 40;
            self.sourceImageLeft.constant = 5;
            [self.imageViewSource sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.sourceInfo[@"imgUrl"]) hasPrefix:@"http"]?SAFESTRING(model.sourceInfo[@"imgUrl"]):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(model.sourceInfo[@"imgUrl"])]] placeholderImage:[UIImage imageNamed:@"评论默认"]];
            
        }else {
            self.sourceImageW.constant = 16;
            self.sourceImageH.constant = 18;
            self.sourceImageLeft.constant = 15;
            self.imageViewSource.image = IMAGE_NAMED(@"我的帖子-删除");
            self.labelSource.text = [APPLanguageService wyhSearchContentWith:@"gaitieziyishanchu"];
            [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:self.labelSource and:self.labelSource.text color:ThirdColor font:14.0f];
        }
        self.labelSource.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[model.createTime timeIntervalSince1970]*1000]];
        
        [self creatContentViewWith:model.content];
        
    }
}
-(void)creatContentViewWith:(NSString *)content {
    CGFloat height = [getUserCenter getSpaceLabelHeight:content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-61-15 withHJJ:7.0 withZJJ:0.0];
    
    if (_model.IsOrNoLookDetail) {//点击了查看全文
        
        self.commentsViewHeight.constant = height;
        self.heightCell = 162+height;
        if (_model.isAddOneLine) {
            self.commentsViewHeight.constant = height+24;
            self.heightCell = 162+height+24;
        }
    }else {
        if (height > 150) {//未点击查看全文 但是超过6行的 只展示6行
            self.commentsViewHeight.constant = 144;
            self.heightCell = 162+144;
        }else {//原文刚好小于等于3行
            self.commentsViewHeight.constant = height;
            self.heightCell = 162+height;
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
    _unFoldView.frame = CGRectMake(0, 0, _unFoldView.frame.size.width, _unFoldView.frame.size.height);
    NSLog(@"%f",_unFoldView.frame.size.height);
    [self.commentsView addSubview:_unFoldView];
    
    //变色
    [getUserCenter postNikeNameChangeUILabelRangeColor:_unFoldView.unFoldLabel and:content color:MainBg_Color font:16.0f];
    
    WS(ws);
    _unFoldView.unFoldActionBlock = ^(BOOL isUnFold) {
        NSLog(@"哈哈哈哈哈");
        if (ws.lookAllBlock) {
            ws.lookAllBlock(ws.indexPath.row, isUnFold);
        }
    };
    
    //点击 评论/回复label的回调
    _unFoldView.unFoldLabel.child_ID = _model.commentId;
    _unFoldView.unFoldLabel.userName = _model.userName;
    _unFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
        
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(BTMyPostCommentsCellCopyLableWithDiscussModel:)]) {
            
            [ws.delegate BTMyPostCommentsCellCopyLableWithDiscussModel:ws.model];
        }
        
    };
}

- (IBAction)goToSourceDetailBtnClcik:(UIButton *)sender {
    
    if ([_model.sourceInfo[@"jumpType"] integerValue] == 5) {//币圈
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":_model.sourceInfo[@"refId"],@"bigType":@(6)}];
    }
}


- (IBAction)likeBtnClick:(UIButton *)sender {
    
    if (self.likeBlock) {
        self.likeBlock(_model);
    }
}
- (IBAction)deleteBtnClick:(BTButton *)sender {
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
