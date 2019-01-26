//
//  BTIntroWebsiteCell.m
//  BT
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTIntroWebsiteCell.h"
#import "BTWebsiteItemView.h"
@interface BTIntroWebsiteCell()

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation BTIntroWebsiteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWebsites:(NSArray *)websites{
    _websites = websites;
    if(websites.count >0){
        for(UIView *view in self.mScrollView.subviews){
            [view removeFromSuperview];
        }
        self.maxWidth = 15;
        for(NSInteger i =0 ; i< websites.count ; i++){
            NSDictionary *dict = websites[i];
            NSString *url = SAFESTRING(dict[@"url"]);
            NSString *title = @"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                title =SAFESTRING(dict[@"chineseTitle"]);
            }else{
                title =SAFESTRING(dict[@"englishTitle"]);
            }
            CGSize size = [self calculateSizeWithFont:12 Text:title].size;
            CGFloat w = size.width;
            if(w < 34.0f){
                w = 34;
            }
            BTWebsiteItemView *itemView = [[BTWebsiteItemView alloc] initWithFrame:CGRectMake(self.maxWidth, 0, w, self.frame.size.height)];
            self.maxWidth += w + 30;
            [self.mScrollView addSubview:itemView];
            itemView.data = dict;
            itemView.completion = ^{
                if(SAFESTRING(url).length >0){
                    H5Node *node = [[H5Node alloc] init];
                    node.webUrl = url;
                    node.title = title;
                    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                }
            };
        }
        self.mScrollView.contentSize = CGSizeMake(self.maxWidth, 0);
        self.mScrollView.showsHorizontalScrollIndicator = NO;
    }
}

//
- (CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}
@end
