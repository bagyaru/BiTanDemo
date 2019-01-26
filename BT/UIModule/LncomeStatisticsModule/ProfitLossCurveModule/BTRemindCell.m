//
//  BTRemindCell.m
//  BT
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRemindCell.h"
#import "BTRemindShutRequest.h"
@interface BTRemindCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;
@property (weak, nonatomic) IBOutlet UIImageView *editImaV;

@end
@implementation BTRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = kHEXCOLOR(0xF9FBFC);
    self.bgView.layer.shadowColor = kHEXCOLOR(0x367DD7).CGColor;
    self.bgView.layer.shadowOpacity = 0.06f;
    self.bgView.layer.shadowOffset = CGSizeMake(7, 7);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BTRemindModel *)model{
    _model = model;
    self.timeLabel.text =[NSString stringWithFormat:@" %@",SAFESTRING(model.kind)];
    NSString *sign;
    if([SAFESTRING(model.remindType) isEqualToString:@"0"]){
        sign =@">";
    }else{
        sign =@"<";
    }
    
    NSString *unit =@"";
    NSString *firstUnit =@"";
    if([model.kind containsString:@"/"]){
        NSArray *arr =[model.kind componentsSeparatedByString:@"/"];
        firstUnit =[arr firstObject];
        unit =[arr lastObject];
    }
    if(SAFESTRING(model.remindPrice).length ==0){
        self.nameLabel.text =@"点击输入价格";
        self.editImaV.hidden = YES;
    }else{
        self.nameLabel.text =[NSString stringWithFormat:@"1 %@ %@ %.2f%@",firstUnit,sign,[SAFESTRING(model.remindPrice) floatValue],unit];
        self.editImaV.hidden = NO;
    }
    self.detailLabel.text =[NSString stringWithFormat:@"全网"];
    if([SAFESTRING(self.model.isReminded) isEqualToString:@"0"]){
        [self.remindBtn setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    }else{
        [self.remindBtn setImage:[UIImage imageNamed:@"unbell"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)remindBtnClick:(id)sender {
    if(SAFESTRING(self.model.remindPrice).length ==0){
        return;
    }
    if([SAFESTRING(self.model.isReminded) isEqualToString:@"0"]){
        self.model.isReminded =@"1";
    }else{
        self.model.isReminded =@"0";
    }
    BTRemindShutRequest *shutRequest =[[BTRemindShutRequest alloc] initWithRemind:self.model];
    [shutRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data){
            if([self.model.isReminded isEqualToString:@"0"]){
                [MBProgressHUD showMessageIsWait:@"提醒已打开" wait:YES];
            }else{
                [MBProgressHUD showMessageIsWait:@"提醒已关闭" wait:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRemind" object:nil];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

@end
