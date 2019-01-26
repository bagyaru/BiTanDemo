//
//  BTBaseObject.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBaseObject : NSObject
/**
 @brief 从字典创建对象
 @param dictionary      数据字典
 @return 该类的一个实例
 */
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

/**
 @brief 子类覆盖用，用于objectWithDictionary中类属性名与字典key的对应关系，
 如：NSDictionary中的key为productId，对应类属性名pId;
 @return 类属性名与字典key的对应关系。
 这个字典中的key为类属性名，value为需解析的字典key。
 如果某个属性没有对应关系，则认为属性名与key相同。
 默认返回nil。
 不需要父类的属性。
 */
+ (NSDictionary *)propertyAndKeyMap;

- (NSDictionary *)dictionarySerializer;

/**
 @brief 子类覆盖用，用于解析数组元素的类，必须是MKBaseItem子类
 */
+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index;

/**
 @brief 从父类或子类复制属性
 */
- (void)copyFromSuperOrSubObject:(BTBaseObject *)object;

@end


@interface BTBaseObject (save)

/**
 @brief 默认保存在Library/Caches/MKItems/{类名}中
 */
- (BOOL)saveToClassFile;

- (BOOL)saveToFile:(NSString *)path;

/**
 @brief 默认从Library/Caches/MKItems/{类名}中读取
 */
+ (id)loadFromClassFile;

+ (id)loadFromFile:(NSString *)path;

+ (void)deleteClassFile;

@end
