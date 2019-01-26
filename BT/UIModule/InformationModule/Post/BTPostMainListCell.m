//
//  BTPostMainListCell.m
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostMainListCell.h"
#import "ZJUnFoldView.h"
#import "ZJUnFoldView+Untils.h"
@interface BTPostMainListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAndNum;
@property (weak, nonatomic) IBOutlet UIView *viewComments;
@property (weak, nonatomic) IBOutlet UIView *viewImages;
@property (weak, nonatomic) IBOutlet UILabel *labelZFNum;
@property (weak, nonatomic) IBOutlet BTLabel *labelPLNum;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewImagesTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (weak, nonatomic) IBOutlet UIView *footView_1;
@property (weak, nonatomic) IBOutlet UIView *footView_2;
@property (weak, nonatomic) IBOutlet UIView *footView_3;

@property (weak, nonatomic) IBOutlet UIButton *sendFailureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (weak, nonatomic) IBOutlet UILabel *labelUnread;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelNameLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewZF;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPL;

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet BTLabel *jiaL;
@property (weak, nonatomic) IBOutlet BTLabel *labelFocus;

@property (nonatomic ,strong) BTPostMainListModel *model;

@property (nonatomic ,strong) ZJUnFoldView *unFoldView;
@property (nonatomic ,strong) ZJUnFoldView *sourcePostUnFoldView;
@end
@implementation BTPostMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.imageViewPhoto, 18);
    ViewRadius(self.labelUnread, 4);
    self.labelName.userInteractionEnabled = YES;
    self.imageViewPhoto.userInteractionEnabled = YES;
    self.unFoldView.unFoldLabel.userInteractionEnabled = YES;
    [self.imageViewPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    
    self.imageViewZF.image = IMAGE_NAMED(@"我的帖子-转发");
    self.imageViewPL.image = IMAGE_NAMED(@"我的帖子-评论");
    [self.deletBtn setImage:IMAGE_NAMED(@"我的帖子-删除") forState:UIControlStateNormal];
    // Initialization code
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    if (self.model.status != 99) {
      [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(_model.nickName)}];
    }
}
+ (instancetype)shareInstance{
    static BTPostMainListCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}
