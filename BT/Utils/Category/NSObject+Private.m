//
//  NSObject+Private.m
//  HaiYun
//
//  Created by YanLu on 16/3/30.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "NSObject+Private.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>

@implementation NSObject (HYPrivate)
- (id)HYPerformSelector:(NSString *)aSelectorName
{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@",aSelectorName]);
    if(sel && ([self respondsToSelector:sel]))
    {
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL) = (void *)imp;
        return func(self, sel);
    }
    
    return nil;
}

- (id)HYPerformSelector:(NSString *)aSelectorName withObject:(id)object
{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@",aSelectorName]);
    if(sel && ([self respondsToSelector:sel]))
    {
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL,id aObject) = (void *)imp;
        return func(self, sel,object);
    }
    return nil;
}

- (id)HYPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2
{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@",aSelectorName]);
    if(sel && ([self respondsToSelector:sel]))
    {
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL,id aObject,id bObject) = (void *)imp;
        return func(self, sel,object1,object2);
    }
    return nil;
}
@end

/*********************************************/

@implementation NSString (HYPrivate)

- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *) GetSand
{
    char data[36];
    for (int x=0;x<36;data[x++] = (char)('a' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:36 encoding:NSUTF8StringEncoding];
}

//转换成中间有星号的字符串
- (NSString*)setSecuretext:(NSString*)str;
{
    if(!str)
        return @"";
    if([str length] < 7)
        return str;
    int length = (int)[str length];
    NSString *Fstr;
    NSString *Bstr;
    //	NSString *Mstr = @"*";
    Fstr = [str substringToIndex:3];
    Bstr = [str substringFromIndex:length-5];
    //	for(int i = 1;i < length-2; i++)
    //	{
    //		Mstr = [NSString stringWithFormat:@"*%@",Mstr];
    //	}
    NSString* ns = [NSString stringWithFormat:@"%@***%@",Fstr,Bstr];
    return ns;
}

+ (NSString *)HYstringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData HYdataWithBase64EncodedString:string];
    if (data)
    {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

- (NSString *)HYbase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data HYbase64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)HYbase64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data HYbase64EncodedString];
}

- (NSString *)HYbase64DecodedString
{
    return [NSString HYstringWithBase64EncodedString:self];
}

- (NSData *)HYbase64DecodedData
{
    return [NSData HYdataWithBase64EncodedString:self];
}

//汉字的拼音
- (NSString *)initial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end

@implementation UIView(HYblock)

const char oldDelegateKey;
const char completionHandlerKey;
#pragma -mark UIAlerView
-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIAlertView *alert = (UIAlertView *)self;
    if( completionHandler != nil)
    {
        
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        oldDelegate = alert.delegate;
        alert.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    alert.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}

@end

#pragma mark -NSDictionary
@implementation NSDictionary (HYPrivate)
- (NSString*)JSONString
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error == nil)
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ;
    }
    return nil;
}

- (NSString *)HYValueForKey:(NSString *)key;
{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSString class]])
    {
        if (ISNSStringValid((NSString *)Value))
        {
            return Value;
        }
    }
    
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSNumber class]] > 0)
    {
        return [NSString stringWithFormat:@"%ld",[Value longValue]];
    }
    
    return @"";
}

- (NSMutableArray *)HYNSArrayValueForKey:(NSString *)key
{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSArray class]])
    {
        
        return (NSMutableArray *)Value;
    }
    
    return nil;
}

- (NSMutableDictionary *)HYNSDictionaryValueForKey:(NSString *)key
{
    id Value = [self valueForKey:key];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSDictionary class]])
    {
        return (NSMutableDictionary *)Value;
    }
    
    return nil;
}

-(BOOL)isAction:(NSString *)nsAction
{
    nsAction = [nsAction lowercaseString];
    NSString * strAction = [self objectForKey:@"action"];
    strAction = [strAction lowercaseString];
    
    if (ISNSStringValid(strAction))
    {
        if ([strAction isEqualToString:nsAction])
        {
            return TRUE;
        }else
        {
            return [strAction isEqualToString:[nsAction substringFromIndex:1]];
        }
    }
    return FALSE;
}

-(int) GetErrorNO
{
    if (self && [self count] > 0)
    {
        NSString *nsErrorCode = [self objectForKey:@"status"];
        if (nsErrorCode)
        {
            return [nsErrorCode intValue];
        }
    }
    return -1;
}

-(BOOL)isSuccess
{
    if ([self GetErrorNO])
    {
        return TRUE;
    }
    return FALSE;
}


@end

