//
//  IMExpressionBannerCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/4/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMExpressionBannerCellDelegate <NSObject>

- (void)expressionBannerCellDidSelectBanner:(id)item;

@end

@interface IMExpressionBannerCell : UITableViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, assign) id<IMExpressionBannerCellDelegate>delegate;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) void (^bannerClickAction)(id bannerModel);

@end
