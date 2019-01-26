//
//  BTTransmitPostView.m
//  BT
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTransmitPostView.h"
#import "WBStatusLayout.h"
@interface BTTransmitPostView()

@property (nonatomic, strong) UIImageView *imageV;
//@property (nonatomic, strong) YYLabel *yy_label;

@property (nonatomic, strong) UILabel *yy_label;

@end

@implementation BTTransmitPostView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = kHEXCOLOR(0xF5F5F5);
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(5);
        make.width.height.mas_equalTo(50.0f);
    }];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _yy_label = [[UILabel alloc] initWithFrame:CGRectZero];
    _yy_label.lineBreakMode = NSLineBreakByTruncatingTail;
    //    _yy_label.numberOfLines = 0;  //设置多行显示
    _yy_label.textColor = FirstColor;
    [self addSubview:_yy_label];
    [_yy_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(65);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}

- (void)setModel:(BTPostMainListModel *)model{
    _model = model;
    if(model){
        
        if(model.type == 3){//转发贴
            BTPostMainListModel *sourceModel = model.sourcePostModel;
            if([sourceModel.images isKindOfClass:[NSString class]]){
                sourceModel.images = @[];
            }
            if(sourceModel.images.count ==0){
                self.imageV.hidden = YES;
                [_yy_label mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.left.equalTo(self).offset(20);
                }];
            }else{
                NSString *imageUrl = SAFESTRING([sourceModel.images firstObject]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:50*2 andHeight:50*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                
                [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
                self.imageV.hidden = NO;
            }
            
            NSString *name = [NSString stringWithFormat:@"@%@:",sourceModel.nickName];
            NSString *str = [NSString stringWithFormat:@"%@%@",name,sourceModel.content];
            NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: str attributes:@{NSFontAttributeName:FONTOFSIZE(16.0f)}];
            
            
            NSRange range = [str rangeOfString:name];
            [text setTextHighlightRange:range color:MainBg_Color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"xxx协议被点击了");
            }];
            _yy_label.text = str;  //设置富文本
        }else{
            NSString *name = [NSString stringWithFormat:@"@%@:",model.nickName];
            NSString *content = model.content;
            NSString *str = [NSString stringWithFormat:@"%@%@",name,content];
            NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: str attributes:@{NSFontAttributeName:FONTOFSIZE(16.0f)}];
            NSRange range = [str rangeOfString:name];
            [text setTextHighlightRange:range color:MainBg_Color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"xxx协议被点击了");
            }];
            _yy_label.text = str;  //设置富文本
            if([model.images isKindOfClass:[NSString class]]){
                model.images = @[];
            }
            if(model.images.count == 0){
                self.imageV.hidden = YES;
                [_yy_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(20);
                    make.right.equalTo(self.mas_right).offset(-10);
                }];
            }else{
                NSString *imageUrl = SAFESTRING([model.images firstObject]);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:50*2 andHeight:50*2];
                imageUrl = [NSString stringWithFormat:@"%@?%@",[imageUrl hasPrefix:@"http"]?imageUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl],str];
                [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
                self.imageV.hidden = NO;
            }
        }
        
        [getUserCenter postNikeNameChangeUILabelRangeColor:_yy_label and:_yy_label.text color:FirstColor font:16];
         _yy_label.lineBreakMode = NSLineBreakByTruncatingTail;
       
    }
}
@end
