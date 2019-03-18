//
//  IMSearchResultControllerProtocol.h
//  TLChat
//
//  Created by 徐世杰 on 2018/1/4.
//  Copyright © 2018年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@protocol IMSearchResultControllerProtocol <UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

- (void)setItemClickAction:(void (^)(__kindof UIViewController *searchResultVC, id data))itemClickAction;

@end
