//
//  IMPictureCarouselViewCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPictureCarouselProtocol.h"

@interface IMPictureCarouselViewCell : UICollectionViewCell

@property (nonatomic, strong) id<IMPictureCarouselProtocol> model;

@end
