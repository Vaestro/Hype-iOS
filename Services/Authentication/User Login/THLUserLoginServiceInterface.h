//
//  THLUserLoginServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;

@protocol THLUserLoginServiceInterface <NSObject>
- (BFTask *)loginUser;
@end
