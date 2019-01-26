//
//  BTTitleView.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNaviView.h"

@interface BTNaviView ()


@property (weak, nonatomic) IBOutlet BTLabel *labelTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnOption;


@end

@implementation BTNaviView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userAvatar.layer.cornerRadius = 13.0f;
    self.userAvatar.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 4.0f;
    self.rightBtn.layer.masksToBounds = YES;
}

- (void)showInViewWith:(UIView *)parentView{
    if (parentView) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        [parentView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView).insets(insets);
        }];
    }
}

- (void)setTitle:(NSString *)title{
    self.labelTitle.text = title;
}

- (void)setFixTitle:(NSString *)fixTitle{
    self.labelTitle.fixText = fixTitle;
}

- (void)setIsHiddenRight:(BOOL)isHiddenRight{
    _isHiddenRight = isHiddenRight;
    self.btnOption.hidden = _isHiddenRight;
}

- (void)setImageRight:(UIImage *)imageRight{
    _imageRight = imageRight;
    [self.btnOption setImage:imageRight forState:UIControlStateNormal];
}

- (IBAction)clickedPop:(id)sender {
    
    [BTCMInstance popViewController:nil];
}

- (IBAction)clickedBtnAdd:(id)sender {
    if (self.addHandleBlock) {
        self.addHandleBlock();
    }
}


@end
