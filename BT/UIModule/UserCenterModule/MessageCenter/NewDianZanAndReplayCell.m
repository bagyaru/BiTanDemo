//
//  NewDianZanAndReplayCell.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewDianZanAndReplayCell.h"
@interface NewDianZanAndReplayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet BTCopyLabel *labelComment;

@property (weak, nonatomic) IBOutlet BTCopyLabel *labelReplay;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewZan;
@property (weak, nonatomic) IBOutlet UILabel *labelUnread;
@property (weak, nonatomic) IBOutlet UIImageView *deletIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;


@end
@implementation NewDianZanAndReplayCell{
    ZanAndReplayListModel *_model;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.labelUnread, 4);
    ViewRadius(self.imageViewIcon, 18);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelComment.preferredMaxLayoutWidth = ScreenWidth - 61 - 126;
    
    self.labelName.userInteractionEnabled = YES;
    self.imageViewIcon.userInteractionEnabled = YES;
    [self.imageViewIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [self.labelName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    self.deletIV.image = IMAGE_NAMED(@"消息点赞删除");
}
//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    
    NSLog(@"*************进入个人主页****************");
    [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(_model.userName)}];
}
+ (instancetype)shareInstance{
    static NewDianZanAndReplayCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([NewDianZanAndReplayCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

+ (CGFloat)cellHeightWithDiscussModel:(ZanAndReplayListModel *)model{
    NewDianZanAndReplayCell *cell = [self shareInstance];
    [cell configWithDiscussModel:model];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}


- (void)configWithDiscussModel:(ZanAndReplayListModel *)model{
    if (model) {
        _model = model;
        self.labelName.text = model.userName;
        self.labelUnread.hidden = !model.unread;
        //[self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[model.userAvatar hasPrefix:@"http"]?model.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.userAvatar andImageView:self.imageViewIcon andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
        /********************* 需要时间戳 *******************/
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:model.dateTime];
        
        if (ISNSStringValid(model.myContent)) {
            self.deletIV.hidden = YES;
            self.contentTop.constant = 12;
            self.labelReplay.text    = model.myContent;
            
        }else {
            self.deletIV.hidden = NO;
            self.contentTop.constant = 52;
            self.labelReplay.text    = [APPLanguageService wyhSearchContentWith:@"baoqiangaineirongyishanchu"];
        }
        
        if (self.type.integerValue == 1) {//新的点赞
         
            self.imageViewZan.hidden = NO;
            self.labelComment.text = @"";
            //变色
            [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:self.labelReplay and:model.myContent color:ThirdColor font:12.0f];
            
            
        }else {//新的评论
            self.imageViewZan.hidden = YES;
            self.labelComment.text = model.content;
            //变色
            [getUserCenter postNikeNameChangeUILabelRangeColor:self.labelComment and:model.content color:MainBg_Color font:16.0f];
            
            [getUserCenter sourcePostNikeNameChangeUILabelRangeColor:self.labelReplay and:model.myContent color:ThirdColor font:12.0f];
        }
        self.labelComment.lineBreakMode = NSLineBreakByTruncatingTail;
        self.labelReplay.lineBreakMode = NSLineBreakByTruncatingTail;
        WS(ws);
        self.labelComment.copyBlock = ^(NSString *commentID, NSString *userName) {
            if (ws.goToDetailBlock) {
                ws.goToDetailBlock(model);
            }
        };
        self.labelReplay.copyBlock = ^(NSString *commentID, NSString *userName) {
            if (ws.goToDetailBlock) {
                ws.goToDetailBlock(model);
            }
        };
    }
}

-(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat:@"%ld",timeSp*1000];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
