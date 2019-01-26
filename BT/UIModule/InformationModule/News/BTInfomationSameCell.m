//
//  BTInfomationSameCell.m
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTInfomationSameCell.h"

@implementation BTInfomationSameCell

//- (void)addSubview:(UIView *)view
//{
//    if (![view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]] && view)
//        [super addSubview:view];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.sourceL.userInteractionEnabled = YES;
    self.photoIV.userInteractionEnabled = YES;
    [self.photoIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.sourceL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    // Initialization code
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    if (ISNSStringValid(_model.avatar)) {
        NSLog(@"*************进入个人主页****************");
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(self.model.source)}];
    }
}
-(void)creatUIWith:(FastInfomationObj *)obj {
    _model = obj;
    self.titleL.text = obj.title;
    if (!ISStringEqualToString(self.whereVC, @"我的收藏")) {
        if ([[BTSearchService sharedService] readSheQuHistoryReadWithInfoID:obj.infoID type:obj.type]) {
            
            self.titleL.textColor = ThirdColor;
        }else {
            
            self.titleL.textColor = FirstColor;
        }
    }
    ViewRadius(self.iconIV, 3);
    ViewRadius(self.photoIV, 8);
    [getUserCenter getLabelHight:self.titleL Float:4 AddImage:NO];
    self.sourceL.text = [NSString stringWithFormat:@"%@",!ISNSStringValid(obj.avatar)?obj.source:obj.nickName];
    self.timeL.text = [NSString stringWithFormat:@" · %@",[getUserCenter NewTimePresentationStringWithTimeStamp:obj.issueDate]];
    //self.sourceL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    //检查字符串是否以astring结尾；
    [self.viewCountL setTitle:[NSString stringWithFormat:@"%@%@",[[DigitalHelperService transformWith:obj.viewCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:obj.viewCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:obj.viewCount],[APPLanguageService wyhSearchContentWith:@"yuedu"]] forState:UIControlStateNormal];
    if (obj.type == 6) {
        
        self.photoIVW.constant = 16;
        self.left.constant = 6;
        self.photoIV.frame = CGRectMake(15, 74, 16, 16);
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:obj.avatar andImageView:self.photoIV andAuthStatus:obj.authStatus andAuthType:obj.authType addSuperView:self.contentView];
        
    }else {
        
        self.photoIVW.constant = 0;
        self.left.constant = 0;
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:obj.avatar andImageView:self.photoIV andAuthStatus:obj.authStatus andAuthType:obj.authType addSuperView:self.contentView];
    }
    
    
    

    obj.imgUrl = SAFESTRING(obj.imgUrl);
    [self.iconIV setImageWithURL:[NSURL URLWithString:[obj.imgUrl hasPrefix:@"http"]?obj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.imgUrl]] placeholder:[UIImage imageNamed:@"Mask_list"]];
    if (ISNSStringValid(obj.imgUrl)) {
        
        self.imageIVWight.constant = 88;
    }else {
        
        self.imageIVWight.constant = 0;
    }
    
    if (ISStringEqualToString(self.whereVC, @"关注")) {
        self.downLeft.constant = 0;
        self.downRight.constant = 0;
        self.downHeight.constant = 6;
        self.lineL.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
    }
}
-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"收藏-已勾选"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"收藏-未勾选"];
                    }
                }
            }
        }else  if ([control isMemberOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]){
            
            control.backgroundColor = KClearColor;
        }
    }
    [super layoutSubviews];
}


//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"收藏-未勾选"];
                    }
                }
            }
        }else  if ([control isMemberOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]){
            
            control.backgroundColor =KClearColor;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
