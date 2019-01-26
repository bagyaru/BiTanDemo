//
//  HistorySectionView.m
//  BT
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistorySectionView.h"

@interface HistorySectionView ()

@property (weak, nonatomic) IBOutlet BTLabel *labelName;


@property (weak, nonatomic) IBOutlet BTButton *btnClear;

@property (weak, nonatomic) IBOutlet UIView *viewBG;

@end

@implementation HistorySectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    UIView *iv = [[UIView alloc] init];
    iv.backgroundColor = [UIColor whiteColor];
    self.backgroundView = iv;
    self.viewBG.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
    self.labelName.textColor = FirstColor;
}

- (void)setType:(SectionViewType)type{
    _type = type;
    if (self.type == SectionViewTypeHistory) {
        self.btnClear.hidden = NO;
        self.labelName.fixText = @"lishisousuo";
    }else if (self.type == SectionViewTypeResult){
        self.btnClear.hidden = YES;
        self.labelName.fixText = @"sousuojieguo";
    }else {
        self.btnClear.hidden = YES;
        self.labelName.localText = @"renmensousuo";
    }
}

- (IBAction)clickeBtnClear:(id)sender {
    if (self.clearBlock) {
        self.clearBlock();
    }
}

@end