+ (CGFloat)cellHeightWithDiscussModel:(BTPostMainListModel *)model {
    
    BTPostMainListCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    return cell.heightCell;
}
- (void)configWithDiscussModel:(BTPostMainListModel *)model {
    
    if (model) {
        _model = model;
        self.labelUnread.hidden = !model.unread;
        if (ISStringEqualToString(model.whereVC, @"帖子主列表")) {
            self.imageViewTop.hidden = !model.hotRecommend;
            self.imageViewTop.image  = kIszh_hans ? IMAGE_NAMED(@"置顶_中文") : IMAGE_NAMED(@"置顶_英文");
            if (model.followed || (model.userId == getUserCenter.userInfo.userId)) {
                self.focusView.hidden = YES;
            }else {
                ViewBorderRadius(self.focusView, 4, 1, (isNightMode ? [UIColor colorWithHexString:@"154F78"] : [UIColor colorWithHexString:@"83BFEA"]));
                self.focusView.hidden = NO;
            }
        }else {
            self.imageViewTop.hidden = YES;
            self.focusView.hidden    = YES;
        }
        
        if (model.status != 99) {
          [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:self.imageViewPhoto andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
        }
//        [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelName.text = model.nickName;
        self.labelTimeAndNum.text = [NSString stringWithFormat:@"%@·%@%@",[getUserCenter NewTimePresentationStringWithTimeStamp:model.issueDate],[[DigitalHelperService transformWith:model.viewCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:model.viewCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:model.viewCount],[APPLanguageService wyhSearchContentWith:@"yuedu"]];
        
        self.labelZFNum.text = model.shareNum > 0 ? [NSString stringWithFormat:@"%ld",(long)model.shareNum] : [APPLanguageService sjhSearchContentWith:@"zhuanfa"];
        self.labelLikeNum.text = model.likeNum > 0 ? [NSString stringWithFormat:@"%ld",(long)model.likeNum] : [APPLanguageService wyhSearchContentWith:@"dianzan"];
        self.labelPLNum.text = model.commentNum > 0 ? [NSString stringWithFormat:@"%ld",(long)model.commentNum] : [APPLanguageService wyhSearchContentWith:@"pinglun"];
        if (!model.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"我的帖子-评论点赞-1"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"我的帖子-评论点赞-2"];
        }
        
        [self creatContentViewWith:_model.content];
        
        if(self.isCollcetDelete){
            self.deletBtn.hidden = NO;
        }else{
            if (self.IsShowDeletBtn) {
                if (model.userId == getUserCenter.userInfo.userId) {//只有自己才能删除自己的评论
                    self.deletBtn.hidden = NO;
                }else {
                    self.deletBtn.hidden = YES;
                }
            }else {
                self.deletBtn.hidden = YES;
            }
        }
       
        if ((model.errorType != 0 && ISNSStringValid(model.uuid)) || model.status == 4) {//发送失败 本地帖子 或下线
            
            self.footView_1.hidden     = YES;
            self.footView_2.hidden     = YES;
            self.footView_3.hidden     = YES;
            self.deletBtn.hidden       = NO;
            self.sendFailureBtn.hidden = NO;
            ViewRadius(self.sendFailureBtn, 13);
            if (model.status == 4) {//下线
                self.sendFailureBtn.enabled = NO;
                [self.sendFailureBtn setTitle:[NSString stringWithFormat:@"    %@",model.remark] forState:UIControlStateNormal];
            }
        }else {
            
            self.footView_1.hidden     = NO;
            self.footView_2.hidden     = NO;
            self.footView_3.hidden     = NO;
            //self.deletBtn.hidden       = YES;
            self.sendFailureBtn.hidden = YES;
        }
        
    }
}

-(void)creatContentViewWith:(NSString *)content {
    
     [self.viewComments removeAllSubviews];
     [self.viewImages removeAllSubviews];
     self.imagesViewHeight.constant = 0;
     self.commentsViewHeight.constant = 0;
    
    CGFloat height = [getUserCenter getSpaceLabelHeight:self.model.content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
    if (height > 100) {//未点击查看全文 但是超过4行的 只展示4行
        self.commentsViewHeight.constant = 100;
    }else {//原文刚好小于等于4行
        self.commentsViewHeight.constant = height > 20 ? height : 26;
    }
    
    if (_model.status == 99) {
        
        //content = [APPLanguageService wyhSearchContentWith:@"baoqiangaitieziyishanchu"];
        self.labelName.text = [APPLanguageService wyhSearchContentWith:@"baoqiangaitieziyishanchu"];
        self.labelName.textColor = kHEXCOLOR(0x999999);
        self.labelName.font = SYSTEMFONT(16);
        self.labelTimeAndNum.hidden = YES;
        self.imageViewPhoto.hidden  = YES;
        self.commentsViewHeight.constant = 0;
        self.labelNameLeft.constant = -36;
    }else {
        
        self.labelName.text = self.model.nickName;
        self.labelName.textColor = kHEXCOLOR(0x333333);
        self.labelName.font = BOLDSYSTEMFONT(16);
        self.labelTimeAndNum.hidden = NO;
        self.imageViewPhoto.hidden  = NO;
        self.labelNameLeft.constant = 10;
    }
    
    // 1.获取属性字符串：自定义内容和属性
    ZJUnFoldAttributedString * unFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:content
                                                                                     contentFont:SYSTEMFONT(16)
                                                                                    contentColor:_model.status != 99 ? kHEXCOLOR(0x333333) : kHEXCOLOR(0x999999)
                                                                                    unFoldString:@" "
                                                                                      foldString:@" "
                                                                                      unFoldFont:SYSTEMFONT(16)
                                                                                     unFoldColor:MainBg_Color
                                                                                     lineSpacing:7.0];
    // 2.添加展开视图
    _unFoldView = [[ZJUnFoldView alloc] initWithAttributedString:unFoldAttrStr maxWidth:ScreenWidth-30 isDefaultUnFold:_model.IsOrNoLookDetail foldLines:4 location:2];
    _unFoldView.frame = CGRectMake(0, 0, ScreenWidth-30, self.commentsViewHeight.constant);
    _unFoldView.isOrNotCanClick = YES;
    [self.viewComments addSubview:_unFoldView];
  
    WS(ws);
    _unFoldView.unFoldActionBlock = ^(BOOL isUnFold) {
        
        if (ws.lookAllBlock) {
            ws.lookAllBlock(ws.model);
        }
    };
    _unFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
        
        if (_model.status == 99 || (_model.errorType != 0 && ISNSStringValid(_model.uuid)) || _model.status == 4) return;
        if (ws.lookAllBlock) {
            ws.lookAllBlock(ws.model);
        }
    };
    //变色
    
    [getUserCenter postNikeNameChangeUILabelRangeColor:_unFoldView.unFoldLabel and:content color:MainBg_Color font:16];
    
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
    if (self.model.type != 3) {//原创
        self.viewImages.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        self.viewImagesTop.constant     = 0;
        if ([self.model.images isKindOfClass:[NSArray class]] && self.model.images.count > 0) {
            
            if (self.model.images.count == 1) {
                viewImagesTotalHeight = 170;
                self.imagesViewHeight.constant = viewImagesTotalHeight;
                //self.imagesViewHeight.constant = 170;
                NSString *imageUrl = SAFESTRING(self.model.images[0]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:160*2 andHeight:160*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 160, 160)];
                //[iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
                [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                iv.userInteractionEnabled = YES;
                iv.tag = 0;
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                iv.clipsToBounds = YES;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [self.viewImages addSubview:iv];
                
            }else {
                
                //self.imagesViewHeight.constant = imageW+10;
                viewImagesTotalHeight = imageW+10;
                for (NSInteger i = 0; i <
                     (self.model.images.count > 3 ? 3 : self.model.images.count); i++) {
                    
                    NSString *imageUrl = SAFESTRING(self.model.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*i, 10, imageW, imageW)];
                    [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                    [self.viewImages addSubview:iv];
                    
                    if (self.model.images.count > 3 && i == 2) {
                        
                        BTView *nubView = [[BTView alloc] initWithFrame:CGRectMake(ScreenWidth-21-36, viewImagesTotalHeight-6-16, 36, 16)];
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
                
            }
            
            self.imagesViewHeight.constant = viewImagesTotalHeight;
            
        }else {
            viewImagesTotalHeight = 0;
            self.imagesViewHeight.constant = viewImagesTotalHeight;
        }
        
    }else {//转发
        
        self.viewImages.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
        self.viewImagesTop.constant     = 10;
        if (self.model.sourcePostModel == nil) {
            
            UIImageView *deletIV = [[UIImageView alloc] init];
            deletIV.frame = CGRectMake(15, 10, 16, 16);
            deletIV.image = IMAGE_NAMED(@"我的帖子-删除");
            [self.viewImages addSubview:deletIV];
           
            BTLabel *deletLabel = [[BTLabel alloc] init];
            deletLabel.frame = CGRectMake(40, 10, ScreenWidth-55, 20);
            deletLabel.localText = @"yuantieyishanchu";
            deletLabel.font      = SYSTEMFONT(14);
            deletLabel.textColor = CFontColor11;
            [self.viewImages addSubview:deletLabel];
            
            UIButton *deletBtn = [[UIButton alloc] init];
            deletBtn.frame = CGRectMake(0, 0, ScreenWidth, 40)
            ;
            [deletBtn addTarget:self action:@selector(yuanTieDeletBtnClick) forControlEvents:UIControlEventTouchUpInside];
            //[self.viewImages addSubview:deletBtn];
            
            viewImagesTotalHeight = 50;
            self.imagesViewHeight.constant = (viewImagesTotalHeight - 10);
        }else {
        NSString *sourcePostContent = [NSString stringWithFormat:@"@%@:%@",self.model.sourcePostModel.nickName,self.model.sourcePostModel.content];
        CGFloat sourcePostTitleheight = [getUserCenter getSpaceLabelHeight:sourcePostContent withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
        if (sourcePostTitleheight > 88) {//未点击查看全文 但是超过4行的 只展示4行
            viewImagesTotalHeight = 88+30;
            //self.imagesViewHeight.constant = 88+10;
            //self.imagesViewHeight.constant += (88+20);
        }else {//原文刚好小于等于4行
            viewImagesTotalHeight = sourcePostTitleheight+30;
            //self.imagesViewHeight.constant = sourcePostTitleheight+10;
            //self.imagesViewHeight.constant += (sourcePostTitleheight+20);
        }
        
        ZJUnFoldAttributedString * sourcePostUnFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:sourcePostContent
                                                                                         contentFont:SYSTEMFONT(14)
                                                                                        contentColor:CFontColor16
                                                                                        unFoldString:@" "
                                                                                          foldString:@" "
                                                                                          unFoldFont:SYSTEMFONT(14)
                                                                                         unFoldColor:MainBg_Color
                                                                                         lineSpacing:7.0];
        // 2.添加展开视图
        _sourcePostUnFoldView = [[ZJUnFoldView alloc] initWithAttributedString:sourcePostUnFoldAttrStr maxWidth:ScreenWidth-30 isDefaultUnFold:self.model.sourcePostModel.IsOrNoLookDetail foldLines:4 location:2];
        _sourcePostUnFoldView.isOrNotCanClick = YES;
        //故意y多＋5 这样显得居中
        _sourcePostUnFoldView.frame = CGRectMake(15, 15, ScreenWidth-30, sourcePostTitleheight > 88 ? 88 : sourcePostTitleheight);
        [self.viewImages addSubview:_sourcePostUnFoldView];
        _sourcePostUnFoldView.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
        WS(ws);
        _sourcePostUnFoldView.unFoldActionBlock = ^(BOOL isUnFold) {
            
            if (ws.lookAllBlock) {
                ws.lookAllBlock(ws.model);
            }
        };
        _sourcePostUnFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
            if (ws.lookAllBlock) {
                ws.lookAllBlock(ws.model);
            }
        };
       //被转发的用户标记颜色
       [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:_sourcePostUnFoldView.unFoldLabel and:sourcePostContent color:SecondColor font:14.0f];
            
        if ([self.model.sourcePostModel.images isKindOfClass:[NSArray class]] && self.model.sourcePostModel.images.count > 0) {
            //viewImagesTotalHeight += 10;
            if (self.model.sourcePostModel.images.count == 1) {
                
                //self.imagesViewHeight.constant += 170;
                
                NSString *imageUrl = SAFESTRING(self.model.sourcePostModel.images[0]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:160*2 andHeight:160*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, viewImagesTotalHeight, 160, 160)];
                [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
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
                     (self.model.sourcePostModel.images.count > 3 ? 3 : self.model.sourcePostModel.images.count); i++) {
                    
                    NSString *imageUrl = SAFESTRING(self.model.sourcePostModel.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*i, viewImagesTotalHeight, imageW, imageW)];
                    [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                    [self.viewImages addSubview:iv];
                   
                    if (self.model.sourcePostModel.images.count > 3 && i == 2) {
                        
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
                        nubLabel.text = [NSString stringWithFormat:@"%ld",self.model.sourcePostModel.images.count];
                    }
                }
                
                viewImagesTotalHeight += (imageW+10+10);
            }
            
            self.imagesViewHeight.constant = (viewImagesTotalHeight - 10);
        }else {
            viewImagesTotalHeight += 10;
            self.imagesViewHeight.constant = (viewImagesTotalHeight - 10);
        }
            
        }
    }
    
    self.heightCell = 128+self.commentsViewHeight.constant+viewImagesTotalHeight;
}

