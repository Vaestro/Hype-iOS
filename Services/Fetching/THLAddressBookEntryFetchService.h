//
//  THLAddressBookEntryFetchService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@interface THLAddressBookEntryFetchService : NSObject

- (BFTask *)fetchAllEntries:(BOOL)includeThumbnails;

@end
