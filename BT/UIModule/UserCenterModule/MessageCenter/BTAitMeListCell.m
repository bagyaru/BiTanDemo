//
//  BTAitMeListCell.m
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAitMeListCell.h"

@interface BTAitMeListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelUnread;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSource;

@property (weak, nonatomic) IBOutlet UILabel *labelSource;

@property (weak, nonatomic) IBOutlet UIView *commentsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceImageW;

@property (weak, nonatomic) IBOutlet UIView *viewImages;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewImagesTop;

@property (weak, nonatomic) IBOutlet UIView *viewSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSourceHeight;

@end
@implementation BTAitMeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.labelUnread, 4);
    ViewRadius(self.imageViewIcon, 18);
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
+ (instancetype)shareInstance{
    static BTAitMeListCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([BTAitMeListCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}
+ (CGFloat)cellHeightWithDiscussModel:(BTAitMeCommentModel *)model {
    
    BTAitMeListCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    return cell.heightCell;
}
- (void)configWithDiscussModel:(BTAitMeCommentModel *)model{
    if (model) {
        _model = model;
        //防止计算不准确 去掉空格
        self.labelName.text = model.userName;
        self.labelUnread.hidden = !model.unread;
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:model.date];
        //[self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.userAvatar andImageView:self.imageViewIcon andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
//        model.title = [NSString stringWithFormat:@"%@",[model.title stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//        model.title = [NSString stringWithFormat:@"%@",[model.title stringByReplacingOccurrencesOfString:@"\b" withString:@""]];
        [self.imageViewSource sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.imgUrl) hasPrefix:@"http"]?SAFESTRING(model.imgUrl):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(model.imgUrl)]] placeholderImage:[UIImage imageNamed:@"评论默认"]];
        if (ISNSStringValid(model.title)) {
            
            self.labelSource.text  = [[model.title stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        }else {

            self.imageViewSource.image = IMAGE_NAMED(@"通知-文章帖子删除");
            self.labelSource.text  = [APPLanguageService wyhSearchContentWith:@"baoqiangaineirongyishanchu"];
        }
        self.labelSource.lineBreakMode = NSLineBreakByTruncatingTail;
        //变色
        [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:self.labelSource and:model.title color:ThirdColor font:14.0f];
//        if (model.imgUrl == nil || [model.imgUrl length] == 0) {
//
//            self.sourceImageW.constant = 0;
//        }else {
//            self.sourceImageW.constant = 30;
//            [self.imageViewSource sd_setImageWithURL:[NSURL URLWithString:[model.imgUrl hasPrefix:@"http"]?model.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.imgUrl]] placeholderImage:[UIImage imageNamed:@"评论默认"]];
//        }
    
        [self.commentsView removeAllSubviews];
        [self.viewImages removeAllSubviews];
        [self creatContentViewWith:model.content];
        if (model.jumpType == 6) {//帖子
            self.viewSource.hidden = YES;
            self.imageViewSource.hidden = YES;
            self.labelSource.hidden = YES;
            self.viewSourceHeight.constant = 0;
            self.heightCell -= 50;
            
            self.viewImages.hidden = NO;
            [self creatImagesView];
        }else {
            self.viewSource.hidden = NO;
            self.imageViewSource.hidden = NO;
            self.labelSource.hidden = NO;
            self.viewSourceHeight.constant = 50;
            self.viewImages.hidden = YES;
            self.imagesViewHeight.constant = 0;
        }
    }
}
-(void)creatContentViewWith:(NSString *)content {
    CGFloat height = [getUserCenter getSpaceLabelHeight:content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
    
    if (_model.IsOrNoLookDetail) {//点击了查看全文
        
        self.commentsViewHeight.constant = height;
        self.heightCell = 142+height;
        if (_model.isAddOneLine) {
            self.commentsViewHeight.constant = height+24;
            self.heightCell = 142+height+24;
        }
    }else {
        if (height > 150) {//未点击查看全文 但是超过6行的 只展示6行
            self.commentsViewHeight.constant = 150;
            self.heightCell = 142+150;
        }else {//原文刚好小于等于3行
            self.commentsViewHeight.constant = height;
            self.heightCell = 142+height;
        }
    }
    // 1.获取属性字符串：自定义内容和属性
    ZJUnFoldAttributedString * unFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:content
                                                                                     contentFont:SYSTEMFONT(16)
                                                                                    contentColor:[ZJUnFoldView colorWithHexString:@"#151515"]
                                                                                    unFoldString:[APPLanguageService wyhSearchContentWith:@"quanwen"]
                                                                                      foldString:@" "
                                                                                      unFoldFont:SYSTEMFONT(16)
                                                                                     unFoldColor:MainBg_Color
                                                                                     lineSpacing:7.0];
    [self.commentsView removeAllSubviews];
    // 2.添加展开视图
    _unFoldView = [[ZJUnFoldView alloc] initWithAttributedString:unFoldAttrStr maxWidth:ScreenWidth-30 isDefaultUnFold:_model.IsOrNoLookDetail foldLines:6 location:2];
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
    _unFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
        
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(BTAitMeListCellCopyLableWithDiscussModel:indexRow:)]) {
            
            [ws.delegate BTAitMeListCellCopyLableWithDiscussModel:ws.model indexRow:ws.indexPath.row];
        }
        
    };
    
}
-(void)creatImagesView {
    
    CGFloat spacing;
    CGFloat imageW;
    CGFloat viewImagesTotalHeight = 0.0;
    if (ScreenWidth > 320) {
        imageW = 110;
        spacing = (ScreenWidth-imageW*3-30)/2;
    }else {
        
        imageW = 90;
        spacing = (ScreenWidth-imageW*3-30)/2;
    }
    
    self.viewImages.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
    self.viewImagesTop.constant     = 10;
    
    NSString *sourcePostContent = [NSString stringWithFormat:@"@%@:%@",self.model.sourceInfoUserName,self.model.title];
    
    CGFloat sourcePostTitleheight = [getUserCenter getSpaceLabelHeight:sourcePostContent withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
    
    if (sourcePostTitleheight > 88) {//未点击查看全文 但是超过4行的 只展示4行
        
        viewImagesTotalHeight = 88+30;
        
    }else {//原文刚好小于等于4行
        
        viewImagesTotalHeight = sourcePostTitleheight+30;

    }
        
    
    ZJUnFoldAttributedString * sourcePostUnFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:sourcePostContent
                                                                                                   contentFont:SYSTEMFONT(14)
                                                                                                  contentColor:CFontColor16
                                                                                                  unFoldString:[APPLanguageService wyhSearchContentWith:@"quanwen"]
                                                                                                    foldString:@" "
                                                                                                    unFoldFont:SYSTEMFONT(14)
                                                                                                   unFoldColor:MainBg_Color
                                                                                                   lineSpacing:7.0];
        // 2.添加展开视图
        _sourcePostUnFoldView = [[ZJUnFoldView alloc] initWithAttributedString:sourcePostUnFoldAttrStr maxWidth:ScreenWidth-30 isDefaultUnFold:self.model.IsOrNoLookSourceDetail foldLines:4 location:2];
        _sourcePostUnFoldView.isOrNotCanClick = YES;
        //故意y多＋5 这样显得居中
        _sourcePostUnFoldView.frame = CGRectMake(15, 15, ScreenWidth-30, sourcePostTitleheight > 88 ? 88 : sourcePostTitleheight);
        [self.viewImages addSubview:_sourcePostUnFoldView];
        _sourcePostUnFoldView.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
        WS(ws);
        _sourcePostUnFoldView.unFoldActionBlock = ^(BOOL isUnFold) {
            
            if (ws.sourceLookAllBlock) {
                ws.sourceLookAllBlock(ws.indexPath.row);
            }
        };
        _sourcePostUnFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(BTAitMeListCellCopyLableWithDiscussModel:indexRow:)]) {
                
                [ws.delegate BTAitMeListCellCopyLableWithDiscussModel:ws.model indexRow:ws.indexPath.row];
            }
        };
        //被转发的用户标记颜色
        [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:_sourcePostUnFoldView.unFoldLabel and:sourcePostContent color:SecondColor font:14.0f];
    
        if ([self.model.images isKindOfClass:[NSArray class]] && self.model.images) {
            //viewImagesTotalHeight += 10;
            if (self.model.images.count == 1) {
                
                //self.imagesViewHeight.constant += 170;
                NSString *imageUrl = SAFESTRING(self.model.images[0]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:160*2 andHeight:160*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, viewImagesTotalHeight, 160, 160)];
                [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
                iv.userInteractionEnabled = YES;
                iv.tag = 0;
                iv.clipsToBounds = YES;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                [self.viewImages addSubview:iv];
                viewImagesTotalHeight += (160+10+10);
            }else {
                
                //self.imagesViewHeight.constant += (imageW+10);
                for (NSInteger i = 0; i <
                     (self.model.images.count > 3 ? 3 : self.model.images.count); i++) {
                    
                    NSString *imageUrl = SAFESTRING(self.model.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*i, viewImagesTotalHeight, imageW, imageW)];
                    [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                    [self.viewImages addSubview:iv];
                    
                    if (self.model.images.count > 3 && i == 2) {
                        
                        BTView *nubView = [[BTView alloc] initWithFrame:CGRectMake(ScreenWidth-21-36, viewImagesTotalHeight+10+imageW-6-16-10, 36, 16)];
                        nubView.backgroundColor = kHEXCOLOR(0x000000);
                        [self.viewImages addSubview:nubView];
                        
                        UIImageView *smallIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 12, 10)];
                        smallIV.image = IMAGE_NAMED(@"我的帖子-小图片");
                        [nubView addSubview:smallIV];
                        
                        BTLabel *nubLabel = [[BTLabel alloc] initWithFrame:CGRectMake(22, 0, 14, 16)];
                        nubLabel.font = FONTOFSIZE(12);
                        nubLabel.textColor = kHEXCOLOR(0xFFFFFF);
                        [nubView addSubview:nubLabel];
                        nubLabel.text = [NSString stringWithFormat:@"%ld",self.model.images.count];
                    }
                }
                
                viewImagesTotalHeight += (imageW+10+10);
            }
            
            self.imagesViewHeight.constant = (viewImagesTotalHeight - 10);
        }else {
            viewImagesTotalHeight += 10;
            self.imagesViewHeight.constant = (viewImagesTotalHeight - 10);
        }
    
    self.heightCell += self.imagesViewHeight.constant;
}
- (void)clickImage:(UITapGestureRecognizer *)gesture
{
    UIImageView *iv = (UIImageView *)gesture.view;
    [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:self.model.images andIndexPath:iv.tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
