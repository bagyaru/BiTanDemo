//
//  QiHuoSearchObj+CoreDataProperties.m
//  
//
//  Created by apple on 2018/1/29.
//
//

#import "QiHuoSearchObj+CoreDataProperties.h"

@implementation QiHuoSearchObj (CoreDataProperties)

+ (NSFetchRequest<QiHuoSearchObj *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QiHuoSearchObj"];
}

@dynamic contractCode;
@dynamic contractName;
@dynamic futuresId;
@dynamic productCode;

@end
