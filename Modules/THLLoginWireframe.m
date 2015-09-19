//
//  THLLoginWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginWireframe.h"
#import "THLLoginInteractor.h"
#import "THLLoginPresenter.h"
@class THLLoginInteractor;
@class THLLoginPresenter;

@interface THLLoginWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLLoginInteractor *interactor;
@property (nonatomic, strong) THLLoginPresenter *presenter;

@end
@implementation THLLoginWireframe
- (instancetype)init {
	if (self = [super init]) {
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_interactor = [[THLLoginInteractor alloc] initWithLoginService:nil];
	_presenter = [[THLLoginPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
}
@end
