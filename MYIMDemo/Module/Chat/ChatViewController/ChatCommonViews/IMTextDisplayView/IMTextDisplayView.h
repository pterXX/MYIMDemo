//
//  IMTextDisplayView.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/16.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTextDisplayView : UIView

@property (nonatomic, strong) NSAttributedString *attrString;

- (void)showInView:(UIView *)view withAttrText:(NSAttributedString *)attrText animation:(BOOL)animation;

@end
