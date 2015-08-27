//
//  THLEventDetailInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailInteractor.h"

@implementation THLEventDetailInteractor
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
	}
	return self;
}



@end
