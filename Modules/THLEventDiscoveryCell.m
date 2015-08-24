//
//  THLEventDiscoveryCell.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryCell.h"

@interface THLEventDiscoveryCell()

@end

@implementation THLEventDiscoveryCell
@synthesize locationName;
@synthesize eventName;
@synthesize locationNeighborhood;
@synthesize time;

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupAndLayoutView];
	}
	return self;
}

- (void)setupAndLayoutView {
	
}

+ (NSString *)identifier {
	return NSStringFromClass(self);
}
@end
