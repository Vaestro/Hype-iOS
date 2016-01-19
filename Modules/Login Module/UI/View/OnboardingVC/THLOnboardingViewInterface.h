//
//  THLLoginView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLOnboardingViewInterface <NSObject>
@property (nonatomic) NSNumber *showActivityIndicator;
@property (nonatomic, strong) RACCommand *skipCommand;
@property (nonatomic, strong) RACCommand *loginCommand;
@end