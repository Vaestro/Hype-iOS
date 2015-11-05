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
//	[[UINavigationBar appearance] setBarTintColor:[THLStyleKit primaryColor]];
//	[[UINavigationBar appearance] setTintColor:[THLStyleKit lightTextColor]];
	[[UINavigationBar appearance] setTranslucent:NO];
//	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [THLStyleKit lightTextColor]}];
	[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Back Arrow"]];
	[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Back Arrow"]];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
														 forBarMetrics:UIBarMetricsDefault];

//	[[UIButton appearance] setTitleColor:[THLStyleKit lightTextColor]];
}

@end
