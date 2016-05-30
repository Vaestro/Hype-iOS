//
//  THLEventNavigationBar.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLKFlexibleHeightBar.h"

@interface THLEventNavigationBar : BLKFlexibleHeightBar
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) UILabel *minimumTitleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) RACCommand *detailDisclosureCommand;

- (void)setExclusiveEventLabel;
-(void)addGradientLayer;
@end
