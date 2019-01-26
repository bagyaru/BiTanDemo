//
//  TagsViewCell.m
//  TagsDemo
//
//  Created by Administrator on 16/1/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "TagsViewCell.h"

@interface TagsViewCell()

@property (nonatomic, strong)BTLabel *nameL;
@end

@implementation TagsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _nameL = [[BTLabel alloc] initWithFrame:CGRectZero];
    _nameL.font = FONTOFSIZE(12.0f);
    _nameL.textColor = kHEXCOLOR(0x666666);
    [self.contentView addSubview:_nameL];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(6);
        make.height.mas_equalTo(17.0f);
    }];
}

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"tags";
    TagsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TagsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setTagsFrame:(TagsFrame *)tagsFrame{
    _nameL.fixText = SAFESTRING(tagsFrame.title);
    for(UIView *view in self.contentView.subviews){
        if(![view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    _tagsFrame = tagsFrame;
    CGFloat width = ScreenWidth - 100.0f;
    //    if(tagsFrame.tagsArray.count<3){
    //        for(NSDictionary *dict in tagsFrame.tagsArray){
    //            NSString *title = @"";
    //            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
    //                title =SAFESTRING(dict[@"chineseTitle"]);
    //            }else{
    //                title =SAFESTRING(dict[@"englishTitle"]);
    //            }
    //            width += [self sizeWithText:title font:TagsTitleFont].width+15;
    //        }
    //
    //    }else{
//    width = ;
    //    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(width);
    }];
    for (NSInteger i=0; i<tagsFrame.tagsArray.count; i++) {
        
        NSDictionary *dict = tagsFrame.tagsArray [i];
        NSString *title = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            title =SAFESTRING(dict[@"chineseTitle"]);
        }else{
            title =SAFESTRING(dict[@"englishTitle"]);
        }
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:title forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.backgroundColor = [UIColor whiteColor];
        [tagsBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
       // tagsBtn.layer.borderWidth = 1;
        tagsBtn.tag = i;
        [tagsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //tagsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //tagsBtn.layer.cornerRadius = 4;
        tagsBtn.layer.masksToBounds = YES;
        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        [view addSubview:tagsBtn];
    }
}

- (void)btnClick:(UIButton*)btn{
    if([self.delegate respondsToSelector:@selector(TagsViewCellClickIndex:)]){
        [self.delegate TagsViewCellClickIndex:btn.tag];
    }
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text sizeWithAttributes:attrs];
}

@end
