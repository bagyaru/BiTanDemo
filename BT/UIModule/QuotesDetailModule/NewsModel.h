//
//  NewsModel.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject<YYModel>

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) long long createdAt;

@property (nonatomic, assign) BOOL favor;

@property (nonatomic, assign) long hotOrder;

@property (nonatomic, assign) long hotRecommend;

@property (nonatomic, strong) NSString *oid;

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, assign) long infoId;

@property (nonatomic, assign) long long issueDate;

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, assign) long recommend;

@property (nonatomic, strong) NSString *relevance;

@property (nonatomic, strong) NSString *source;

@property (nonatomic, strong) NSString *sourceUrl;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSString *timeFormat;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) long long updatedAt;

@property (nonatomic, assign) NSInteger viewCount;




@end
