//
//  THLWaitlistEntry.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistEntry.h"

@implementation THLWaitlistEntry
@dynamic email;
@dynamic code;
@dynamic approved;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"WaitlistEntry";
}
@end
