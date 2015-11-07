//
//  THLEventNavigationController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventNavigationController.h"

@interface THLEventNavigationController ()

@end

@implementation THLEventNavigationController
@dynamic navigationBar;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
	if (self = [super initWithNavigationBarClass:[THLEventNavigationBar class] toolbarClass:nil]) {
		[self setViewControllers:@[rootViewController]];
	}
	return self;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
