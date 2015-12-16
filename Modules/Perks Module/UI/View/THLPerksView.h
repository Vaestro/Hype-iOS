//
//  THLPerksView.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;

@protocol THLPerksView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic) float currentUserCredit;
@property (nonatomic) BOOL showRefreshAnimation;
@property (nonatomic) BOOL viewAppeared;
@end
