//
//  HYPhoto.m



#import "HYPhoto.h"
//#import <UIAlertView+Blocks.h>
#import <AVFoundation/AVFoundation.h>
HYPhoto    *g_HYPhoto = NULL;

@implementation HYPhoto

+(HYPhoto *)getSharePhoto
{
    if (g_HYPhoto == NULL)
    {
        g_HYPhoto = NewObject(HYPhoto);
    }
    return g_HYPhoto;
}

-(void)getPhoto:(id)sender
           Back:(BOOL)bBack
          Image:(Image)image
{
    if (sender == nil)
    {
        return;
    }
    
    self.sender = sender;
    _bBack = bBack;
    self.imageblock = image;
    
    HYActionSheetViewController * actionSheet = [[HYActionSheetViewController alloc] init];
    actionSheet.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    actionSheet.delegate = g_HYPhoto;
    //[getMainTabBar presentViewController:actionSheet animated:NO completion:nil];
    
    [self.sender presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)getCamera:(id)sender
            Back:(BOOL)bBack
           Image:(Image)image
{
    if (sender == NULL)
    {
        return;
    }
    
    self.sender  = sender;
    _bBack = bBack;
    self.imageblock = image;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        NSLog(@"该设备不支持此功能！");
    }
}

-(void)getPicture:(id)sender
            Image:(Image)image
{
    if (sender == NULL)
    {
        return;
    }
    self.sender = sender;
    self.imageblock = image;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }else
    {
        NSLog(@"该设备不支持此功能！");
    }
}

-(void)displayImagePickerWithSource:(UIImagePickerControllerSourceType)src;
{
    if ( src == UIImagePickerControllerSourceTypeCamera )
    {
        if (_bBack && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            NSLog(@"此设备不支持后置摄像头！");
            return;
        }
        
        if (!_bBack && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            NSLog(@"此设备不支持前置摄像头！");
            return;
        }
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的“设置－隐私－相机”选项中，允许访问的相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
    }
    if([UIImagePickerController isSourceTypeAvailable:src])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:g_HYPhoto];
        picker.sourceType = src;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.allowsEditing = YES;
        if (src == UIImagePickerControllerSourceTypeCamera)
        {
            picker.showsCameraControls = YES;
        }
        picker.delegate = [HYPhoto getSharePhoto];
        [self.sender presentViewController:picker animated:YES completion:nil];
        //[BTCMInstance presentViewControllerWithName:@"actionSheet" andParams:nil];
        picker = nil;
    }
}
#pragma mark -HYActionSheetViewControllerDelegate
- (void)actionSheetView:(HYActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 2://拍照
        {
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1://从相册获取
        {
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)pickerImage didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* photoimage = [info objectForKey:UIImagePickerControllerEditedImage];
        [pickerImage dismissViewControllerAnimated:YES completion:^{
            
            //
            [self OnEditImage:photoimage];
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
#pragma mark -处理照片
- (void)OnEditImage:(UIImage *)photoImage
{
    if( self.imageblock )
    {
        self.imageblock(photoImage,self.sender);
    }
}


@end
