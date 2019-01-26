//
//  SearchResult.m
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchResult.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@implementation SearchResult
/**
 *  获取搜索的结果集
 *
 *  @param searchText 搜索内容
 *
 *  @return 返回结果集
 */
+ (NSMutableArray*)getSearchResultBySearchText:(NSString*)searchText dataArray:(NSMutableArray*)dataArray
{
    NSMutableArray *searchResults = [NSMutableArray array];
    //搜索框中的搜索项不包含中文     ------ 拼音搜索
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<dataArray.count; i++) {
            
            //数组中的元素包含中文 中文转拼音 ----- 根据拼音来得到数组中是否包含
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]]) {
                
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
            else {
                NSRange titleResult=[dataArray[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
        //搜索项中含有中文   根据中文来搜索
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (NSString *tempStr in dataArray) {
            NSRange titleResult=[tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
            }
        }
    }
    return searchResults;
}


@end
