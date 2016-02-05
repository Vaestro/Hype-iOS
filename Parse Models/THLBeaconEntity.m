//
//  THLBeaconEntity.m
//  HypeUp
//
//  Created by Daniel Aksenov on 2/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLBeaconEntity.h"

@implementation THLBeaconEntity
@dynamic UUID;
@dynamic major;
@dynamic minor;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Beacon";
}
@end
