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
@property (nonatomic, strong) THLViewDataSource *dataSource;
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic) BOOL showRefreshAnimation;
@end
