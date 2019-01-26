//
//  QiHuoSearchObj+CoreDataProperties.h
//  
//
//  Created by apple on 2018/1/29.
//
//

#import "QiHuoSearchObj+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QiHuoSearchObj (CoreDataProperties)

+ (NSFetchRequest<QiHuoSearchObj *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contractCode;
@property (nullable, nonatomic, copy) NSString *contractName;
@property (nonatomic) int32_t futuresId;
@property (nullable, nonatomic, copy) NSString *productCode;

@end

NS_ASSUME_NONNULL_END
