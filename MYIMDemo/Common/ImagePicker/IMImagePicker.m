//
//  IMImagePicker.m
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMImagePicker.h"
#import "TZImagePickerController.h"
#import "IMSystemAuthorization.h"

@interface IMImagePicker() <TZImagePickerControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation IMImagePicker
// 相册选择照片
- (void)selectPhotoMaxImagesCount:(NSInteger)maxImagesCount action:(void(^)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto))block
{
    if ([[IMSystemAuthorization shareInstance] checIMPhotoAlbumAuthorization]) {
        [self selectPhotoAcationMaxImagesCount:maxImagesCount action:block];
    }
}

- (void)selectPhotoAcationMaxImagesCount:(NSInteger)maxImagesCount action:(void(^)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto))block
{
    TZImagePickerController *pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:nil];
    pickerController.allowPickingVideo = NO;
    pickerController.allowPickingGif   = NO;
    [pickerController setDidFinishPickingPhotosHandle:block];
    [[UIViewController getCurrentVC] presentViewController:pickerController animated:YES completion:nil];
}

/**
 权限设置
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)settingAuthorizationWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(YES);
    }];
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(NO);
        [[IMSystemAuthorization shareInstance] requetSettingForAuth];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:setting];
    
    [[UIViewController getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    
}
@end
