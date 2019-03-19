//
//  IMImagePicker.h
//  MYIMDemo
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMImagePicker : NSObject
- (void)selectPhotoMaxImagesCount:(NSInteger)maxImagesCount action:(void(^)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto))block;
@end

NS_ASSUME_NONNULL_END
