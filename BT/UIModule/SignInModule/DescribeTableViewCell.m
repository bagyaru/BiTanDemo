//
//  DescribeTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DescribeTableViewCell.h"

@interface DescribeTableViewCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *descLabel;

@end

@implementation DescribeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
//        self.imgView.backgroundColor = [UIColor redColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.mainLabel = [[UILabel alloc] init];
        [self addSubview:self.mainLabel];
        self.mainLabel.font = SYSTEMFONT(RELATIVE_WIDTH(16));
        self.mainLabel.textColor = FirstColor;
        self.mainLabel.textAlignment = NSTextAlignmentCenter;
        self.mainLabel.text = @"标题";
        
        
        self.descLabel = [UILabel new];
        [self addSubview:self.descLabel];
        self.descLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.descLabel.textColor = SecondColor;
        self.descLabel.preferredMaxLayoutWidth = ScreenWidth - 2*RELATIVE_WIDTH(15);
        self.descLabel.numberOfLines = 0;
        
        
        
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(RELATIVE_WIDTH(17));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(RELATIVE_WIDTH(51));
            make.height.mas_equalTo(RELATIVE_WIDTH(33));
        }];
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(RELATIVE_WIDTH(7));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(RELATIVE_WIDTH(22));
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainLabel.mas_bottom).offset(RELATIVE_WIDTH(15));
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-5));
        }];
        
//        [self.descLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//
//        [self.descLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    return self;
}


-(void)parseData:(DescModel*)model row:(NSInteger)row{
    self.imgView.image = [UIImage imageNamed:model.imgStr];
    self.mainLabel.text = model.mainTitle;
    
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:model.descTitle];
    
    //建立行间距模型
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //设置行间距
    [paragraphStyle setLineSpacing:14.0f];
    //把行间距模型加入NSMutableAttributedString模型
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.descTitle length])];
    self.descLabel.attributedText = attributedString;
    
}

@end
