//
//  GroupMenuCell.m
//  BT
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupMenuCell.h"

@interface GroupMenuCell()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorV;

@property (weak, nonatomic) IBOutlet UIImageView *colorView;

@end

@implementation GroupMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.colorView.layer.cornerRadius = 5;
    self.colorView.layer.masksToBounds = YES;
}

- (void)setListModel:(BTGroupListModel *)listModel{
    if(listModel){
        _listModel = listModel;
        _nameL.text = listModel.groupName;
        if(listModel.isSelected){
            _indicatorV.hidden = NO;
        }else{
            _indicatorV.hidden = YES;
        }
        if([listModel.groupName isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
            self.colorView.backgroundColor = MainBg_Color;
        }else{
            self.colorView.backgroundColor = kHEXCOLOR(0xFFA700);
        }
    }
}


@end
