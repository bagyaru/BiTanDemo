//
//  XHFootCell.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XHFootCell.h"
@interface XHFootCell()

@property (nonatomic, strong) YYLabel *yyLabel;

@end

@implementation XHFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _yyLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_yyLabel];
    _yyLabel.numberOfLines = 0;
    [_yyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    _yyLabel.font = FONTOFSIZE(14.0f);
    _yyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _yyLabel.textAlignment = NSTextAlignmentLeft;
    _yyLabel.textColor = FirstColor;
}

- (void)setContent:(NSString *)content{
    _content = content;
    if(SAFESTRING(content).length >0){
        _yyLabel.attributedText = [self p_htmlChangeString:content];
//        _yyLabel.font = FONTOFSIZE(12.0f);
    }
}

- (NSMutableAttributedString *)p_htmlChangeString:(NSString *)aString{
    
    NSString *string =@"";
    if(isNightMode){
        string = [NSString stringWithFormat:@"<span style='color: rgb(186,205,230)'>%@</span>",aString];
    }else{
        string = [NSString stringWithFormat:@"<span style='color: rgb(51,51,51)'>%@</span>",aString];
    }
   
    NSMutableAttributedString *oneString = [[NSMutableAttributedString alloc]initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:FONTOFSIZE(14),NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone],NSForegroundColorAttributeName:[UIColor whiteColor]} documentAttributes:nil error:nil];
    [oneString setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleNone] range:oneString.rangeOfAll];
    [oneString enumerateAttributesInRange:oneString.rangeOfAll
                                  options:0
                               usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                                   
                                   NSURL *link = [attrs objectForKey:NSLinkAttributeName];
                                   
                                   if (link)
                                   {
                                       
                                       //链接变颜色
                                       [oneString setTextHighlightRange:range
                                                                  color:MainBg_Color
                                                        backgroundColor:[UIColor whiteColor]
                                                              tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                                                  
                                                                  H5Node *node = [[H5Node alloc] init];
                                                                  node.webUrl = link.absoluteString;
                                                                  [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                                                                  
                                                              }];
                                   }
                                   
                                   
                               }];
    
    return oneString;
    
}


@end
