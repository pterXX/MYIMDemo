//
//  IMGroup+CreateAvatar.m
//  IMChat
//
//  Created by 徐世杰 on 2017/9/19.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMGroup+CreateAvatar.h"
#import "NSFileManager+IMChat.h"

@implementation IMGroup (CreateAvatar)

- (void)createGroupAvatarWithCompleteAction:(void (^)(NSString *groupID))completeAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger usersCount = self.users.count > 9 ? 9 : self.users.count;
        CGFloat viewWidth = 200;
        CGFloat width = viewWidth / 3 * 0.85;
        CGFloat space3 = (viewWidth - width * 3) / 4;               // 三张图时的边距（图与图之间的边距）
        CGFloat space2 = (viewWidth - width * 2 + space3) / 2;      // 两张图时的边距
        CGFloat space1 = (viewWidth - width) / 2;                   // 一张图时的边距
        CGFloat y = ({
            int ans = space1;
            if (usersCount > 6) {
                ans = space3;
            }
            else if (usersCount >= 3) {
                ans = space2 - space3;
            }
            ans;
        });
        CGFloat x = ({
            CGFloat ans = space1;
            if (usersCount % 3 == 0) {
                ans = usersCount == 3 ? space1 :space3;
            }
            else if (usersCount % 2 == 0) {
                ans = space2 - space3;
            }
            ans;
        });
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        [view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];
        __block NSInteger count = 0;        // 下载完成图片计数器
        for (NSInteger i = usersCount - 1; i >= 0; i--) {
            IMUser *user = [self.users objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            [view addSubview:imageView];
            [imageView sd_setImageWithURL:user.avatarURL.toURL placeholderImage:[UIImage imageDefaultHeadPortrait] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                count ++;
                if (count == usersCount) {     // 图片全部下载完成
                    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 2.0);
                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGImageRef imageRef = image.CGImage;
                    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, CGRectMake(0, 0, view.width * 2, view.height * 2));
                    UIImage *ansImage = [[UIImage alloc] initWithCGImage:imageRefRect];
                    NSData *imageViewData = UIImagePNGRepresentation(ansImage);
                    NSString *savedImagePath = [NSFileManager pathUserAvatar:self.groupAvatarPath];
                    [imageViewData writeToFile:savedImagePath atomically:YES];
                    CGImageRelease(imageRefRect);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completeAction) {
                            completeAction(self.groupID);
                        }
                    });
                }
            }];
            if (i % 3 == 0) {   // 换行
                y += (width + space3);
                x = space3;
            }
            else if (i == 2 && usersCount == 3) {  // 换行，只有三个时
                y += (width + space3);
                x = space2;
            }
            else {
                x += (width + space3);
            }
        }
    });
}


@end