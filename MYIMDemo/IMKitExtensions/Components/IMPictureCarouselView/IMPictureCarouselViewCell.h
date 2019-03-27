//
//  IMPictureCarouselViewCell.h
//  IMChat
//
//  Created by 李伯坤 on 16/4/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPictureCarouselProtocol.h"

@interface IMPictureCarouselViewCell : UICollectionViewCell

@property (nonatomic, strong) id<IMPictureCarouselProtocol> model;

@end
