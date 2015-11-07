//
//  UIView+DimView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DimView)
@property (nonatomic, strong) UIView *dimmingView;
- (void)dimView;
- (void)undimView;

@end