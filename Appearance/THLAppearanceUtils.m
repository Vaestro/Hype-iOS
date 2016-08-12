//
//  THLAppearanceUtils.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLAppearanceUtils.h"
#import "NUISettings.h"
#import "THLAppearanceConstants.h"

@implementation THLAppearanceUtils
+ (void)applyStyles {
	[self applyNUIStylesheet];
	[self applyGlobalAppearance];
}

+ (void)applyNUIStylesheet {
	[NUISettings initWithStylesheet:@"THLNUIStyleSheet"];
}

+ (void)applyGlobalAppearance {
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:kTHLNUIGrayFontColor];
    
	[[UINavigationBar appearance] setTranslucent:NO];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kTHLNUIPrimaryFontColor,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Raleway-Regular" size:18.0],
                                                           NSKernAttributeName: @2.0f}];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_button"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_button"]];

	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
														 forBarMetrics:UIBarMetricsDefault];

    [[UITabBar appearance] setTintColor:kTHLNUIAccentColor];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTranslucent:NO];
    
//	[[UIButton appearance] setTitleColor:[THLStyleKit lightTextColor]];
}

@end
