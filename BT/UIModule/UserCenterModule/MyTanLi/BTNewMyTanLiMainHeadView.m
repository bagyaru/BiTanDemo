//
//  BTNewMyTanLiMainHeadView.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewMyTanLiMainHeadView.h"
#import "BTOneTanLiQianLiListView.h"

@interface BTNewMyTanLiMainHeadView()
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *tanLiBgImageV;
@property (weak, nonatomic) IBOutlet UIButton *mxRightBtn;

@property (weak, nonatomic) IBOutlet UIButton *rwRightbtn;


@end
@implementation BTNewMyTanLiMainHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    CGFloat width;
    if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
        width = 114;
    }else{
        width = 150;
    }
    CGRect frame = CGRectMake(0, 0, width, 24);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(12,12)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.recordView.layer.mask = maskLayer;
    if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
        self.widthCons.constant = 114.0f;
        self.recordViewWidth.constant = 114.0f;
    }else{
        self.widthCons.constant = 150;
        self.recordViewWidth.constant = 150;
    }
    self.tanLiBgImageV.image = [UIImage imageNamed:@"ic_suohuotanli-bg"];
    self.labelQiaoDaoProgress.tag = 11111;
    [self.buttonQianDao setImage:IMAGE_NAMED(@"个人-开关-关闭") forState:UIControlStateNormal];
    [self.buttonQianDao setImage:IMAGE_NAMED(@"个人-开关-开启") forState:UIControlStateSelected];
    [self.mxRightBtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
    [self.rwRightbtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
}

-(void)setMyTPModel:(BTMyTPModel *)myTPModel {
    
    if (myTPModel) {
        _myTPModel = myTPModel;
        self.labelTotalTP.text = [NSString stringWithFormat:@"%ld",myTPModel.totalCoin];
        self.labelTodayGetTP.text = [NSString stringWithFormat:@"%@：%ld",[APPLanguageService wyhSearchContentWith:@"jinrisuohuotanli"],myTPModel.todayCoin];
    }
}
-(void)setTPJiangLiListArray:(NSMutableArray *)TPJiangLiListArray {
    
    if (TPJiangLiListArray.count > 0) {
        
        for (int i = 0; i < TPJiangLiListArray.count; i++) {
            BTTanLiQianLiListModel *model = TPJiangLiListArray[i];
            NSLog(@"%d ==%ld",i/7*70,TPJiangLiListArray.count);
            BTOneTanLiQianLiListView *oneView = [BTOneTanLiQianLiListView loadFromXib];
            oneView.frame = CGRectMake(ScreenWidth/7*(i%7), i/7*70, ScreenWidth/7, 70);
            oneView.labelQianDao.text = [NSString stringWithFormat:@"%ld",model.reward];
            if (i == 6 || i == 13 || i == 20) {
                oneView.imageViewQianDao.image = [UIImage imageNamed:@"ic_bigtanli-weilingqu"];
            }else {
                oneView.imageViewQianDao.image = [UIImage imageNamed:@"ic_tanli-weilingqu"];
            }
            oneView.tag = 3000+i;
            [self.viewTPJiangLiList addSubview:oneView];
            [self.imgBgViewArr addObject:oneView];
        }
    }
}
-(void)setModel:(QianDaoModel *)model {
    if (model) {
        _model = model;
        self.buttonQianDao.selected = [[NSUserDefaults standardUserDefaults] boolForKey:continueQianDao];
        for (int i = 0; i<model.day; i++) {
            BTOneTanLiQianLiListView *view = self.imgBgViewArr[i];
            if (i == 6 || i == 13 || i == 20) {
                view.imageViewQianDao.image = [UIImage imageNamed:@"ic_bigtanli-yilingqu"];
            }else {
                view.imageViewQianDao.image = [UIImage imageNamed:@"ic_tanli-yilingqu"];
            }

            view.labelQianDao.text = [APPLanguageService wyhSearchContentWith:@"yiling"];
            view.labelQianDao.textColor = kHEXCOLOR(0x111210);
        }
        NSInteger teShuQiangLiDay = 7-model.day%7;
        NSString *dayStr = [[[APPLanguageService wyhSearchContentWith:@"QiaoDaoProgressWenAn"] stringByReplacingOccurrencesOfString:@"88" withString:[NSString stringWithFormat:@"%ld",model.day]] stringByReplacingOccurrencesOfString:@"99" withString:[NSString stringWithFormat:@"%ld",teShuQiangLiDay]];
        self.labelQiaoDaoProgress.text = dayStr;
        [getUserCenter changeUILabelColor:self.labelQiaoDaoProgress and:[NSString stringWithFormat:@"%ld",model.day] and:[NSString stringWithFormat:@"%ld",teShuQiangLiDay] color:MainBg_Color];
    }
}

//历史记录
- (IBAction)tanLiHistoryBtnClick:(UIButton *)sender {
    [MobClick event:@"tanli_history"];
    [BTCMInstance pushViewControllerWithName:@"BTTanliDetailListVC" andParams:nil];
}

//探力打赏
- (IBAction)tpRewardClick:(id)sender {
    [MobClick event:@"tanli_dashang"];
    [BTCMInstance pushViewControllerWithName:@"BTTPRewardVC" andParams:nil];
}

//更多任务
- (IBAction)moreRenWuBtnClick:(UIButton *)sender {
    [MobClick event:@"tanli_task"];
    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiChild" andParams:@{@"currentPage":@(1)}];
}
//连续签到
- (IBAction)lianXuQianDaoBtnClick:(UIButton *)sender {
    [MobClick event:@"tanli_checkin_notice"];
    sender.selected = !sender.selected;
    //连续签到按钮点击
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:continueQianDao];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSMutableArray *)imgBgViewArr {
    
    if (!_imgBgViewArr) {
        _imgBgViewArr = [NSMutableArray array];
    }
    return _imgBgViewArr;
}
@end
