//
//  IMFLEXAngel+Private.h
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/14.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMFLEXAngel.h"

@interface IMFLEXAngel (Private)

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section;

- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag;

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
