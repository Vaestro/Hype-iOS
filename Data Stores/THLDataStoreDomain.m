//
//  THLDataStoreDomain.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDataStoreDomain.h"
#import "THLEntity+DataStore.h"
@interface THLDataStoreDomain()
@property (nonatomic, strong) NSMutableSet *includedMembers;
@property (nonatomic, strong) NSMutableSet *excludedMembers;
@property (nonatomic, copy) DomainMemberTestBlock memberTestBlock;
@end

@implementation THLDataStoreDomain
- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (instancetype)initWithMemberTestBlock:(DomainMemberTestBlock)memberTestBlock {
	if (self = [self init]) {
		_memberTestBlock = memberTestBlock;
	}
	return self;
}

- (instancetype)initWithMembers:(NSArray *)members {
	if (self = [self init]) {
		[self addMembers:members];
	}
	return self;
}

#pragma mark - Constructors
- (NSMutableSet *)includedMembers {
	if (!_includedMembers) {
		NSMutableSet *set = [NSMutableSet new];
		_includedMembers = set;
	}
	return _includedMembers;
}

- (NSMutableSet *)excludedMembers {
	if (!_excludedMembers) {
		NSMutableSet *set = [NSMutableSet new];
		_excludedMembers = set;
	}
	return _excludedMembers;
}

#pragma mark - Interface
- (BOOL)containsMember:(THLEntity *)entity {
	return (![self excludedSetContainsMember:entity] &&
			([self includedSetContainsMember:entity] || [self testBlockContainsMember:entity]));
}

- (void)addMember:(THLEntity *)entity {
	[self.includedMembers addObject:entity.key];
	[self.excludedMembers removeObject:entity.key];
}

- (void)addMembers:(NSArray *)entities {
	for (THLEntity *entity in entities) {
		[self addMember:entity];
	}
}

- (void)removeMember:(THLEntity *)entity {
	[self.excludedMembers addObject:entity.key];
	[self.includedMembers removeObject:entity.key];
}

- (void)removeMembers:(NSArray *)entities {
	for (THLEntity *entity in entities) {
		[self removeMember:entity];
	}
}

- (void)resetMembers {
	_excludedMembers = nil;
	_includedMembers = nil;
}

#pragma mark - Internal
- (BOOL)testBlockContainsMember:(THLEntity *)entity {
	return _memberTestBlock && _memberTestBlock(entity);
}

- (BOOL)includedSetContainsMember:(THLEntity *)entity {
	return [_includedMembers containsObject:entity.key];
}

- (BOOL)excludedSetContainsMember:(THLEntity *)entity {
	return [_excludedMembers containsObject:entity.key];
}
@end
