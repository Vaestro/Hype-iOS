//
//  THLDataStoreDomain.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEntity;

typedef BOOL (^DomainMemberTestBlock)(THLEntity *entity);

@interface THLDataStoreDomain : NSObject
- (instancetype)initWithMemberTestBlock:(DomainMemberTestBlock)memberTestBlock;
- (instancetype)initWithMembers:(NSArray *)members;

- (BOOL)containsMember:(THLEntity *)entity;
- (void)addMember:(THLEntity *)entity;
- (void)addMembers:(NSArray *)entities;
- (void)removeMember:(THLEntity *)entity;
- (void)removeMembers:(NSArray *)entities;
- (void)resetMembers;
@end
