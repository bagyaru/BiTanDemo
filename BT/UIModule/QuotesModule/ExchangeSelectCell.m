//
//  ExchangeSelectCell.m
//  BT
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeSelectCell.h"

@interface ExchangeSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *sortL;

@property (weak, nonatomic) IBOutlet UILabel *turnoverL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftCons;

@end

@implementation ExchangeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
     ViewRadius(self.sortL, 2);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(BTExchangeListModel *)model{
    if(model){
        if(model.isSearch){
            _sortL.hidden = YES;
            _imageLeftCons.constant = 15.0f;
            [AppHelper addLeftLineWithParentView:self];
        }else{
            _sortL.text = SAFESTRING(@(self.index+1));
        }
        if(kIsCNY){
            self.turnoverL.text = [DigitalHelperService transformWith:model.turnoverCNY];
        }else{
            self.turnoverL.text =[DigitalHelperService transformWith:model.turnoverUSD];
        }
        
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            _nameL.text = model.exchangeName;
        }else{
            _nameL.text = SAFESTRING(model.exchangeNameEN).length>0?SAFESTRING(model.exchangeNameEN): model.exchangeCode;
        }
        model.icon = SAFESTRING(model.icon);
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:22*2 andHeight:22*2];
        NSString *url =[NSString stringWithFormat:@"%@?%@",model.icon,str];
        NSString *imageUrl = [model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
        [self.selectImageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_exchange"]];
    }
}


@end
