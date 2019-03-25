//
//  IMFlexAngel+Private.h
//  IMFlexDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFlexAngel.h"

@interface IMFlexAngel (Private)

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section;

- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag;

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
