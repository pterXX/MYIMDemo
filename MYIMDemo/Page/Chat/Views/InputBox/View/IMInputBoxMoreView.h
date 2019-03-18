//
//  IMInputBoxMoreView.h
//  KXiniuCloud
//
//  Created by eims on 2018/5/7.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>



@class IMInputBoxMoreView;

@interface IMInputBoxMoreView : UIView

@property (nonatomic, strong) UIView        *topLine;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;

@end
