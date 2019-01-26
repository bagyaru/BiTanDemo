//
//  BTICOFooterView.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOFooterView.h"

@interface BTICOFooterView()


@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation BTICOFooterView

- (void)setPhoto:(NSArray *)photoInfo{
    _photos = photoInfo;
    for(UIView *view in self.photoScrollView.subviews){
        [view removeFromSuperview];
    }
    for(NSInteger i =0 ; i< photoInfo.count ; i++){
        NSDictionary *dict = photoInfo[i];
        NSString *value = SAFESTRING(dict[@"value"]);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15+(200 +12) *i,0, 200, 190)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 200, 190)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageView];
        [self.photoScrollView addSubview:view];
        imageView.layer.cornerRadius = 8.0f;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = i + 1000;
        
        [self setViewRadius:view];
        [imageView setImageWithURL:[NSURL URLWithString:value] placeholder:nil];
    }
    self.photoScrollView.contentSize = CGSizeMake(30 +(200 +12) *photoInfo.count, 190);
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
}

//
- (void)setLink:(NSArray *)links{
    for(UIView *view in self.linkScrollView.subviews){
        [view removeFromSuperview];
    }
    self.maxWidth = 15;
    for(NSInteger i =0 ; i< links.count ; i++){
        NSDictionary *dict = links[i];
        NSString *str = SAFESTRING(dict[@"key"]);
        NSString *url = SAFESTRING(dict[@"value"]);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:kHEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        btn.titleLabel.font = FONTOFSIZE(12);
        CGSize size = [self calculateSizeWithFont:12 Text:str].size;
        CGFloat w = size.width + 10;
        btn.frame = CGRectMake(self.maxWidth, 2, w, 26);
        self.maxWidth += w + 12;
        btn.backgroundColor = MainBg_Color;
        btn.layer.cornerRadius = 13.0f;
        btn.layer.masksToBounds = YES;
        [self.linkScrollView addSubview:btn];
        [btn bk_addEventHandler:^(id  _Nonnull sender) {
            if(SAFESTRING(url).length >0){
                H5Node *node = [[H5Node alloc] init];
                node.webUrl = url;
                node.title = str;
                [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    self.linkScrollView.contentSize = CGSizeMake(self.maxWidth, 26);
    self.linkScrollView.showsHorizontalScrollIndicator = NO;
}

- (CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}

//
- (void)setViewRadius:(UIView*)view{
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    view.layer.shadowOpacity = 0.05f;
    view.layer.shadowRadius = 6.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
    NSMutableArray *images = @[].mutableCopy;
    for(NSInteger i =0 ; i< _photos.count ; i++){
        NSDictionary *dict = _photos[i];
        NSString *value = SAFESTRING(dict[@"value"]);
        [images addObject:value];
    }
    UIView *view = gesture.view;
    NSInteger tag = view.tag - 1000;
    if(images.count >0){
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:images andIndexPath:tag];
    }
}

@end
