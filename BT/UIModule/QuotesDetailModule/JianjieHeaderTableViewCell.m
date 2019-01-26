//
//  JianjieHeaderTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JianjieHeaderTableViewCell.h"
@interface JianjieHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet BTLabel *nameL;

@property (weak, nonatomic) IBOutlet BTLabel *contentL;


@end

@implementation JianjieHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [AppHelper addLeftLineWithParentView:self.contentView];
}

- (void)setModel:(BTJianjieModel *)model{
    if(model){
        if(model.isNoEn){
            _nameL.text = SAFESTRING(model.name);
            _nameL.textColor = kHEXCOLOR(0x333333);
        }else{
            _nameL.fixText = SAFESTRING(model.name);
            _nameL.textColor = kHEXCOLOR(0x999999);
        }
        
        _contentL.text = SAFESTRING(model.content);
        NSArray *colorArr = @[ @"faxingjiage",
                               @"bankuaigainian",
                               @"zongchoujiage",
                               @"mujizijin",
                               @"icozongliang"
                               ];
        if([colorArr containsObject:model.name]){
            _contentL.textColor = MainBg_Color;
        }else{
            if([model.name isEqualToString:@"faxingzhangdie"]){
                _contentL.textColor = kHEXCOLOR(0x07AE40);
            }else{
                _contentL.textColor = kHEXCOLOR(0x333333);
            }
        }
        
//        if([model.name isEqualToString:@"xingmingmingcheng"]){
//            _nameL.textColor = TextColor;
//        }else{
//            _nameL.textColor = kHEXCOLOR(0x999999);
//        }
    }
}

@end
