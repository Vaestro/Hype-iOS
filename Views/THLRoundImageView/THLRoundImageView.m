//
//  THLRoundImageView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLRoundImageView.h"

@implementation THLRoundImageView
- (void)updateConstraints {
	[super updateConstraints];
	self.layer.cornerRadius = ViewWidth(self);
}

@end
