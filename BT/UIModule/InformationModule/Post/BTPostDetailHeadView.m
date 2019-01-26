//
//  BTPostDetailHeadView.m
//  BT
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostDetailHeadView.h"
#import "ZJUnFoldView.h"
#import "ZJUnFoldView+Untils.h"
@interface BTPostDetailHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeAndNum;
@property (weak, nonatomic) IBOutlet BTCopyLabel *labelContent;
@property (weak, nonatomic) IBOutlet UIView *viewImages;

@property (weak, nonatomic) IBOutlet UIButton *zfBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewImagesTop;

@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet BTLabel *jiaL;
@property (weak, nonatomic) IBOutlet BTLabel *labelFocus;

@property (nonatomic ,strong) ZJUnFoldView *sourcePostUnFoldView;
@end
@implementation BTPostDetailHeadView

- (void)configWithDiscussModel:(BTPostMainListModel *)model {

    if (model) {
       
        ViewRadius(self.imageViewPhoto, 18);
        ViewBorderRadius(self.zfBtn, 18, 1, BtnBorderColor);
        ViewBorderRadius(self.zanBtn, 18, 1, BtnBorderColor);
        ViewBorderRadius(self.focusView, 4, 1, (isNightMode ? [UIColor colorWithHexString:@"154F78"] : [UIColor colorWithHexString:@"83BFEA"]));
        [self.zfBtn setImage:IMAGE_NAMED(@"我的帖子-转发") forState:UIControlStateNormal];
        
        self.labelName.userInteractionEnabled = YES;
        self.imageViewPhoto.userInteractionEnabled = YES;
        [self.imageViewPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
        [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
        
        _model = model;
        //防止计算不准确 去掉空格
        _model.content = [_model.content stringByReplacingOccurrencesOfString:@"" withString:@""];
        _model.sourcePostModel.content = [_model.sourcePostModel.content stringByReplacingOccurrencesOfString:@"" withString:@""];
        
        //[self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:self.imageViewPhoto andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self];
        
        self.labelName.text = model.nickName;
        self.labelTimeAndNum.text = [NSString stringWithFormat:@"%@·%@%@",[getUserCenter NewTimePresentationStringWithTimeStamp:model.issueDate],[[DigitalHelperService transformWith:model.viewCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:model.viewCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:model.viewCount],[APPLanguageService wyhSearchContentWith:@"yuedu"]];
        self.labelContent.text = model.content;
        self.labelContent.tag  = 87541512;
        [getUserCenter setLabelSpace:self.labelContent withValue:model.content withFont:SYSTEMFONT(16) withHJJ:7.0 withZJJ:0.0];
        [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelContent and:model.content color:MainBg_Color font:16];
        
        [self.zfBtn setTitle:model.shareNum > 0 ? [NSString stringWithFormat:@"%ld",model.shareNum] : [APPLanguageService sjhSearchContentWith:@"zhuanfa"] forState:UIControlStateNormal];
        [self.zanBtn setTitle:model.likeNum > 0 ? [NSString stringWithFormat:@"%ld",model.likeNum] : [APPLanguageService wyhSearchContentWith:@"dianzan"] forState:UIControlStateNormal];
        if (!model.liked) {
            [self.zanBtn setImage:IMAGE_NAMED(@"我的帖子-评论点赞-1") forState:UIControlStateNormal];
        }else{
            [self.zanBtn setImage:IMAGE_NAMED(@"我的帖子-评论点赞-2") forState:UIControlStateNormal];
        }
//        if (model.followed || (model.userId == getUserCenter.userInfo.userId)) {
//            self.focusView.hidden = YES;
//        }
        if ((model.userId == getUserCenter.userInfo.userId)) {
            self.focusView.hidden = YES;
        }else {
            
            if (model.firstFollowed) {
                self.focusView.hidden = NO;
                if (model.followed) {
                    self.jiaL.text = @"";
                    self.labelFocus.fixText = @"quxiaoguanzhu";
                    self.labelFocus.textColor = ThirdColor;
                    ViewBorderRadius(self.focusView, 4, 1, SeparateColor);
                }else {
                    
                    self.jiaL.text = @"+";
                    self.labelFocus.fixText = @"guanzhu";
                    self.labelFocus.textColor = MainBg_Color;
                    ViewBorderRadius(self.focusView, 4, 1, (isNightMode ? [UIColor colorWithHexString:@"154F78"] : [UIColor colorWithHexString:@"83BFEA"]));
                }
            }else {
                if (model.followed) {
                    self.focusView.hidden = YES;
                }else {
                    self.focusView.hidden = NO;
                }
            }
        }
        [self creatImagesView];
    }
}

-(void)creatImagesView {
    [self.viewImages removeAllSubviews];
    self.imagesViewHeight.constant = 0;
    CGFloat spacing;
    CGFloat imageW;
    //CGFloat imageH = 0.0;
    if (ScreenWidth > 320) {
        imageW = 110;
        spacing = (ScreenWidth-imageW*3-30)/2;
    }else {
        
        imageW = 90;
        spacing = (ScreenWidth-imageW*3-30)/2;
    }
    if ([self.model.images isKindOfClass:[NSArray class]]) {
        self.model.images = [self.model.images bk_select:^BOOL(id  _Nonnull obj) {
            
            NSInteger index = [self.model.images indexOfObject:obj];
            
            return index < 6;
            
        }];
    }
    if (self.model.type != 3) {//原创
        self.viewImages.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;;
        self.viewImagesTop.constant     = 0;
        if ([self.model.images isKindOfClass:[NSArray class]] && self.model.images.count > 0) {
            if (self.model.images.count == 1) {
                NSString *imageUrl = SAFESTRING(self.model.images[0]);
                imageUrl = [NSString stringWithFormat:@"%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl]];
                UIImageView *iv = [[UIImageView alloc] init];
                [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"] options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    CGFloat h;
                    CGFloat w;
                    if (image.size.width <= ScreenWidth-30) {
                        h = image.size.height;
                        w = image.size.width;
                    }else {
                        
                        w = ScreenWidth-30;
                        h = image.size.height/image.size.width*w;
                    }
                    iv.frame = CGRectMake(15, 10, w, h);
                    self.imagesViewHeight.constant = h+10;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(BTPostDetailHeadViewHeight:)]) {
                        
                        [self.delegate BTPostDetailHeadViewHeight:[self getHeadViewHeight]];
                    }
                    
                }];
                iv.userInteractionEnabled = YES;
                iv.tag = 0;
                iv.clipsToBounds = YES;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                [self.viewImages addSubview:iv];
            }
            if (self.model.images.count == 2 || self.model.images.count == 4) {
                imageW  = (ScreenWidth-30-8)/2;
                spacing = 8;
                self.imagesViewHeight.constant = self.model.images.count/2*imageW+spacing*(self.model.images.count/2-1)+10;
                for (NSInteger i = 0; i < self.model.images.count; i++) {
                    NSString *imageUrl = SAFESTRING(self.model.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*(i%2), 10+(imageW+spacing)*(i/2), imageW, imageW)];
                    [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                    [self.viewImages addSubview:iv];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                }
            }
            if (self.model.images.count == 3 || self.model.images.count == 5 || self.model.images.count == 6) {
                imageW  = (ScreenWidth-30-8)/3;
                spacing = 8;
                if (self.model.images.count == 3) {
                    self.imagesViewHeight.constant = 10 +imageW;
                }else {
                    self.imagesViewHeight.constant = 10 +imageW*2+spacing;
                }
                for (NSInteger i = 0; i < self.model.images.count; i++) {
                    NSString *imageUrl = SAFESTRING(self.model.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*(i%3), 10+(imageW+spacing)*(i/3), imageW, imageW)];
                    [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                    [self.viewImages addSubview:iv];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                }
            }
            
        }else {
            
            self.imagesViewHeight.constant = 0;
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
            
            self.imagesViewHeight.constant = 40;
        }else {
        NSString *sourcePostContent = [NSString stringWithFormat:@"@%@:%@",self.model.sourcePostModel.nickName,self.model.sourcePostModel.content];
        CGFloat sourcePostTitleheight = [getUserCenter getSpaceLabelHeight:sourcePostContent withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
        NSLog(@"%.0f",sourcePostTitleheight);
        self.imagesViewHeight.constant += (sourcePostTitleheight+20);
        
        ZJUnFoldAttributedString * sourcePostUnFoldAttrStr = [[ZJUnFoldAttributedString alloc] initWithContent:sourcePostContent
                                                                                                   contentFont:SYSTEMFONT(14)
                                                                                                  contentColor:CFontColor16
                                                                                                  unFoldString:[APPLanguageService wyhSearchContentWith:@"quanwen"]
                                                                                                    foldString:@" "
                                                                                                    unFoldFont:SYSTEMFONT(14)
                                                                                                   unFoldColor:MainBg_Color
                                                                                                   lineSpacing:7.0];
        // 2.添加展开视图
        _sourcePostUnFoldView = [[ZJUnFoldView alloc] initWithAttributedString:sourcePostUnFoldAttrStr maxWidth:ScreenWidth-30 isDefaultUnFold:self.model.sourcePostModel.IsOrNoLookDetail foldLines:100 location:2];
        //故意y多＋5 这样显得居中
        _sourcePostUnFoldView.frame = CGRectMake(15, 15, _sourcePostUnFoldView.frame.size.width, _sourcePostUnFoldView.frame.size.height);
        [self.viewImages addSubview:_sourcePostUnFoldView];
        _sourcePostUnFoldView.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
        //被转发的用户标记颜色
        [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:_sourcePostUnFoldView.unFoldLabel and:sourcePostContent color:SecondColor font:14.0f];
            
            WS(ws);
            _sourcePostUnFoldView.unFoldLabel.copyBlock = ^(NSString *commentID, NSString *userName) {
                
                [ws sourceBtnClcik];
            };
//        [getUserCenter replyChangeUILabelRangeColor:_sourcePostUnFoldView.unFoldLabel and:[NSString stringWithFormat:@"@%@:",self.model.sourcePostModel.nickName] color:MainBg_Color font:14.0f];
        
        if ([self.model.sourcePostModel.images isKindOfClass:[NSArray class]] && self.model.sourcePostModel.images.count > 0) {
            
            if (self.model.sourcePostModel.images.count == 1) {
                
                self.imagesViewHeight.constant += 180;
                NSString *imageUrl = SAFESTRING(self.model.sourcePostModel.images[0]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:160*2 andHeight:160*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+_sourcePostUnFoldView.frame.size.height+10+10, 160, 160)];
                [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                [self.viewImages addSubview:iv];
                iv.userInteractionEnabled = YES;
                iv.tag = 0;
                iv.clipsToBounds = YES;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
            }else {
                
                self.imagesViewHeight.constant += (imageW+10+10);
                for (NSInteger i = 0; i <
                     (self.model.sourcePostModel.images.count > 3 ? 3 : self.model.sourcePostModel.images.count); i++) {
                    
                    NSString *imageUrl = SAFESTRING(self.model.sourcePostModel.images[i]);
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:imageW*2 andHeight:imageW*2];
                    imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(spacing+imageW)*i, 10+_sourcePostUnFoldView.frame.size.height+10+10, imageW, imageW)];
                    [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"Mask_list"]];
                    [self.viewImages addSubview:iv];
                    iv.userInteractionEnabled = YES;
                    iv.tag = i;
                    iv.clipsToBounds = YES;
                    iv.contentMode = UIViewContentModeScaleAspectFill;
                    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
                    if (self.model.sourcePostModel.images.count > 3 && i == 2) {
                        
                        BTView *nubView = [[BTView alloc] initWithFrame:CGRectMake(ScreenWidth-21-36, self.imagesViewHeight.constant-6-16-10, 36, 16)];
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
            }
            
        }else {
            
            self.imagesViewHeight.constant += 10;
        }
        
//        UIButton *sourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, sourcePostTitleheight+20)];
//        sourceBtn.backgroundColor = KRedColor;
//        [self.viewImages addSubview:sourceBtn];
//        [sourceBtn addTarget:self action:@selector(sourceBtnClcik) forControlEvents:UIControlEventTouchUpInside];
            
            self.viewImages.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",self.model.sourcePostModel.postId]} completion:^(id obj) {
                    //原贴被点赞 也要刷新主列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
                }];
                
            }];
            [self.viewImages addGestureRecognizer:tap];
        }
    }
}
- (void)clickImage:(UITapGestureRecognizer *)gesture
{
    UIImageView *iv = (UIImageView *)gesture.view;
    if (self.model.type == 3) {//转发
        
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:self.model.sourcePostModel.images andIndexPath:iv.tag];
        
    }else {
        
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:self.model.images andIndexPath:iv.tag];
    }
}
//进入原贴
-(void)sourceBtnClcik {
    
    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",self.model.sourcePostModel.postId]} completion:^(id obj) {
       //原贴被点赞 也要刷新主列表
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
    }];
}
-(CGFloat)getHeadViewHeight {
    
    CGFloat height = [getUserCenter getSpaceLabelHeight:self.model.content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30 withHJJ:7.0 withZJJ:0.0];
    NSLog(@"%f",height);
    return height + self.imagesViewHeight.constant + 172;
}
- (IBAction)zfBtnClick:(UIButton *)sender {
    
    if (self.forwardingBlock) {
        self.forwardingBlock(self.model);
    }
}

- (IBAction)zanBtnClick:(UIButton *)sender {
    
    if (self.likeBlock) {
        self.likeBlock(self.model);
    }
}
- (IBAction)focusBtnClick:(UIButton *)sender {
    
    if (self.focusBlock) {
        self.focusBlock(self.model);
    }
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(self.model.nickName)}];
}
@end
