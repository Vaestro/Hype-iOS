//
//  THLPropertyDescriptor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/19/15.
//
//	Credit to Denis Hennessy
//  Copyright (c) 2014 Peer Assembly. All rights reserved.

#import "THLPropertyDescriptor.h"

@implementation THLPropertyDescriptor

- (id)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter {
	if (self = [super init]) {
		_defaultsKey = defaultsKey;
		_type = type;
		_isSetter = isSetter;
	}
	return self;
}

@end
