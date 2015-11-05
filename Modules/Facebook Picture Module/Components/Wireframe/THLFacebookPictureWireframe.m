//
//  THLFacebookPictureWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLFacebookPictureWireframe.h"
#import "THLFacebookPicturePresenter.h"
#import "THLFacebookPictureInteractor.h"

@interface THLFacebookPictureWireframe()
@property (nonatomic, strong) THLFacebookPictureInteractor *interactor;
@property (nonatomic, strong) THLFacebookPicturePresenter *presenter;
@end

@implementation THLFacebookPictureWireframe

- (instancetype)initWithFetchService:(THLFacebookProfilePictureURLFetchService *)fetchService {
	if (self = [super init]) {
		_fetchService = fetchService;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_interactor = [[THLFacebookPictureInteractor alloc] initWithFetchService:_fetchService];
	_presenter = [[THLFacebookPicturePresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (id<THLFacebookPictureModuleInterface>)moduleInterface {
	return _presenter;
}
@end
