//
//  XianHuoSearchObj+CoreDataProperties.m
//  
//
//  Created by apple on 2018/1/29.
//
//

#import "XianHuoSearchObj+CoreDataProperties.h"

@implementation XianHuoSearchObj (CoreDataProperties)

+ (NSFetchRequest<XianHuoSearchObj *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"XianHuoSearchObj"];
}

@dynamic exchangeCode;
@dynamic exchangeName;
@dynamic exchangeId;
@dynamic exchangeLabel;

@end
