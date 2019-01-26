//
//  BTBaseObject.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"
@import ObjectiveC.runtime;
//static objc_property_t *class_copyAllInterfaceEntityPropertyList(Class class, unsigned int *outCount);

@interface OCPropertyInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isClass;
@property (nonatomic, strong) NSString *type;

@end

@implementation BTBaseObject
/**
 @brief 从字典创建对象
 @param dictionary      数据字典
 @return 该类的一个实例
 */
+ (id)objectWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    id obj = [[self alloc] init];
    [self decodeDictionary:dictionary toInstance:obj];
    return obj;
}

/**
 @brief 子类覆盖用，用于objectWithDictionary中类属性名与字典key的对应关系，
 如：NSDictionary中的key为productId，对应类属性名pId;
 @return 类属性名与字典key的对应关系。
 这个字典中的key为类属性名，value为需解析的字典key。
 如果某个属性没有对应关系，则认为属性名与key相同。
 默认返回nil。
 不需要父类的属性。
 */
+ (NSDictionary *)propertyAndKeyMap
{
    return nil;
}

- (NSDictionary *)dictionarySerializer
{
    NSMutableDictionary *d = [[self class] encodeInstance:self];
    if ([d isKindOfClass:[NSMutableDictionary class]])
    {
        return [d copy];
    }
    return d;
}

/**
 @brief 子类覆盖用，用于解析数组元素的类，必须是MKBaseItem子类
 */
+ (Class)classForArrayItemWithName:(NSString *)propertyName andIndex:(NSInteger)index
{
    return nil;
}

- (void)copyFromSuperOrSubObject:(BTBaseObject *)object
{
    Class c;
    if ([self isKindOfClass:[object class]])
    {
        c = [object class];
    }
    else if ([object isKindOfClass:[self class]])
    {
        c = [self class];
    }
    else
    {
        return;
    }
    [c copyInstance:object toAnotherInstance:self];
}

+ (void)copyInstance:(BTBaseObject *)one toAnotherInstance:(BTBaseObject *)two
{
    if (self == [BTBaseObject class])
    {
        return;
    }
    NSArray *properties = [self getClassProperties];
    for (OCPropertyInfo *p in properties)
    {
        [two setValue:[one valueForKey:p.name] forKey:p.name];
    }
}

/**
 @brief 递归解析数据
 */
+ (void)decodeDictionary:(NSDictionary *)dictionary toInstance:(id)instance
{
    if (self == [BTBaseObject class])
    {
        return;
    }
    [[self superclass] decodeDictionary:dictionary toInstance:instance];
    
    NSArray *properties = [self getClassProperties];
    NSDictionary *pkmap = [self propertyAndKeyMap];
    for (OCPropertyInfo *p in properties)
    {
        NSString *k = pkmap[p.name];
        if (k == nil)
        {
            k = p.name;
        }
        id v = dictionary[k];
        if (v == nil)
        {
            continue;
        }
        [instance decodeValue:v withProperty:p.name andType:p.type];
    }
}

/**
 @brief 给对象属性赋值
 */
- (void)decodeValue:(id)value withProperty:(NSString *)propertyName andType:(NSString *)typeName;
{
    if ([value isKindOfClass:[NSDictionary class]])
    {
        value = [self decodeNSDictionaryValue:value withProperty:propertyName andTypeName:typeName];
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
        value = [self decodeArrayValue:value withProperty:propertyName];
    }
    //防止value数据为null时 发生崩溃
    [self setValue:[value isEqual:[NSNull null]]?@"":value forKey:propertyName];
}

/**
 @brief 解析字典
 */
- (id)decodeNSDictionaryValue:(id)value withProperty:(NSString *)propertyName andTypeName:(NSString *)typeName;
{
    Class c = NSClassFromString(typeName);
    if ([c isSubclassOfClass:[BTBaseObject class]])
    {
        BTBaseObject *instance = [c objectWithDictionary:value];
        return instance;
    }
    return value;
}

/**
 @brief 解析数组
 */
- (NSArray *)decodeArrayValue:(id)value withProperty:(NSString *)propertyName
{
    NSInteger index = 0;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[value count]];
    for (NSDictionary *d in value)
    {
        if (![d isKindOfClass:[NSDictionary class]])
        {
            [items addObject:d];
            continue;
        }
        Class c = [[self class] classForArrayItemWithName:propertyName andIndex:index];
        if (c == nil)
        {
            [items addObject:d];
            continue;
        }
        BTBaseObject *instance = [c objectWithDictionary:d];
        [items addObject:instance];
        
        index ++ ;
    }
    return [items copy];
}

