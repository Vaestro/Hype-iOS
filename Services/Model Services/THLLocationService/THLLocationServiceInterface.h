//
//  THLLocationServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;
@class CLPlacemark;

@protocol THLLocationServiceInterface <NSObject>
- (BFTask<CLPlacemark *> *)geocodeAddress:(NSString *)address;
@end
