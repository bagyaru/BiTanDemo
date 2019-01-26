//
//  BTSearchBarView.h
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchResultBlock)(NSArray* result);

@interface BTSearchBarView : BTView

/**字典里面所以国家数组*/
@property (nonatomic,strong) NSMutableArray *allDataArray;
/**所有国家的数组*/
@property (nonatomic,strong) NSMutableArray *countryDataArray;
/**热门国家*/
@property (nonatomic,strong) NSMutableArray *hotCountryDataArray;
/**是否处于搜索中*/
@property (nonatomic,assign) BOOL isSearch;

-(void)getSearchResult:(SearchResultBlock)block;

@end
