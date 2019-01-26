//
//  BTConfig.h
//  BT
//
//  Created by apple on 2018/1/16.¯
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//打包- 生产环境
#define BTDomainProduct        @"http://api.bitane.io/"
#define BTDomainH5Product      @"https://m.bitane.io/"
#define Post_BTDomainH5Product @"http://statics.bitane.io/"
#define Info_BTDomainH5Product @"http://image.muzhao888.com/share"

//打包 - dev环境
//#define BTDomainProduct        @"http://183.129.150.2:8777/"
//#define BTDomainH5Product      @"http://183.129.150.2:8081/"
//#define Post_BTDomainH5Product @"http://183.129.150.2:8085/"
//#define Info_BTDomainH5Product @"http://image.muzhao888.com/share_dev"

// 真机测试 - dev环境
//#define BTDomainDev        @"http://183.129.150.2:8777/"
// 真机测试-生产环境
#define BTDomainDev         @"http://api.bitane.io/"

@interface BTConfig : NSObject

+ (BTConfig *)sharedInstance;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *h5domain;
@property (nonatomic, copy) NSString *Info_h5domain;
@property (nonatomic, copy) NSString *Post_h5domain;
@end
