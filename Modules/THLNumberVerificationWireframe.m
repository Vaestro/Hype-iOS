//
//  THLNumberVerificationWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLNumberVerificationWireframe.h"
#import "THLNumberVerificationPresenter.h"

@interface THLNumberVerificationWireframe()
@property (nonatomic, strong) THLNumberVerificationPresenter *presenter;
@end

@implementation THLNumberVerificationWireframe
- (instancetype)init {
	if (self = [super init]) {
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_presenter = [[THLNumberVerificationPresenter alloc] initWithWireframe:self];
}

- (id<THLNumberVerificationModuleInterface>)moduleInterface {
	return _presenter;
}
@end