//关注
- (IBAction)focusBtnClick:(UIButton *)sender {
    
    if (ISStringEqualToString(_model.whereVC, @"帖子主列表")) {
        [MobClick event:@"post_follow"];
        if (self.focusPostUserBlock) {
            self.focusPostUserBlock(_model);
        }
    }
}

//转发
- (IBAction)zhuangFaBtnClick:(UIButton *)sender {
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-全部"))  [MobClick event:@"post_mypost_all_zhuanfa"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-原创"))  [MobClick event:@"post_mypost_original_zhuanfa"];
    if (ISStringEqualToString(_model.whereVC, @"帖子主列表"))  [MobClick event:@"post_zhuanfa"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-收藏")) {
        [MobClick event:@"post_mypost_collection_zhuanfa"];
        if (_model.status == 99) return;
    }
    if (_model.type != 3) {
        
        if (self.forwardingBlock) {
            self.forwardingBlock(_model);
        }
    }else {
    
        if (_model.sourcePostModel == nil) {
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"bunengzhuanfa"] wait:YES];
        }else {
            
            if (self.forwardingBlock) {
                self.forwardingBlock(_model);
            }
        }

    }
}
//评论
- (IBAction)commentsBtnClick:(UIButton *)sender {
    
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-全部"))  [MobClick event:@"post_mypost_all_comment"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-原创"))  [MobClick event:@"post_mypost_original_comment"];
    if (ISStringEqualToString(_model.whereVC, @"帖子主列表"))  [MobClick event:@"post_comment"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-收藏")) {
        
        [MobClick event:@"post_mypost_collection_comment"];
        if (_model.status == 99) return;
    }
    if (self.commentsBlock) {
        self.commentsBlock(_model);
    }
}
//点赞
- (IBAction)likeBtnClick:(UIButton *)sender {
    
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-全部"))  [MobClick event:@"post_mypost_all_zan"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-原创"))  [MobClick event:@"post_mypost_original_zan"];
    if (ISStringEqualToString(_model.whereVC, @"帖子主列表"))  [MobClick event:@"post_zan"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-收藏")) {
        [MobClick event:@"post_mypost_collection_zan"];
        if (_model.status == 99) return;
    }
    if (self.likeBlock) {
        
        self.likeBlock(_model);
    }
}
//删除
- (IBAction)deletBtnClick:(UIButton *)sender {
    
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-全部"))  [MobClick event:@"post_mypost_all_del"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-原创"))  [MobClick event:@"post_mypost_original_del"];
    if (ISStringEqualToString(_model.whereVC, @"我的帖子-收藏")) {
        [MobClick event:@"post_mypost_collection_del"];
        //if (_model.status == 99) return;
    }
    if (self.deletPostBlock) {
        self.deletPostBlock(_model);
    }
}
//从新发送失败的帖子
- (IBAction)sendPostAgainBtnClick:(UIButton *)sender {
    
    if (self.sendPostAgainBlock) {
        self.sendPostAgainBlock(_model);
    }
}

- (void)yuanTieDeletBtnClick {
    
    [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@""] wait:YES];
}
- (void)clickImage:(UITapGestureRecognizer *)gesture
{
    UIImageView *iv = (UIImageView *)gesture.view;
    KPostNotification(@"hide_CustomTabBarView", nil);
    if (self.model.type == 3) {//转发
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:self.model.sourcePostModel.images andIndexPath:iv.tag];
        
    }else {
        
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:self.model.images andIndexPath:iv.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
