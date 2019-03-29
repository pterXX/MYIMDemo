//
//  IMExpressionBannerCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/4/20.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionBannerCell.h"
#import "IMPictureCarouselView.h"
#import "IMExpressionGroupModel.h"

@interface IMExpressionBannerCell ()

@property (nonatomic, strong) IMPictureCarouselView *picCarouselView;

@end

@implementation IMExpressionBannerCell

#pragma mark - # Protocol
+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 0.4 * SCREEN_WIDTH;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setData:dataModel];
}

- (void)setViewDelegate:(id)delegate
{
    [self setDelegate:delegate];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    [self setBannerClickAction:^(id bannerModel) {
        if (eventAction) {
            eventAction(0, bannerModel);
        }
    }];
}

#pragma mark - # Public Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.picCarouselView];
        [self p_addMasonry];
    }
    return self;
}

- (void)setData:(NSArray *)data
{
    _data = data;
    [self.picCarouselView setData:data];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.picCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - # Getter 
- (IMPictureCarouselView *)picCarouselView
{
    if (_picCarouselView == nil) {
        _picCarouselView = [[IMPictureCarouselView alloc] init];
        @weakify(self);
        [_picCarouselView setDidSelectItem:^(IMPictureCarouselView *pictureCarouselView, id<IMPictureCarouselProtocol> model){
            @strongify(self);
            if (self.bannerClickAction) {
                self.bannerClickAction(model);
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(expressionBannerCellDidSelectBanner:)]) {
                [self.delegate expressionBannerCellDidSelectBanner:model];
            }
        }];
    }
    return _picCarouselView;
}

@end

#pragma mark - ## IMExpressionGroupModel (IMExpressionBannerCell)
@interface IMExpressionGroupModel (IMExpressionBannerCell) <IMPictureCarouselProtocol>

@end

@implementation IMExpressionGroupModel (IMExpressionBannerCell)

- (NSString *)pictureURL
{
    return self.bannerURL;
}

@end
