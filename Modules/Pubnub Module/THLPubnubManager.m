//
//  THLPubnubManager.m
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPubnubManager.h"

@implementation THLPubnubManager

+ (id)sharedInstance {
    static THLPubnubManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
