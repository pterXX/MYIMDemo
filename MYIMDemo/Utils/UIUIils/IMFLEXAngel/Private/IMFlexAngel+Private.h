//
//  IMFlexAngel+Private.h
//  IMFlexDemo
//
//  Created by 李伯坤 on 2017/12/14.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMFlexAngel.h"

@interface IMFlexAngel (Private)

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section;

- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag;

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
