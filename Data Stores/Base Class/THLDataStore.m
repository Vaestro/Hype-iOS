//
//  THLDataStore.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDataStore.h"
#import "THLDatabaseManager.h"

@interface THLDataStore()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@end

@implementation THLDataStore
+ (instancetype)sharedDataStore {
	static THLDataStore *_sharedDataStore = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedDataStore = [self new];
		_sharedDataStore.rwConnection = [THLDatabaseManager newConnection];
	});

	return _sharedDataStore;
}

- (instancetype)init {
	if (self = [super init]) {
		
	}
	return self;
}

- (void)processEntities:(NSArray *)entities inDomain:(DataStoreEntityDomainTest)domainTestBlock {
	NSAssert(NO, @"Process entities method must be overriden by subclasses!");
}

@end
