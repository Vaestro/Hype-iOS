//
//  THLMessageListInteractor.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListInteractor.h"

@implementation THLMessageListInteractor
- (instancetype)initWithDataManager:(THLMessageListDataManager *)dataManager {
    if (self = [super init]) {
        _dataManager = dataManager;
        //_dataManager.delegate = self;
    }
    return self;
}

@end
