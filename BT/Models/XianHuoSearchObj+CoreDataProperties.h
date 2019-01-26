//
//  XianHuoSearchObj+CoreDataProperties.h
//  
//
//  Created by apple on 2018/1/29.
//
//

#import "XianHuoSearchObj+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface XianHuoSearchObj (CoreDataProperties)

+ (NSFetchRequest<XianHuoSearchObj *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *exchangeCode;
@property (nullable, nonatomic, copy) NSString *exchangeName;
@property (nonatomic) int64_t exchangeId;
@property (nullable, nonatomic, copy) NSString *exchangeLabel;

@end

NS_ASSUME_NONNULL_END
