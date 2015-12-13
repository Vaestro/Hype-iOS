//
//  THLPerkItemStoreServiceInterface.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;
@protocol THLPerkItemStoreServiceInterface <NSObject>
- (BFTask *)fetchAllPerkStoreItems;
@end
