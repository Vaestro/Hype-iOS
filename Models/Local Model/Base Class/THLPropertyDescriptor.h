//
//  THLPropertyDescriptor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/19/15.
//
//	Credit to Denis Hennessy
//  Copyright (c) 2014 Peer Assembly. All rights reserved.

#import <Foundation/Foundation.h>

@interface THLPropertyDescriptor : NSObject

@property (nonatomic, readonly) NSString *defaultsKey;
@property (nonatomic, readonly) BOOL isSetter;
@property (nonatomic, readonly) NSString *type;

- (id)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter;


@end
