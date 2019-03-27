//
//  IMExpressionItemCell.m
//  IMChat
//
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMExpressionItemCell.h"
#import "IMExpressionGroupModel+Download.h"
#import "IMExpressionDownloadButton.h"
#import "IMExpressionGroupModel.h"

@interface IMExpressionItemCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *tagView;

@property (nonatomic, strong) IMExpressionDownloadButton *downloadButton;

@property (nonatomic, copy) id (^eventAction)(NSInteger eventType, id data);

@end

@implementation IMExpressionItemCell

+ (CGFloat)viewHeightByDataModel:(id)dataModel
{
    return 80;
}

- (void)setViewDataModel:(id)dataModel
{
    [self setGroupModel:dataModel];
}

- (void)setViewEventAction:(id (^)(NSInteger, id))eventAction
{
    [self setEventAction:eventAction];
}

- (void)viewIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count
{
    self.addSeparator(IMSeparatorPositionBottom).beginAt(15);
}

#pragma mark - # Public Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.tagView];
        [self.contentView addSubview:self.downloadButton];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)setGroupModel:(IMExpressionGroupModel *)groupModel
{
    _groupModel = groupModel;
    UIImage *image = [UIImage imageNamed:groupModel.path];
    if (image) {
        [self.iconView setImage:image];
    }
    else {
        [self.iconView tt_setImageWithURL:IMURL(groupModel.iconURL)];
    }
    [self.titleLabel setText:groupModel.name];
    [self.detailLabel setText:groupModel.detail];
    
    if (groupModel.status == IMExpressionGroupStatusLocal) {
        [self.downloadButton setStatus:IMExpressionDownloadButtonStatusDownloaded];
    }
    else if (groupModel.status == IMExpressionGroupStatusDownloading) {
        [self.downloadButton setStatus:IMExpressionDownloadButtonStatusDownloading];
    }
    else {
        [self.downloadButton setStatus:IMExpressionDownloadButtonStatusNet];
    }
    
    @weakify(self);
    [self.downloadButton setProgress:groupModel.downloadProgress];
    [groupModel setDownloadProgressAction:^(IMExpressionGroupModel *groupModel, CGFloat progress) {
        @strongify(self);
        [self.downloadButton setProgress:progress];
    }];
    [groupModel setDownloadCompleteAction:^(IMExpressionGroupModel *groupModel, BOOL success, id data) {
        @strongify(self);
        [self setGroupModel:groupModel];
    }];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.top.mas_equalTo(self.contentView).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        make.width.mas_equalTo(self.iconView.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconView.mas_centerY).mas_offset(-2.0f);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(13.0f);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-15);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_centerY).mas_offset(5.0);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-15);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self.contentView);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 27));
    }];
}

#pragma mark - # Getter
- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [_iconView setBackgroundColor:[UIColor clearColor]];
        [_iconView.layer setMasksToBounds:YES];
        [_iconView.layer setCornerRadius:5.0f];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        [_titleLabel setClipsToBounds:YES];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_detailLabel setTextColor:[UIColor grayColor]];
        [_detailLabel setBackgroundColor:[UIColor whiteColor]];
        [_detailLabel setClipsToBounds:YES];
    }
    return _detailLabel;
}

- (UIImageView *)tagView
{
    if (_tagView == nil) {
        _tagView = [[UIImageView alloc] init];
        [_tagView setImage:[UIImage imageNamed:@"icon_corner_new"]];
        [_tagView setHidden:YES];
    }
    return _tagView;
}

- (IMExpressionDownloadButton *)downloadButton
{
    if (_downloadButton == nil) {
        _downloadButton = [[IMExpressionDownloadButton alloc] init];
        @weakify(self);
        [_downloadButton setDownloadButtonClick:^{
            @strongify(self);
            if (self.groupModel.status == IMExpressionGroupStatusNet) {
                [self.groupModel startDownload];
                [self setGroupModel:self.groupModel];
            }
        }];
    }
    return _downloadButton;
}

@end
