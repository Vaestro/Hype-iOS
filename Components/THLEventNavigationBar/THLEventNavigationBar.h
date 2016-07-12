//
//  THLEventNavigationBar.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLKFlexibleHeightBar.h"
#import "SwipeView.h"

@class THLEvent;
@class THLLocation;

@interface THLEventNavigationBar : BLKFlexibleHeightBar
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) UILabel *minimumTitleLabel;
@property (nonatomic, strong) NSMutableArray *images;


- (instancetype)initWithFrame:(CGRect)frame event:(THLEvent *)event venue:(THLLocation *)venue;
@end
