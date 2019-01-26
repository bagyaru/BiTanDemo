//
//  HYPhoto.h


#import <Foundation/Foundation.h>
#import "HYActionSheetViewController.h"

typedef void (^Image)(UIImage *image, id sender);

@interface HYPhoto : NSObject<HYActionSheetViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _bBack;//正面 反面设置
}

@property (nonatomic,assign) id  sender;
@property (nonatomic,strong) Image  imageblock;

+(HYPhoto*)getSharePhoto;
// 做选择的触发 拍照 （可以选择拍照和 相册）
-(void)getPhoto:(id)sender
           Back:(BOOL)bBack
          Image:(Image)image;
// 直接触发拍照
-(void)getCamera:(id)sender
            Back:(BOOL)bBack
           Image:(Image)image;
// 直接触发相册
-(void)getPicture:(id)sender
            Image:(Image)image;

@end
