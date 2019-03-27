//
//  IMMoreKBHelper.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/18.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMMoreKBHelper.h"
#import "IMMoreKeyboardItem.h"

@implementation IMMoreKBHelper

- (id)init
{
    if (self = [super init]) {
        self.chatMoreKeyboardData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}

- (void)p_initTestData
{
    IMMoreKeyboardItem *imageItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeImage
                                                               title:@"照片"
                                                           imagePath:@"moreKB_image"];
    IMMoreKeyboardItem *cameraItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeCamera
                                                                title:@"拍摄"
                                                            imagePath:@"moreKB_video"];
    IMMoreKeyboardItem *videoItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeVideo
                                                               title:@"小视频"
                                                           imagePath:@"moreKB_sight"];
    IMMoreKeyboardItem *videoCallItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeVideoCall
                                                                   title:@"视频聊天"
                                                               imagePath:@"moreKB_video_call"];
    IMMoreKeyboardItem *walletItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeWallet
                                                                title:@"红包"
                                                            imagePath:@"moreKB_wallet"];
    IMMoreKeyboardItem *transferItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeTransfer
                                                                  title:@"转账"
                                                              imagePath:@"moreKB_pay"];
    IMMoreKeyboardItem *positionItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypePosition
                                                                  title:@"位置"
                                                              imagePath:@"moreKB_location"];
    IMMoreKeyboardItem *favoriteItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeFavorite
                                                                  title:@"收藏"
                                                              imagePath:@"moreKB_favorite"];
    IMMoreKeyboardItem *businessCardItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeBusinessCard
                                                                      title:@"个人名片"
                                                                  imagePath:@"moreKB_friendcard" ];
    IMMoreKeyboardItem *voiceItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeVoice
                                                               title:@"语音输入"
                                                           imagePath:@"moreKB_voice"];
    IMMoreKeyboardItem *cardsItem = [IMMoreKeyboardItem createByType:IMMoreKeyboardItemTypeCards
                                                               title:@"卡券"
                                                           imagePath:@"moreKB_wallet"];
    [self.chatMoreKeyboardData addObjectsFromArray:@[imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem]];
}

@end
