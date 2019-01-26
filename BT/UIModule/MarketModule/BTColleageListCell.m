//
//  BTColleageListCell.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageListCell.h"

@interface BTColleageListCell()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UIView *indicatorV;

@end


@implementation BTColleageListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgImageV.layer.cornerRadius = 8.0f;
    self.bgImageV.layer.masksToBounds = YES;
    self.bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageV.clipsToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict{
    if(dict &&[dict isKindOfClass:[NSDictionary class]]){
        self.titleL.text = SAFESTRING(dict[@"name"]);
        NSString *image = SAFESTRING(dict[@"image"]);
        [self.bgImageV sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(image) hasPrefix:@"http"]?image:[NSString stringWithFormat:@"%@%@",PhotoImageURL,image]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    }
}

@end
