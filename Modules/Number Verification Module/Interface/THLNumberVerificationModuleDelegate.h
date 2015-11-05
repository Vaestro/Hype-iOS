//
//  THLNumberVerificationModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol THLNumberVerificationModuleInterface;

@protocol THLNumberVerificationModuleDelegate <NSObject>
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didVerifyNumber:(NSString *)number;
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didFailToVerifyNumber:(NSError *)error;
@end