+ (id)encodeInstance:(id)instance
{
    if (self == [BTBaseObject class])
    {
        return [NSMutableDictionary dictionary];
    }
    if ([instance isKindOfClass:[NSNumber class]] || [instance isKindOfClass:[NSString class]])
    {
        return instance;
    }
    if ([instance isKindOfClass:[NSArray class]])
    {
        NSMutableArray *a = [NSMutableArray arrayWithCapacity:[instance count]];
        for (id o in instance)
        {
            id oo;
            if ([o isKindOfClass:[BTBaseObject class]])
            {
                oo = [[o class] encodeInstance:o];
            }
            if (oo != nil)
            {
                [a addObject:oo];
            }
        }
        return [a copy];
    }
    if ([instance isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[instance count]];
        [instance enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             id oo;
             if ([obj isKindOfClass:[BTBaseObject class]])
             {
                 oo = [[obj class] encodeInstance:obj];
             }
             if (oo != nil)
             {
                 dic[key] = oo;
             }
         }];
        return [dic copy];
    }
    if (![instance isKindOfClass:[BTBaseObject class]])
    {
        return nil;
    }
    
    NSMutableDictionary *dic = [[self superclass] encodeInstance:instance];
    if (![dic isKindOfClass:[NSMutableDictionary class]])
    {
        return dic;
    }
    NSArray *properties = [self getClassProperties];
    NSDictionary *pkmap = [self propertyAndKeyMap];
    
    for (OCPropertyInfo *p in properties)
    {
        id v = [instance valueForKey:p.name];
        
        //OC中的BOOL实际是signed char这里为了json能转出true/false来，只能这么做了
        if (([p.type isEqualToString:@"c"] || [p.type isEqualToString:@"B"]) && ([v intValue] == 0 || [v intValue] == 1))
        {
            v = ([v boolValue] ? @YES : @NO);
        }
        
        id oo;
        if ([v isKindOfClass:[BTBaseObject class]])
        {
            oo = [[v class] encodeInstance:v];
        }
        else
        {
            oo = [self encodeInstance:v];
        }
        
        if (oo != nil)
        {
            NSString *k = pkmap[p.name];
            if (k == nil)
            {
                k = p.name;
            }
            dic[k] = oo;
        }
    }
    return dic;
}

/**
 @brief 获取当前类属性列表，不包含父类的
 */
+ (NSArray *)getClassProperties
{
    unsigned int outCount = 0;
    objc_property_t *props = class_copyPropertyList(self, &outCount);
    
    NSMutableDictionary *oprops = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (int i = 0; i < outCount; ++ i)
    {
        OCPropertyInfo *p = [[OCPropertyInfo alloc] init];
        p.name = [NSString stringWithUTF8String:property_getName(props[i])];
        char *ptc = property_copyAttributeValue(props[i], "T");
        NSString *pt = [NSString stringWithUTF8String:ptc];
        free(ptc);
        if ([pt hasPrefix:@"@"])
        {
            p.isClass = YES;
            NSInteger l = pt.length - 3;
            NSRange range = [pt rangeOfString:@"<"];
            if (range.location != NSNotFound)
            {
                l = range.location - 2;
            }
            pt = [pt substringWithRange:NSMakeRange(2, l)];
        }
        p.type = pt;
        
        [oprops setObject:p forKey:p.name];
    }
    
    free(props);
    return [oprops allValues];
}

@end


@implementation BTBaseObject (save)

#define defaultSavePath @"MKObjects/"

- (BOOL)saveToClassFile
{
    NSString *f = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    f = [f stringByAppendingPathComponent:[NSString stringWithFormat:defaultSavePath"%@", NSStringFromClass([self class])]];
    return [self saveToFile:f];
}

- (BOOL)saveToFile:(NSString *)file
{
    NSString *path = [file stringByDeletingLastPathComponent];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:path])
    {
        BOOL b = [f createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
        if (!b)
        {
            return NO;
        }
    }
    NSDictionary *d = [self dictionarySerializer];
    return [d writeToFile:file atomically:YES];
}

+ (id)loadFromClassFile
{
    NSString *f = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    f = [f stringByAppendingPathComponent:[NSString stringWithFormat:defaultSavePath"%@", NSStringFromClass([self class])]];
    return [self loadFromFile:f];
}

+ (id)loadFromFile:(NSString *)file
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        return nil;
    }
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:file];
    return [self objectWithDictionary:d];
}

+ (void)deleteClassFile
{
    NSString *f = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    f = [f stringByAppendingPathComponent:[NSString stringWithFormat:defaultSavePath"%@", NSStringFromClass([self class])]];
    [[NSFileManager defaultManager] removeItemAtPath:f error:NULL];
}

@end


@implementation OCPropertyInfo
@end
