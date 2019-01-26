//
//  TagsFrame.m
//  TagsDemo
//
//  Created by Administrator on 16/1/21.
//  Copyright © 2016年 Administrator. All rights reserved.
//
//  计算多个标签的位置
//  标签根据文字自适应宽度
//  每行超过的宽度平均分配给每个标签
//  每行标签左右对其



#import "TagsFrame.h"

@implementation TagsFrame

- (id)init
{
    self = [super init];
    if (self) {
        _tagsFrames = [NSMutableArray array];
        _tagsMinPadding = 10;
        _tagsMargin = 10;
        _tagsLineSpacing = 5;
    }
    return self;
}

- (void)setTagsArray:(NSArray *)tagsArray{
    _tagsArray = tagsArray;
    CGFloat btnX = ScreenWidth -100; //_tagsMargin;
    CGFloat btnW = 0;
    
    CGFloat nextWidth = 0;  // 下一个标签的宽度
    CGFloat moreWidth = 0;  // 每一行多出来的宽度
    
    /**
     *  每一行的最后一个tag的索引的数组和每一行多出来的宽度的数组
     */
    NSMutableArray *lastIndexs = [NSMutableArray array];
    NSMutableArray *moreWidths = [NSMutableArray array];
    
    for (NSInteger i=0; i<_tagsArray.count; i++) {
        NSDictionary *dict = _tagsArray[i];
        NSString *title = @"";
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            title =SAFESTRING(dict[@"chineseTitle"]);
        }else{
            title =SAFESTRING(dict[@"englishTitle"]);
        }
        btnW = [self sizeWithText:title font:TagsTitleFont].width; //+ _tagsMinPadding * 2;
        
        if (i < _tagsArray.count-1) {
            NSDictionary *info = _tagsArray[i+1];
            NSString *title1 = @"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                title1 =SAFESTRING(info[@"chineseTitle"]);
            }else{
                title1 =SAFESTRING(info[@"englishTitle"]);
            }
            
            nextWidth = [self sizeWithText:title1 font:TagsTitleFont].width ;//+ _tagsMinPadding * 2;
        }
//        CGFloat nextBtnX = btnX - btnW - _tagsMargin;
        
        // 如果下一个按钮，标签最右边则换行
        if ( btnX  < 100) {
            // 计算超过的宽度
            moreWidth = 100 - btnX;
            
            [lastIndexs addObject:[NSNumber numberWithInteger:i]];
            [moreWidths addObject:[NSNumber numberWithFloat:moreWidth]];
            
            btnX = ScreenWidth - 100.0f;
            
           
        }else{
            btnX -= (btnW + _tagsMargin);
        }
        // 如果是最后一个且数组中没有，则把最后一个加入数组
        if (i == _tagsArray.count -1) {
            if (![lastIndexs containsObject:[NSNumber numberWithInteger:i]]) {
                [lastIndexs addObject:[NSNumber numberWithInteger:i]];
                [moreWidths addObject:[NSNumber numberWithFloat:0]];
            }
        }
    }
    
    NSInteger location = 0;  // 截取的位置
    NSInteger length = 0;    // 截取的长度
    CGFloat averageW = 0;    // 多出来的平均的宽度
    
    CGFloat tagW = 0;
    CGFloat tagH = 17;
    
    for (NSInteger i=0; i<lastIndexs.count; i++) {
        
        NSInteger lastIndex = [lastIndexs[i] integerValue];
        if (i == 0) {
            length = lastIndex + 1;
        }else{
            length = [lastIndexs[i] integerValue]-[lastIndexs[i-1] integerValue];
        }
        // 从数组中截取每一行的数组
        NSArray *newArr = [_tagsArray subarrayWithRange:NSMakeRange(location, length)];
        location = lastIndex + 1;
        
        averageW = [moreWidths[i] floatValue]/newArr.count;
        
        CGFloat tagX = ScreenWidth - 100.0f; //_tagsMargin;
        CGFloat tagY = _tagsLineSpacing + (_tagsLineSpacing + tagH) * i;
    
        for (NSInteger j=0; j<newArr.count; j++) {
            
            NSDictionary *info = newArr[j];
            NSString *title2 = @"";
            if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                title2 =SAFESTRING(info[@"chineseTitle"]);
            }else{
                title2 =SAFESTRING(info[@"englishTitle"]);
            }
            
            tagW = [self sizeWithText:title2 font:TagsTitleFont].width; //+ _tagsMinPadding * 2 + averageW;
            
            CGRect btnF = CGRectMake(tagX - tagW, tagY, tagW, tagH);
            
            [_tagsFrames addObject:NSStringFromCGRect(btnF)];
            
            //tagX += (tagW+_tagsMargin);
            
            tagX -= (tagW+_tagsMargin);
            
        }
    }
    
    _tagsHeight = (tagH + _tagsLineSpacing) * lastIndexs.count + _tagsLineSpacing;
    
}

/**
 *  单行文本数据获取宽高
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 宽高
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text sizeWithAttributes:attrs];
}

@end
