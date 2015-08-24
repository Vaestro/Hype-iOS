//
//  THLEventDiscoveryView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;

@protocol THLEventDiscoveryView <NSObject>
@property (nonatomic, assign) THLViewDataSource *dataSource;
@property (nonatomic, assign) RACCommand *selectedIndexPathCommand;
@end
