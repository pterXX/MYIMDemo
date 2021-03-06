//
//  IMMessageImageView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/15.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMMessageImageView : UIImageView

@property (nonatomic, strong) UIImage *backgroundImage;

/**
 *  设置消息图片（规则：收到消息时，先下载缩略图到本地，再添加到列表显示，并自动下载大图）
 *
 *  @param imagePath    缩略图Path
 *  @param imageURL     高清图URL
 */
- (void)setThumbnailPath:(NSString *)imagePath highDefinitionImageURL:(NSString *)imageURL;

@end
