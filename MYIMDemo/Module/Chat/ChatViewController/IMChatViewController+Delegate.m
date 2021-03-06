//
//  IMChatViewController+Delegate.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatViewController+Delegate.h"
#import "IMExpressionViewController.h"
#import "IMMyExpressionViewController.h"
#import "IMUserDetailViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "NSFileManager+IMChat.h"

@interface IMChatViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation IMChatViewController (Delegate)

#pragma mark - Delegate -
//MARK: IMMoreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(IMMoreKeyboardItem *)funcItem
{
    if (funcItem.type == IMMoreKeyboardItemTypeCamera || funcItem.type == IMMoreKeyboardItemTypeImage) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if (funcItem.type == IMMoreKeyboardItemTypeCamera) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else {
                [IMUIUtility showAlertWithTitle:@"错误" message:@"相机初始化失败"];
                return;
            }
        }
        else {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"选中”%@“ 按钮", funcItem.title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

//MARK: IMEmojiKeyboardDelegate
- (void)emojiKeyboardEmojiEditButtonDown
{
    IMExpressionViewController *expressionVC = [[IMExpressionViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:expressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)emojiKeyboardMyEmojiEditButtonDown
{
    IMMyExpressionViewController *myExpressionVC = [[IMMyExpressionViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:myExpressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}

//MARK: IMChatViewControllerProxy
- (void)didClickedUserAvatar:(IMUser *)user
{
    IMUserDetailViewController *detailVC = [[IMUserDetailViewController alloc] initWithUserModel:user];
    IMPushVC(detailVC);
}

- (void)didClickedImageMessages:(NSArray *)imageMessages atIndex:(NSInteger)index
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (IMMessage *message in imageMessages) {
        NSURL *url;
        if ([(IMImageMessage *)message imagePath]) {
            NSString *imagePath = [NSFileManager pathUserChatImage:[(IMImageMessage *)message imagePath]];
            url = [NSURL fileURLWithPath:imagePath];
        }
        else {
            url = IMURL([(IMImageMessage *)message imageURL]);
        }
        
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    UINavigationController *broserNavC = [[UINavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}

#pragma mark - #UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    @weakify(self);
    @autoreleasepool {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self sendImageMessage:image];
        }];
    }
}

@end
