//
//  PFObject+MatchingQuery.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "PFObject.h"

@class PFQuery;
@interface PFObject (MatchingQuery)
- (PFQuery *)matchingQuery;
@end
