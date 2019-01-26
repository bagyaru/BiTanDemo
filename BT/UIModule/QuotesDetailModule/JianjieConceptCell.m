//
//  JianjieConceptCell.m
//  BT
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JianjieConceptCell.h"

@interface JianjieConceptCell()

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *labelArr;


@end


@implementation JianjieConceptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelArr = @[].mutableCopy;
//    [AppHelper addLeftLineWithParentView:self];
}

- (void)setModel:(BTJianjieModel *)model{
    if(model){
        _nameL.text = model.content;
        
        //        if(model.detailName.length>0){
        //            _conceptL.hidden = NO;
        //            _conceptL.backgroundColor = LineColor;
        //            CGSize size = [model.detailName boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONTOFSIZE(12.0f)} context:nil].size;
        //            self.conceptL.text = SAFESTRING(model.detailName);
        //            self.conceptL.layer.cornerRadius = 10.0f;
        //            self.constantWidth.constant =  size.width + 18.0f;
        //            self.conceptL.layer.masksToBounds = YES;
        //        }else{
        //            _conceptL.hidden = YES;
        //        }
    }
}

- (void)setInfo:(NSArray *)info{
    _info = info;
    if(info.count>0){
        if(self.labelArr.count){
            for(UILabel *label in self.labelArr){
                [label removeFromSuperview];
            }
        }
        self.labelArr = @[].mutableCopy;
        NSUInteger i =0;
        UILabel *preLabel;
        for(NSDictionary *dict in info){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            NSString *name = dict[@"name"];
            CGSize size = [SAFESTRING(name) boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONTOFSIZE(12.0f)} context:nil].size;
            label.text = SAFESTRING(name);
            label.layer.cornerRadius = 10.0f;
            label.layer.borderColor = SeparateColor.CGColor;
            label.layer.borderWidth = 0.5;
            label.layer.masksToBounds = YES;
            label.textColor = kHEXCOLOR(0x999999);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONTOFSIZE(12.0f);
            
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if(i ==0){
                    make.bottom.equalTo(self.mas_bottom).offset(-3);
                    make.left.equalTo(self).offset(15);
                    make.width.mas_equalTo(size.width+20.0f);
                    make.height.mas_equalTo(20.0f);
                }else{
                    make.centerY.equalTo(preLabel.mas_centerY);
                    make.left.equalTo(preLabel.mas_right).offset(15);
                    make.width.mas_equalTo(size.width+20.0f);
                    make.height.mas_equalTo(20.0f);
                }
                
            }];
            [self.labelArr addObject:label];
            label.tag = i;
            UITapGestureRecognizer *tapConceptGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcept:)];
            [label addGestureRecognizer:tapConceptGes];
            label.userInteractionEnabled = YES;
            
            preLabel = label;
            i++;
            
        }
    }
}
- (void)tapConcept:(UIGestureRecognizer*)gesture{
    UILabel *label = (UILabel*)gesture.view;
    if([self.delegate respondsToSelector:@selector(tapConcept:)]){
        [self.delegate tapConcept:label.tag];
    }
}

@end
