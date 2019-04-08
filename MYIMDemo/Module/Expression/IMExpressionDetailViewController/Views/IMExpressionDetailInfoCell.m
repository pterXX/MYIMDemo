//
//  IMExpressionDetailInfoCell.m
//  IMChat
//
//  Created by 徐世杰 on 16/4/11.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMExpressionDetailInfoCell.h"
#import "IMExpressionGroupModel+Download.h"
#import "IMExpressionDownloadButton.h"

@interface IMExpressionDetailInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) IMExpressionDownloadButton *downloadButton;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation IMExpressionDetailInfoCell

+ (CGSize)viewSizeByDataModel:(IMExpressionGroupModel *)group
{
    CGFloat detailHeight = [group.detail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size.height;
    CGFloat height = 85.0 + detailHeight;
    return CGSizeMake(SCREEN_WIDTH, height);
}

- (void)setViewDataModel:(id)dataModel
{
    [self setGroupModel:dataModel];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.downloadButton];
        [self.contentView addSubview:self.detailLabel];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)setGroupModel:(IMExpressionGroupModel *)groupModel
{
    _groupModel = groupModel;
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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_right).mas_offset(-15);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel).mas_offset(-3);
        make.right.mas_equalTo(self.contentView).mas_offset(-15.0f);
        make.size.mas_equalTo(CGSizeMake(83, 30));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
    }];
}

#pragma mark - # Getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        [_titleLabel setClipsToBounds:YES];
    }
    return _titleLabel;
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

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setBackgroundColor:[UIColor whiteColor]];
        [_detailLabel setClipsToBounds:YES];
        [_detailLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_detailLabel setTextColor:[UIColor grayColor]];
        [_detailLabel setNumberOfLines:0];
    }
    return _detailLabel;
}

@end
