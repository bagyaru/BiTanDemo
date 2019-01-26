//
//  NewCurrencyOnSaleTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewCurrencyOnSaleTableViewCell.h"

@interface NewCurrencyOnSaleTableViewCell ()

/**货币名label*/
@property (nonatomic,strong) UILabel *nameLabel;
/**时间label*/
@property (nonatomic,strong) UILabel *timeLabel;
/**成交额label*/
@property (nonatomic,strong) UILabel *amountLabel;
/**最新价上面label*/
@property (nonatomic,strong) UILabel *topPriceLabel;
/**最新价下面label*/
@property (nonatomic,strong) UILabel *bottomPriceLabel;
/**涨跌幅label*/
@property (nonatomic,strong) UIButton *riseFallButton;
/**下划线View*/
@property (nonatomic,strong) UIView *lineView;

@end

@implementation NewCurrencyOnSaleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //货币名label初始化
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(RELATIVE_WIDTH(12));
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        self.nameLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(15)];
        self.nameLabel.textColor = FirstColor;
        self.nameLabel.text = @"ETH";
        
        //时间label初始化
//        self.timeLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:self.timeLabel];
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLabel.mas_right).offset(RELATIVE_WIDTH(1));
//            make.top.equalTo(self).offset(RELATIVE_WIDTH(18));
//            make.height.mas_equalTo(RELATIVE_WIDTH(14));
//        }];
//        self.timeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(10)];
//        self.timeLabel.textColor = kHEXCOLOR(0xAAAAAA);
//        self.timeLabel.text = @"1天前";
        
        //成交额label
        self.amountLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            //make.top.equalTo(self.nameLabel.mas_bottom);
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-12));
            make.height.mas_equalTo(RELATIVE_WIDTH(14));
        }];
        self.amountLabel.font = LastSmallFont;
        self.amountLabel.textColor = ThirdColor;
        self.amountLabel.text = @"额：6546";
        
        //最新价label
        self.topPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.topPriceLabel];
        self.topPriceLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.topPriceLabel.textColor = FirstColor;
        self.topPriceLabel.text = @"¥4267.3431234";
        
        
        self.bottomPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.bottomPriceLabel];
        self.bottomPriceLabel.font = self.amountLabel.font;
        self.bottomPriceLabel.textColor = self.amountLabel.textColor;
        self.bottomPriceLabel.text = @"$4267.3431234";
        
        
        
        //涨跌幅label
        self.riseFallButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.riseFallButton];
        self.riseFallButton.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        self.riseFallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.riseFallButton setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.riseFallButton.backgroundColor = CFallColor;
        ViewRadius(self.riseFallButton, RELATIVE_WIDTH(1));
        [self.riseFallButton setTitle:@"-32.88%" forState:UIControlStateNormal];
        
        //添加下划线
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = SeparateColor;
        
        
        [self.topPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(168));
            make.right.equalTo(self.riseFallButton.mas_left).offset(RELATIVE_WIDTH(-5));
            make.top.equalTo(self.nameLabel);
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        [self.bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amountLabel);
            make.left.equalTo(self.topPriceLabel).offset(RELATIVE_WIDTH(1));
            make.height.equalTo(self.amountLabel);
        }];
        
        [self.riseFallButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(RELATIVE_WIDTH(72));
            make.height.mas_equalTo(RELATIVE_WIDTH(28));
        }];
        
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-1));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
    }
    return self; 
}


-(void)parseData:(NewCurrencyModel*)model{
    
    NSString *unit =[BTHelperMethod signStr];
    self.nameLabel.text = SAFESTRING(model.kind);
    self.amountLabel.text = [NSString stringWithFormat:@"%@：%@",[APPLanguageService sjhSearchContentWith:@"liang"],[DigitalHelperService transformWith:model.volume]];
    self.topPriceLabel.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:kIsCNY?model.priceCNY:model.priceUSD]];
    self.bottomPriceLabel.text = [NSString stringWithFormat:@"%@%@",kIsCNY?@"$":@"¥",[DigitalHelperService isTransformWithDouble:kIsCNY?model.priceUSD:model.priceCNY]];
    
    if (model.rose <=  0) {
        [self.riseFallButton setTitle:[NSString stringWithFormat:@"-%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
        self.riseFallButton.backgroundColor = CFallColor;
        if (model.rose == 0) {
            self.riseFallButton.backgroundColor = CNoChangeColor;
            [self.riseFallButton setTitle:[NSString stringWithFormat:@"%@%%",@(-model.rose).p2fString] forState:UIControlStateNormal];
        }
    }else{
        [self.riseFallButton setTitle:[NSString stringWithFormat:@"+%@%%",@(model.rose).p2fString] forState:UIControlStateNormal];
        self.riseFallButton.backgroundColor = CRiseColor;
        
    }
    
    //设置变动颜色
    switch (model.type) {
//        case D_UpAndDownTypeNoUpAndDown:
//            
//            self.topPriceLabel.textColor = CBlackColor;
//            
//            break;
        case D_UpAndDownTypeUp:
            
            self.topPriceLabel.textColor = CGreenColor;
            break;
        case D_UpAndDownTypeDown:
            
            self.topPriceLabel.textColor = CRedColor;
            break;
            
        default:
            break;
    }
    
}




@end
