//
//  UIImageView+IMChat.m
//  MYIMDemo
//
//  Created by admin on 2019/3/20.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "UIImageView+IMChat.h"
#import "UIImage+IMChat.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UIImageView (IMChat)
- (void)im_setAvatar:(NSString *)userAvatar jid:(XMPPJID *)jid{
    if ([userAvatar containsString:@"storage/headImage"]) {
        NSString *imagePath = [NSFileManager pathUserAvatar:userAvatar];
       self.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    if ([userAvatar containsString:@"http://"] ||
        [userAvatar containsString:@"https://"]){
        [self sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageDefaultHeadPortrait]];
    }
    else if (userAvatar.length == 0){
        NSString *str = IMStirngFormat(@"%@.png",jid.user);
        NSString *imagePath = [NSFileManager pathUserAvatar:str];
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        if (img) {
            self.image = img;
        }else{
            img = [KIMXMPPHelper userAvatarForJid:jid];
            BOOL result = [UIImagePNGRepresentation(img) writeToFile:imagePath    atomically:YES];
            if (result) {
                NSLog(@"========> %@头像保存路径:%@",jid.bare,imagePath);
            }
            self.image = img;
        }
    }else{
        self.image = [UIImage imageDefaultHeadPortrait];
    }
}
@end
