//
//  THLEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "AutoCoding.h"

@implementation THLEntity
- (BOOL)updateWith:(THLEntity *)newEntity {
	return NO;
}

- (BOOL)isEquivalentTo:(THLEntity *)cmpEntity {
	return ([cmpEntity isKindOfClass:[self class]] &&
			[self.objectId isEqualToString:cmpEntity.objectId]);
}

- (BOOL)shouldUpdateWith:(THLEntity *)newEntity {
	return ([newEntity isKindOfClass:[self class]] &&
			![self isEquivalentTo:newEntity]);
}

- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		THLEntity *cmp = (THLEntity *)object;
		return [cmp.objectId isEqualToString:self.objectId];
	}
	return NO;
}

- (NSUInteger)hash {
	return self.objectId.hash;
}

@end
