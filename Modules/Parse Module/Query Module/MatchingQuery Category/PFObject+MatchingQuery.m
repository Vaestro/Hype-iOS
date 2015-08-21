//
//  PFObject+MatchingQuery.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "PFObject+MatchingQuery.h"
#import "PFQuery.h"

@implementation PFObject (MatchingQuery)
- (PFQuery *)matchingQuery {
	PFQuery *query = [[self class] query];
	[query whereKey:@"objectId" equalTo:self.objectId];
	return query;
}
@end
