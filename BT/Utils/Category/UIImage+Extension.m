//
//  UIImage+Extension.m
//  BT
//
//  Created by apple on 2018/11/2.
//  Copyright © 2018 apple. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

//
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method imageNamed = class_getClassMethod(self,@selector(imageNamed:));
        Method LZPimageNamed = class_getClassMethod(self,@selector(LZP_imageNamed:));
        method_exchangeImplementations(LZPimageNamed, imageNamed);
    });
   
}

+ (instancetype)LZP_imageNamed:(NSString*)name{
    NSString *imageName = name;
    UIImage *changeImage = [self LZP_imageNamed:isNightMode ? [NSString stringWithFormat:@"%@_Night",imageName] : ([imageName containsString:@"_Night"] ? [imageName stringByReplacingOccurrencesOfString:@"_Night" withString:@""] : imageName)];
    //UIImage* image = [self LZP_imageNamed:imageName];
    if(changeImage == nil) {
        return [self LZP_imageNamed:name];
    }
    return changeImage;
    
}


@end