#pragma mark -NSMutableDictionary
@implementation NSMutableDictionary (HYPrivate)
- (void)HYSetObject:(NSString *)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject == NULL)
        anObject = @"";
    
    [self setObject:anObject forKey:aKey];
}
@end

#pragma mark -NSArray
@implementation NSArray (HYPrivate)

- (NSString *)HYObjectAtIndex:(NSUInteger)index
{
    int  nTmp = 0;
    if (index < nTmp || index > [self count] || [self count] == 0)
    {
        return @"";
    }
    
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSString class]])
    {
        if (ISNSStringValid((NSString *)Value))
        {
            return (NSString *)Value;
        }
    }
    
    if ((NSNull *)Value != [NSNull null] && [Value intValue] > 0)
    {
        return [NSString stringWithFormat:@"%ld",[Value longValue]];
    }
    
    return @"";
}

- (NSMutableArray *)HYNSArrayObjectAtIndex:(NSUInteger)index
{
    int  nTmp = 0;
    if (index < nTmp || index > [self count] || [self count] == 0)
    {
        return nil;
    }
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSArray class]])
    {
        return (NSMutableArray *)Value;
    }
    
    return nil;
}

- (NSMutableDictionary *)HYNSDictionaryObjectAtIndex:(NSUInteger)index
{
    int  nTmp = 0;
    if (index < nTmp || index > [self count] || [self count] == 0)
    {
        return nil;
    }
    
    id Value = [self objectAtIndex:index];
    if ((NSNull *)Value != [NSNull null] && [Value isKindOfClass:[NSDictionary class]])
    {
        return (NSMutableDictionary *)Value;
    }
    return nil;
}

@end

#pragma mark -UIImageView
@implementation UIImageView (HYPrivate)

-(void)SetlayerShap:(CGSize)size
{
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2) radius:MIN(size.width/2, size.height/2) startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    self.layer.mask = shape;
}
@end

#pragma mark -NSData
@implementation NSData (HYPrivate)

+ (NSData *)HYdataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    unsigned int inputLength = (unsigned int)[inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    unsigned int maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    unsigned int outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

- (NSString *)HYbase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    unsigned long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    unsigned long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, (unsigned long)outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:(unsigned int)outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4)? result: nil;
}

- (NSString *)HYbase64EncodedString
{
    return [self HYbase64EncodedStringWithWrapWidth:0];
}


@end
#pragma mark -UILabel
@implementation UILabel (HYPrivate)

- (void)HYPriceChangeFont:(CGFloat)font colors:(UIColor *)color isTop:(BOOL)flagTop
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    //关键字
    if ( flagTop ) {
        NSRange itemRange = NSMakeRange(0,1);
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:itemRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:itemRange];
    }
    
    NSRange baseRange = NSMakeRange(self.text.length-2,2);
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:baseRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:baseRange];
    
    
    self.attributedText = attributedString;
}

@end

#pragma makr -UIImage
@implementation UIImage (HYPrivate)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    CGFloat wAspect = newSize.width / image.size.width;
    CGFloat hAspect = newSize.height / image.size.height;
    
    CGFloat aspect = MAX(hAspect, wAspect);
    newSize = CGSizeMake(image.size.width*aspect, image.size.height*aspect);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode{
    CGRect drawRect;
    CGSize size = self.size;
    
    switch (contentMode){
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill:{
            // nothing to do
            [self drawInRect:rect];
            return;
        }
        case UIViewContentModeScaleAspectFit:{
            CGFloat factor;
            
            if (size.width<size.height){
                factor = rect.size.height / size.height;
            }else{
                factor = rect.size.width / size.width;
            }
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
        case UIViewContentModeScaleAspectFill:{
            CGFloat factor;
            
            if (size.width<size.height){
                factor = rect.size.width / size.width;
            }else{
                factor = rect.size.height / size.height;
            }
            
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeCenter:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTop:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottom:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // clip to rect
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    // draw
    [self drawInRect:drawRect];
    
    CGContextRestoreGState(context);
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight){
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0){
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)imageWithRoundedSize:(CGSize)size radius:(NSInteger)r{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapAlphaInfoMask|kCGBitmapByteOrderMask|kCGBitmapByteOrderDefault);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
- (UIImage *)rrImageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        CFRelease(properties);
        if (gifProperties) {
            CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
            delayCentiseconds = (int)lrint([(__bridge id)number doubleValue] * 100);
        }
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL));
}

- (UIColor *)colorAtPixel:(CGPoint)point{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size{
    NSParameterAssert(color);
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"Size cannot be CGSizeZero");
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end


