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
	[[UINavigationBar appearance] setBarTintColor:kTHLNUIPrimaryBackgroundColor];
//	[[UINavigationBar appearance] setTintColor:[THLStyleKit lightTextColor]];
	[[UINavigationBar appearance] setTranslucent:NO];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kTHLNUIPrimaryFontColor,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Raleway-Regular" size:18.0],
                                                           NSKernAttributeName: @2}];
	[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Back Arrow"]];
	[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Back Arrow"]];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
														 forBarMetrics:UIBarMetricsDefault];

    [[UITabBar appearance] setTintColor:kTHLNUIAccentColor];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    
//	[[UIButton appearance] setTitleColor:[THLStyleKit lightTextColor]];
}

@end
